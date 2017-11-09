/**
 * @author John Schultz
 * @date 2017-11-08
 * @description Model for volunteer trainings.
 */
public class TrainingModel {
    @AuraEnabled public Id id;
    @AuraEnabled public String name;
    @AuraEnabled public String detailedName;
    
    public TrainingModel(Volunteer_Training__c training) {
        this.id = training.Id;
        this.name = training.Name;
        this.detailedName = training.StartDateTime__c != null ?
            training.StartDateTime__c.format('MMMM d, h:mm a') : training.Name;
        
        if (String.isNotBlank(training.Location__c)) {
            this.detailedName += ' at ' + training.Location__c;
        }
    }
}