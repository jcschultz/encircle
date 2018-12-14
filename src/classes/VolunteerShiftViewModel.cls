public class VolunteerShiftViewModel {
    
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String description;
    @AuraEnabled
    public Decimal volunteersDesired;
    @AuraEnabled
    public Decimal duration;
    @AuraEnabled
    public String locationCity;
    @AuraEnabled
    public String locationState;
    @AuraEnabled
    public String locationStreet;
    @AuraEnabled
    public String locationZip;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Decimal volunteersStillNeeded;
    @AuraEnabled
    public Datetime startDateTime;
    @AuraEnabled
    public Decimal totalVolunteers;
    @AuraEnabled
    public Id jobId;
    @AuraEnabled
    public String jobName;
    @AuraEnabled
    public Id campaignId;
    @AuraEnabled
    public List<VolunteerHoursViewModel> hours;
    
    public VolunteerShiftViewModel() {}
    
    public VolunteerShiftViewModel(GW_Volunteers__Volunteer_Shift__c vs) {
        id = vs.Id;
        description = vs.GW_Volunteers__Description__c;
        volunteersDesired = vs.GW_Volunteers__Desired_Number_of_Volunteers__c;
        duration = vs.GW_Volunteers__Duration__c;
        locationCity = vs.GW_Volunteers__Job_Location_City__c;
        locationState = vs.GW_Volunteers__Job_Location_State_Province__c;
        locationStreet = vs.GW_Volunteers__Job_Location_Street__c;
        locationZip = vs.GW_Volunteers__Job_Location_Zip_Postal_Code__c;
        name = vs.Name;
        volunteersStillNeeded = vs.GW_Volunteers__Number_of_Volunteers_Still_Needed__c;
        startDateTime = vs.GW_Volunteers__Start_Date_Time__c;
        totalVolunteers = vs.GW_Volunteers__Total_Volunteers__c;
        jobId = vs.GW_Volunteers__Volunteer_Job__c;
        jobName = vs.GW_Volunteers__Volunteer_Job__r.Name;
        campaignId = vs.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__c;
    }
}