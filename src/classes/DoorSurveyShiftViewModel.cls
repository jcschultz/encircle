public class DoorSurveyShiftViewModel {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String shiftName;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public Boolean selected;
    
    public DoorSurveyShiftViewModel(GW_Volunteers__Volunteer_Hours__c h) {
        this.id = h.Id;
        this.shiftName = h.GW_Volunteers__Volunteer_Job__r.Name;
        this.startTime = h.GW_Volunteers__Shift_Start_Date_Time__c.format('h:mm a');
    }
    
    public DoorSurveyShiftViewModel(GW_Volunteers__Volunteer_Shift__c s) {
        this.id = s.Id;
        this.shiftName = s.GW_Volunteers__Volunteer_Job__r.Name;
        this.startTime = s.GW_Volunteers__Start_Date_Time__c.format('h:mm a');
        this.selected = false;
    }
}