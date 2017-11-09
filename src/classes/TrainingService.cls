/**
 * @author John Schultz
 * @date 2017-11-08
 * @description Service layer for Volunteer_Training__c object
 */
public class TrainingService {
    
    /**
     * @description Retrieves the upcoming trainings.
     *
     * @return List of trainings
     */
    public static List<TrainingModel> getUpcomingTrainings() {
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
    public static List<Volunteer_Training__c> getTrainingsById(Set<String> ids) {
        String q = getQueryString();
        q += 'WHERE Id IN :ids ';
        
        return Database.query(q);
    }
    
    /**
     * @description Builds the common query string for retrieving training records.
     *
     * @return The query string.
     */
    private static String getQueryString() {
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