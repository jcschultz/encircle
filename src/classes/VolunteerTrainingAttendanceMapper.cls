public virtual without sharing class VolunteerTrainingAttendanceMapper {
    
    @TestVisible
    private static VolunteerTrainingAttendanceMapper instance;
    
    protected VolunteerTrainingAttendanceMapper() { }
    
    public static VolunteerTrainingAttendanceMapper getInstance() {
        if (instance != null) {
            return instance;
        }
    
        instance = new VolunteerTrainingAttendanceMapper();
        return instance;
    }
    
    public virtual List<VolunteerTrainingViewModel> getUpcomingAttendanceByVolunteerId(Id volunteerId) {
        String whereClause = ' WHERE Volunteer__c = \'' + volunteerId + '\'';
        whereClause += ' AND Volunteer_Training__r.StartDateTime__c > ' +
            Datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' ';
        
        return queryAttendance(whereClause);
    }
    
    public virtual List<VolunteerTrainingViewModel> getAttendanceByIds(List<Id> ids) {
        String idString = String.join(ids, '\', \'');
        String whereClause = ' WHERE Id IN (\'' + idString + '\') ';
        
        return queryAttendance(whereClause);
    }
    
    public virtual List<VolunteerTrainingViewModel> saveAttendance(List<VolunteerTrainingViewModel> attendances) {
        List<Volunteer_Training_Attendance__c> records = new List<Volunteer_Training_Attendance__c>();
        
        for (VolunteerTrainingViewModel a : attendances) {
            records.add(new Volunteer_Training_Attendance__c(
                Id = a.id,
                Completed_Training__c = (a.completed == true),
                Volunteer_Training__c = a.trainingId,
                Volunteer__c = a.volunteerId
            ));
        }
        
        if (records.isEmpty()) {
            return null;
        }
        
        upsert records;
    
        Map<Id, Volunteer_Training_Attendance__c> Idmap = new Map<Id, Volunteer_Training_Attendance__c>(records);
        List<Id> Idlist = new List<Id>();
        Idlist.addAll(Idmap.keySet());
        return getAttendanceByIds(Idlist);
    }
    
    public virtual void deleteAttendance(List<Id> ids) {
        List<Volunteer_Training_Attendance__c> records = new List<Volunteer_Training_Attendance__c>();
        
        for (Id id : ids) {
            records.add(new Volunteer_Training_Attendance__c(Id = id));
        }
        
        delete records;
    }
    
    private List<VolunteerTrainingViewModel> queryAttendance(String whereClause) {
        List<VolunteerTrainingViewModel> trainings;
        
        List<String> fields = new List<String>{
            'Id',
            'Completed_Training__c',
            'Volunteer__c',
            'Volunteer_Training__c',
            'Volunteer_Training__r.Description__c',
            'Volunteer_Training__r.EndDateTime__c',
            'Volunteer_Training__r.Location__c',
            'Volunteer_Training__r.StartDateTime__c'
        };
        
        String queryString = String.format(
            'SELECT {0} FROM Volunteer_Training_Attendance__c ',
            new List<String>{String.join(fields, ', ')}
        );
        
        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }
        
        queryString += ' ORDER BY Volunteer_Training__r.StartDateTime__c ASC ';
        
        for (Volunteer_Training_Attendance__c vta : Database.query(queryString)) {
            if (trainings == null) {
                trainings = new List<VolunteerTrainingViewModel>();
            }
            
            trainings.add(new VolunteerTrainingViewModel(vta));
        }
        
        
        return trainings;
    }
}