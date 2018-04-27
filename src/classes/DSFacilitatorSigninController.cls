/**
 * @description Controller for the Door Survey Facilitator Sign-In component
 *
 * @author John Schultz
 * @date 2018-04-18
 */
public without sharing class DSFacilitatorSigninController {
    
    /**
     * Finds Facilitator contact
     *
     * @param nameInput
     *
     * @return List of contacts
     */
    @AuraEnabled
    public static List<DoorSurveyVolunteerViewModel> searchContacts(String nameInput) {
        List<DoorSurveyVolunteerViewModel> results = new List<DoorSurveyVolunteerViewModel>();
        VolunteerService service = VolunteerService.getInstance();
    
        List<Contact> contacts = service.findFacilitatorByFuzzyNameSearch(nameInput);
        
        if (contacts != null && !contacts.isEmpty()) {
            for (Contact c : contacts) {
                results.add(new DoorSurveyVolunteerViewModel(c));
            }
        }
        
        return results;
    }
    
    /**
     * Signs the facilitator into the facilitator shift/job/campaign
     *
     * @param contactId
     * @param hours
     */
    @AuraEnabled
    public static void signIn(String contactId, Decimal hours) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        vsService.signInToFacilitatorShift(contactId, hours);
    }

}