public class VolunteerHoursViewModel {
    @AuraEnabled
    public String jobName;
    @AuraEnabled
    public Id jobId;
    @AuraEnabled
    public Id shiftId;
    @AuraEnabled
    public Id hoursId;
    @AuraEnabled
    public Decimal duration;
    @AuraEnabled
    public Datetime startDatetime;
    @AuraEnabled
    public String monthLabel {
        get {
            return startDatetime.format('MMMMM');
        }
    }
    @AuraEnabled
    public String monthAbbreviation {
        get {
            return startDatetime.format('MMM');
        }
    }
    @AuraEnabled
    public Integer dateOfMonth {
        get {
            return startDatetime.day();
        }
    }
    @AuraEnabled
    public String dayOfWeek {
        get {
            return startDatetime.format('EEE');
        }
    }
    @AuraEnabled
    public String startTime {
        get {
            return startDatetime.format('h:mm a');
        }
    }
}