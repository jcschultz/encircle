public class VolunteerHoursViewModel {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String jobName;
    @AuraEnabled
    public Id jobId;
    @AuraEnabled
    public Id shiftId;
    @AuraEnabled
    public Id volunteerId;
    @AuraEnabled
    public String volunteerFirstName;
    @AuraEnabled
    public String volunteerLastName;
    @AuraEnabled
    public Decimal duration;
    @AuraEnabled
    public Datetime startDatetime;
    @AuraEnabled
    public Date startDate;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String locationCity;
    @AuraEnabled
    public String locationState;
    @AuraEnabled
    public String locationStreet;
    @AuraEnabled
    public String locationZip;
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
    
    public Decimal numberOfVolunteers;
    
    public VolunteerHoursViewModel() {}
    
    public VolunteerHoursViewModel(GW_Volunteers__Volunteer_Hours__c h) {
        id = h.Id;
        volunteerId = h.GW_Volunteers__Contact__c;
        jobName = h.GW_Volunteers__Volunteer_Job__r.Name;
        jobId = h.GW_Volunteers__Volunteer_Job__c;
        shiftId = h.GW_Volunteers__Volunteer_Shift__c;
        duration = h.GW_Volunteers__Hours_Worked__c;
        startDatetime = h.GW_Volunteers__Shift_Start_Date_Time__c;
        startDate = h.GW_Volunteers__Start_Date__c;
        status = h.GW_Volunteers__Status__c;
        volunteerFirstName = h.GW_Volunteers__Contact__r.FirstName;
        volunteerLastName = h.GW_Volunteers__Contact__r.LastName;
        locationCity = h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_City__c;
        locationState = h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location__c;
        locationStreet = h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Street__c;
        locationZip = h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Zip_Postal_Code__c;
    }
}