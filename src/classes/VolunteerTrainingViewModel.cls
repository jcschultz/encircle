public class VolunteerTrainingViewModel {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public Datetime startDateTime;
    @AuraEnabled
    public Datetime endDateTime;
    @AuraEnabled
    public String location;
    @AuraEnabled
    public String description;
    public Boolean completed;
    public Id trainingId;
    public Id volunteerId;
    
    public VolunteerTrainingViewModel() {}
    
    public VolunteerTrainingViewModel(Volunteer_Training__c vt) {
        id = vt.Id;
        startDateTime = vt.StartDateTime__c;
        endDateTime = vt.EndDateTime__c;
        location = vt.Location__c;
        description = vt.Description__c;
    }
    
    public VolunteerTrainingViewModel(Volunteer_Training_Attendance__c vta) {
        id = vta.Id;
        startDateTime = vta.Volunteer_Training__r.StartDateTime__c;
        endDateTime = vta.Volunteer_Training__r.EndDateTime__c;
        location = vta.Volunteer_Training__r.Location__c;
        description = vta.Volunteer_Training__r.Description__c;
        completed = vta.Completed_Training__c;
        trainingId = vta.Volunteer_Training__c;
        volunteerId = vta.Volunteer__c;
    }
}