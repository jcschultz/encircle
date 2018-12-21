public virtual without sharing class VolunteerTrainingMapper {
    
    @TestVisible
    private static VolunteerTrainingMapper instance;
    
    protected VolunteerTrainingMapper() { }
    
    public static VolunteerTrainingMapper getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerTrainingMapper();
        return instance;
    }
    
    public virtual List<VolunteerTrainingViewModel> getUpcomingTrainings() {
        return getUpcomingTrainingsByLocation(null);
    }
    
    public virtual List<VolunteerTrainingViewModel> getUpcomingTrainingsByLocation(String location) {
        String whereClause = '';
        
        whereClause += ' WHERE StartDateTime__c > ' +
            Datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' ';
        
        if (String.isNotBlank(location)) {
            whereClause += ' AND Location__c=\'' + location + '\' ';
        }
        
        return queryTrainings(whereClause);
    }
    
    private List<VolunteerTrainingViewModel> queryTrainings(String whereClause) {
        List<VolunteerTrainingViewModel> trainings;
        
        List<String> fields = new List<String>{
            'Id',
            'Description__c',
            'EndDateTime__c',
            'Location__c',
            'StartDateTime__c'
        };
        
        String queryString = String.format(
            'SELECT {0} FROM Volunteer_Training__c ',
            new List<String>{String.join(fields, ', ')}
        );
        
        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }
        
        queryString += ' ORDER BY StartDateTime__c ASC ';
        
        for (Volunteer_Training__c t : Database.query(queryString)) {
            if (trainings == null) {
                trainings = new List<VolunteerTrainingViewModel>();
            }
            
            trainings.add(new VolunteerTrainingViewModel(t));
        }
        
        return trainings;
    }
}