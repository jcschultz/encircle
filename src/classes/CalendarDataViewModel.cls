public class CalendarDataViewModel {
    @AuraEnabled
    public List<CalendarRowViewModel> days;
    @AuraEnabled
    public Date nextStartDate;
    @AuraEnabled
    public Date nextEndDate;
    @AuraEnabled
    public List<String> cities;
    
    public CalendarDataViewModel() {
        days = new List<CalendarRowViewModel>();
        cities = new List<String>();
    }
}