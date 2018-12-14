public class DoorSurveyShiftViewModel {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String shiftName;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public Boolean selected;
    
    public DoorSurveyShiftViewModel(VolunteerHoursViewModel h) {
        this.id = h.id;
        this.shiftName = h.jobName;
        this.startTime = h.startDatetime.format('h:mm a');
    }
    
    public DoorSurveyShiftViewModel(VolunteerShiftViewModel s) {
        this.id = s.id;
        this.shiftName = s.jobName;
        this.startTime = s.startDateTime.format('h:mm a');
        this.selected = false;
    }
}