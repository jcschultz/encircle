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
    public static VolunteerViewModel registerVolunteer(Map<String, Object> volunteerInfo) {
        VolunteerService service = VolunteerService.getInstance();
        return service.registerNewVolunteer(volunteerInfo);
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