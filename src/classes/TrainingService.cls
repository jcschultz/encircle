/**
 * @author John Schultz
 * @date 2017-11-08
 * @description Service layer for Volunteer_Training__c object
 */
public class TrainingService {
    
    /**
     * Retrieves the upcoming trainings
     *
     * @return List of trainings
     */
    public static List<TrainingModel> getUpcomingTrainings() {
        List<TrainingModel> trainings = new List<TrainingModel>();
        
        for (Volunteer_Training__c t : [
            SELECT
                Id,
                Name,
                Location__c,
                StartDateTime__c
            FROM Volunteer_Training__c
            WHERE StartDateTime__c > :Datetime.now()
            ORDER BY StartDateTime__c ASC
        ]) {
            
            trainings.add(new TrainingModel(t));
            
        }
        
        return trainings;
    }

}