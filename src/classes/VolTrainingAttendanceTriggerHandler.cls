public class VolTrainingAttendanceTriggerHandler extends TriggerHandler {
    
    private List<Volunteer_Training_Attendance__c> newList;
    private Map<Id, Volunteer_Training_Attendance__c> newMap;
    private Map<Id, Volunteer_Training_Attendance__c> oldMap;
    
    public VolTrainingAttendanceTriggerHandler() {
        this.newList = (List<Volunteer_Training_Attendance__c>) Trigger.new;
        this.newMap = (Map<Id, Volunteer_Training_Attendance__c>) Trigger.newMap;
        
        this.oldMap = Trigger.oldMap != null ?
            (Map<Id, Volunteer_Training_Attendance__c>) Trigger.oldMap :
            new Map<Id, Volunteer_Training_Attendance__c>();
    }
    
    public override void beforeInsert() {
        this.updateStartDate();
    }
    
    public override void beforeUpdate() {
        this.updateStartDate();
    }
    
    /**
     * @description This method will look at the attendance records to see if
     * they are new or if they've been reparented to a different training
     * record. If so, the attendance record's StartDateTime__c field will be
     * updated to match the current parent training record.
     */
    private void updateStartDate() {
        Map<Id, Volunteer_Training__c> trainings;
        Set<String> trainingIds = new Set<String>();
        List<Volunteer_Training_Attendance__c> vtasToUpdate =
            new List<Volunteer_Training_Attendance__c>();
        
        // check for new records or changes.
        for (Volunteer_Training_Attendance__c newVta : this.newList) {
            if (newVta.Volunteer_Training__c != null && (
                Trigger.isInsert ||
                newVta.Volunteer_Training__c != this.oldMap.get(newVta.Id).Volunteer_Training__c
            )) {
                
                trainingIds.add(newVta.Volunteer_Training__c);
                vtasToUpdate.add(newVta);
            }
        }
        
        // get the parent training records.
        if (!trainingIds.isEmpty() && !vtasToUpdate.isEmpty()) {
            trainings = new Map<Id, Volunteer_Training__c>(
                TrainingService.getTrainingsById(trainingIds)
            );
        }
        
        // update the attendance records that need to be updated.
        if (trainings != null && !trainings.isEmpty()) {
            for (Volunteer_Training_Attendance__c vta : vtasToUpdate) {
                vta.StartDateTime__c = trainings.get(vta.Volunteer_Training__c).StartDateTime__c;
            }
        }
    }
}