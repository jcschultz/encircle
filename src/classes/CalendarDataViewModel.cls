public class CalendarDataViewModel {
    public static final String ROW_TYPE_DAY = 'day';
    public static final String ROW_TYPE_MONTH = 'month';
    
    @AuraEnabled
    public List<Row> rows;
    
    public CalendarDataViewModel() {
        rows = new List<Row>();
    }
    
    public class Row {
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
        public List<CalendarDataViewModel.Shift> shifts;
        
        public Row(String rowType) {
            this.shifts = new List<CalendarDataViewModel.Shift>();
            this.rowType = rowType;
        }
    }
    
    public class Shift {
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
        public List<CalendarDataViewModel.Volunteer> volunteers;
        
        public Shift() {
            this.volunteers = new List<CalendarDataViewModel.Volunteer>();
            this.jobClass = '';
            this.selected = false;
        }
    }
    
    public class Volunteer {
        @AuraEnabled
        public String firstInitial;
        @AuraEnabled
        public String lastName;
    }
}