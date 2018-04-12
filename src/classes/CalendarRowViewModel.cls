public class CalendarRowViewModel {
    public static final String ROW_TYPE_DAY = 'day';
    public static final String ROW_TYPE_MONTH = 'month';
    
    @AuraEnabled
    public String rowType;
    @AuraEnabled
    public Integer dateOfMonth;
    @AuraEnabled
    public String dayOfWeek;
    @AuraEnabled
    public String monthLabel;
    @AuraEnabled
    public String monthAbbreviation;
    @AuraEnabled
    public List<CalendarShiftViewModel> shifts;
    
    public CalendarRowViewModel(String rowType) {
        this.shifts = new List<CalendarShiftViewModel>();
        this.rowType = rowType;
    }
}