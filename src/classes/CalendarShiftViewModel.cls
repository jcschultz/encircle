public class CalendarShiftViewModel {
    @AuraEnabled
    public String jobName;
    @AuraEnabled
    public String jobId;
    @AuraEnabled
    public String shiftId;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public Decimal duration;
    @AuraEnabled
    public Integer volunteersNeeded;
    @AuraEnabled
    public Integer volunteersStillNeeded;
    @AuraEnabled
    public Integer volunteersSignedUp;
    @AuraEnabled
    public String jobClass;
    @AuraEnabled
    public Boolean selected;
    @AuraEnabled
    public List<CalendarVolunteerViewModel> volunteers;
    @AuraEnabled
    public String city;
    
    public CalendarShiftViewModel() {
        this.volunteers = new List<CalendarVolunteerViewModel>();
        this.jobClass = '';
        this.selected = false;
    }
}