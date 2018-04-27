/**
 * @author John Schultz
 * @date 2017-11-08
 * @description Service layer for Volunteer_Training__c object
 */
public virtual class TrainingService {
    
    @TestVisible
    private static TrainingService instance;

    protected TrainingService() { }

    public static TrainingService getInstance() {
        if (instance != null) {
            return instance;
        }

        instance = new TrainingService();
        return instance;
    }
    
    /**
     * @description Retrieves the upcoming trainings.
     *
     * @return List of trainings
     */
    public virtual List<TrainingModel> getUpcomingTrainings() {
        List<TrainingModel> trainings = new List<TrainingModel>();
        Datetime dtNow = Datetime.now();
        
        String q = getQueryString();
        q += 'WHERE StartDateTime__c > :dtNow ';
        q += 'ORDER BY StartDateTime__c ASC ';
        
        for (Volunteer_Training__c t : Database.query(q)) {
            trainings.add(new TrainingModel(t));
        }
        
        return trainings;
    }
    
    /**
     * @description Retrieves the trainings by their IDs.
     *
     * @param ids
     *
     * @return List of Volunteer_Training__c records.
     */
    public virtual List<Volunteer_Training__c> getTrainingsById(Set<String> ids) {
        String q = getQueryString();
        q += 'WHERE Id IN :ids ';
        
        return Database.query(q);
    }
    
    /**
     * @description Builds the common query string for retrieving training records.
     *
     * @return The query string.
     */
    private String getQueryString() {
        String q = '';
        
        q += 'SELECT ';
        q += '    Id, ';
        q += '    Name, ';
        q += '    Location__c, ';
        q += '    StartDateTime__c ';
        q += 'FROM Volunteer_Training__c ';
        
        return q;
    }

}