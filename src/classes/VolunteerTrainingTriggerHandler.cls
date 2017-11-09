public class VolunteerTrainingTriggerHandler extends TriggerHandler {
    
    private List<Volunteer_Training__c> newList;
    private Map<Id, Volunteer_Training__c> newMap;
    private Map<Id, Volunteer_Training__c> oldMap;
    
    public VolunteerTrainingTriggerHandler() {
        this.newList = (List<Volunteer_Training__c>) Trigger.new;
        this.newMap = (Map<Id, Volunteer_Training__c>) Trigger.newMap;
        
        this.oldMap = Trigger.oldMap != null ?
            (Map<Id, Volunteer_Training__c>) Trigger.oldMap :
            new Map<Id, Volunteer_Training__c>();
    }
    
    public override void afterUpdate() {
        this.updateAttendancesWithChangedStartDate();
    }
    
    /**
     * @description Checks to see if the start date and time were changed
     * on the training record. If so, the child attendance records are
     * updated with that new date and time. This only needs to be done in the
     * afterUpdate context since no other contexts would make sense.
     */
    private void updateAttendancesWithChangedStartDate() {
        Map<Id, Datetime> changedDates = new Map<Id, Datetime>();
        List<Volunteer_Training_Attendance__c> attendances = new List<Volunteer_Training_Attendance__c>();
        
        // check for changes
        for (Id vtId : this.newMap.keySet()) {
            Volunteer_Training__c newTraining = this.newMap.get(vtId);
            Volunteer_Training__c oldTraining = this.oldMap.get(vtId);
            
            if (oldTraining == null || newTraining.StartDateTime__c != oldTraining.StartDateTime__c) {
                changedDates.put(vtId, newTraining.StartDateTime__c);
            }
        }
        
        if (!changedDates.isEmpty()) {
            // get the related volunteer training attendance records.
            for (Volunteer_Training_Attendance__c vta : [
                SELECT
                    Id,
                    StartDateTime__c,
                    Volunteer_Training__c
                FROM Volunteer_Training_Attendance__c
                WHERE Volunteer_Training__c IN :changedDates.keySet()
            ]) {
                
                vta.StartDateTime__c = changedDates.get(vta.Volunteer_Training__c);
                attendances.add(vta);
            }
        }
        
        if (!attendances.isEmpty()) {
            update attendances;
        }
    }
}