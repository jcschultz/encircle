public class CalendarDataViewModel {
    @AuraEnabled
    public List<CalendarRowViewModel> days;
    @AuraEnabled
    public Date nextStartDate;
    @AuraEnabled
    public Date nextEndDate;
    
    public CalendarDataViewModel() {
        days = new List<CalendarRowViewModel>();
    }
}