/**
 * @author John Schultz
 * @date 2017-11-07
 * @description Controller for volunteer registration component.
 */
public class VolunteerRegistrationController {
    
    /**
     * @description Receives volunteer data and creates a record.
     *
     * @param volunteerInfo
     */
    @AuraEnabled
    public static void registerVolunteer(Map<String, Object> volunteerInfo) {
        VolunteerService service = VolunteerService.getInstance();
        Contact c = new Contact();
        
        c.Legal_First_Name__c = (String)volunteerInfo.get('firstName');
        c.LastName = (String)volunteerInfo.get('lastName');
        c.FirstName = String.isNotBlank((String)volunteerInfo.get('preferredName'))
                ? (String)volunteerInfo.get('preferredName') : c.Legal_First_Name__c;
        c.Pronouns__c = (String)volunteerInfo.get('pronouns');
        c.MailingStreet = (String)volunteerInfo.get('street');
        c.MailingCity = (String)volunteerInfo.get('city');
        c.MailingState = (String)volunteerInfo.get('state');
        c.MailingPostalCode = (String)volunteerInfo.get('zip');
        c.MailingCountry = (String)volunteerInfo.get('country');
        c.Email = (String)volunteerInfo.get('email');
        c.Phone = (String)volunteerInfo.get('phone1') +
            (String)volunteerInfo.get('phone2') +
            (String)volunteerInfo.get('phone3');
        c.Birthdate = Date.valueOf((String)volunteerInfo.get('dobYear') +
            '-' + (String)volunteerInfo.get('dobMonth') +
            '-' + volunteerInfo.get('dobDay'));
        c.Emergency_Contact_First_Name__c = (String)volunteerInfo.get('ecFirstName');
        c.Emergency_Contact_Last_Name__c = (String)volunteerInfo.get('ecLastName');
        c.Emergency_Contact_Relationship__c = (String)volunteerInfo.get('ecRelationship');
        c.Emergency_Contact_Phone__c = (String)volunteerInfo.get('ecPhone1') +
            (String)volunteerInfo.get('ecPhone2') + (String)volunteerInfo.get('ecPhone3');
        c.Volunteering_Reason__c = (String)volunteerInfo.get('reason');
        c.Volunteer__c = true;
        
        service.registerNewVolunteer(c, (String)volunteerInfo.get('training'));
    }
    
    /**
     * @description Retrieves upcoming trainings.
     *
     * @return List of trainings
     */
    @AuraEnabled
    public static List<TrainingModel> getTrainings() {
        TrainingService tService = TrainingService.getInstance();
        return tService.getUpcomingTrainings();
    }
    
    /**
     * @description Retrieves the picklist values for the pronouns field.
     *
     * @return List of pronouns
     */
    @AuraEnabled
    public static List<String> getPronouns() {
        List<String> pronouns = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Contact.Pronouns__c.getDescribe();
        
        for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
            pronouns.add(ple.getValue());
        }
        
        return pronouns;
    }

}