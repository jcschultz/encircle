public virtual without sharing class VolunteerHourMapper {
    
    public static final String COMPLETED_STATUS;
    public static final List<String> SIGNED_UP_STATUSES;
    
    static {
        COMPLETED_STATUS = 'Completed';
    
        SIGNED_UP_STATUSES = new List<String>{
            'Prospect',
            'Confirmed',
            'Web Sign Up'
        };
    }
    
    @TestVisible
    private static VolunteerHourMapper instance;
    
    protected VolunteerHourMapper() { }
    
    public static VolunteerHourMapper getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerHourMapper();
        return instance;
    }
    
    public virtual List<VolunteerHoursViewModel> getHoursByVolunteerIdsAndDate(Id[] volunteerIds, Date startDate, Date endDate) {
        String joinedIds = '\'' + String.join(volunteerIds, '\',\'') + '\'';
        
        String whereClause = ' WHERE GW_Volunteers__Contact__c IN (' + joinedIds + ') ';
        
        if (startDate != null) {
            String startDateString = Datetime.newInstance(startDate, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd');
            whereClause += ' AND GW_Volunteers__Start_Date__c >= ' + startDateString + ' ';
        }
        
        if (endDate != null) {
            String endDateString = Datetime.newInstance(endDate, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd');
            whereClause += ' AND GW_Volunteers__Start_Date__c < ' + endDateString + ' ';
        }
        
        return queryHours(whereClause);
    }
    
    public virtual List<VolunteerHoursViewModel> getHoursById(Id[] ids) {
        String joinedIds = '\'' + String.join(ids, '\',\'') + '\'';
        String whereClause = ' WHERE Id IN (' + joinedIds + ') ';
        return queryHours(whereClause);
    }
    
    public virtual List<VolunteerHoursViewModel> getHoursByShiftId(Id[] shiftIds) {
        String joinedIds = '\'' + String.join(shiftIds, '\',\'') + '\'';
        String whereClause = ' WHERE GW_Volunteers__Volunteer_Shift__c IN (' + joinedIds + ') ';
        return queryHours(whereClause);
    }
    
    public virtual List<VolunteerHoursViewModel> queryHours(String whereClause) {
        List<VolunteerHoursViewModel> hours;
        
        List<String> fields = new List<String>{
            'GW_Volunteers__Contact__c',
            'GW_Volunteers__Contact__r.FirstName',
            'GW_Volunteers__Contact__r.LastName',
            'Id',
            'GW_Volunteers__Shift_Start_Date_Time__c',
            'GW_Volunteers__Start_Date__c',
            'GW_Volunteers__Volunteer_Job__c',
            'GW_Volunteers__Volunteer_Job__r.Name',
            'GW_Volunteers__Volunteer_Shift__c',
            'GW_Volunteers__Hours_Worked__c',
            'GW_Volunteers__Status__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_City__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Street__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Zip_Postal_Code__c'
        };
        
        String queryString = String.format(
            'SELECT {0} FROM GW_Volunteers__Volunteer_Hours__c ',
            new List<String> {String.join(fields, ',')}
        );
    
        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }
        
        queryString += ' ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ASC';
        
        for (GW_Volunteers__Volunteer_Hours__c h : Database.query(queryString)) {
            if (hours == null) {
                hours = new List<VolunteerHoursViewModel>();
            }
            
            hours.add(new VolunteerHoursViewModel(h));
        }
        
        return hours;
    }
    
    public virtual List<VolunteerHoursViewModel> saveNewHours(VolunteerHoursViewModel[] hours) {
        List<GW_Volunteers__Volunteer_Hours__c> newHours = new List<GW_Volunteers__Volunteer_Hours__c>();
        
        for (VolunteerHoursViewModel h : hours) {
            newHours.add(new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = h.volunteerId,
                GW_Volunteers__Hours_Worked__c = h.duration,
                GW_Volunteers__Number_of_Volunteers__c = 1,
                GW_Volunteers__Start_Date__c = h.startDate,
                GW_Volunteers__Status__c = h.status,
                GW_Volunteers__Volunteer_Job__c = h.jobId,
                GW_Volunteers__Volunteer_Shift__c = h.shiftId
            ));
        }
        
        insert newHours;
        
        List<Id> ids = new List<Id>(
            (new Map<Id, GW_Volunteers__Volunteer_Hours__c>(newHours)).keySet()
        );
        
        return getHoursById(ids);
    }
    
    public virtual List<VolunteerHoursViewModel> completeHours(Id[] ids) {
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>();
    
        for (Id hourId : ids) {
            hours.add(new GW_Volunteers__Volunteer_Hours__c(
                Id = hourId,
                GW_Volunteers__Status__c = COMPLETED_STATUS
            ));
        }
    
        update hours;
    
        return getHoursById(ids);
    }
    
    public virtual void deleteHours(Id[] ids) {
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>();
        
        for (Id hourId : ids) {
            GW_Volunteers__Volunteer_Hours__c h = new GW_Volunteers__Volunteer_Hours__c(
                Id = hourId
            );
            hours.add(h);
        }
        
        delete hours;
    }
}