public virtual without sharing class VolunteerShiftMapper {
    
    @TestVisible
    private static VolunteerShiftMapper instance;
    
    protected VolunteerShiftMapper() { }
    
    public static VolunteerShiftMapper getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerShiftMapper();
        return instance;
    }
    
    public virtual List<VolunteerShiftViewModel> getShiftsByIds(Id[] shiftIds) {
        String joinedIds = '\'' + String.join(shiftIds, '\',\'') + '\'';
        String whereClause = ' WHERE Id IN (' + joinedIds + ') ';
        return queryShifts(whereClause);
    }
    
    public virtual List<VolunteerShiftViewModel> getActiveShiftsBetweenDates(Date startDate, Date endDate) {
        String startDateTime = Datetime.newInstance(startDate, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String endDateTime = Datetime.newInstance(endDate, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        String whereClause = ' WHERE GW_Volunteers__Start_Date_Time__c >= ' + startDateTime;
        whereClause += ' AND GW_Volunteers__Start_Date_Time__c < ' + endDateTime;
        whereClause += ' AND GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__r.IsActive = true ';
        whereClause += ' AND GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Display_On_Website__c = true';
        
        return queryShifts(whereClause);
    }
    
    private List<VolunteerShiftViewModel> queryShifts(String whereClause) {
        List<VolunteerShiftViewModel> shifts;
        
        List<String> fields = new List<String> {
            'Id',
            'Name',
            'GW_Volunteers__Description__c',
            'GW_Volunteers__Desired_Number_of_Volunteers__c',
            'GW_Volunteers__Duration__c',
            'GW_Volunteers__Job_Location_City__c',
            'GW_Volunteers__Job_Location_State_Province__c',
            'GW_Volunteers__Job_Location_Street__c',
            'GW_Volunteers__Job_Location_Zip_Postal_Code__c',
            'GW_Volunteers__Number_of_Volunteers_Still_Needed__c',
            'GW_Volunteers__Start_Date_Time__c',
            'GW_Volunteers__Total_Volunteers__c',
            'GW_Volunteers__Volunteer_Job__c',
            'GW_Volunteers__Volunteer_Job__r.Name',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Volunteer_Website_Time_Zone__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__r.GW_Volunteers__Volunteer_Website_Time_Zone__c',
            'GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__c'
        };
        
        String queryString = String.format(
            'SELECT {0} FROM GW_Volunteers__Volunteer_Shift__c ',
            new List<String> {String.join(fields, ',')}
        );
        
        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }
        
        queryString += ' ORDER BY GW_Volunteers__Start_Date_Time__c ASC ';
        
        for (GW_Volunteers__Volunteer_Shift__c shift : Database.query(queryString)) {
            if (shifts == null) {
                shifts = new List<VolunteerShiftViewModel>();
            }
            
            shifts.add(new VolunteerShiftViewModel(shift));
        }
        
        return shifts;
    }

}