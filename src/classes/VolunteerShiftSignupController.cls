/**
 * @author John Schultz
 * @date 2017-11-09
 * @description Controller for VolunteerShiftSignupForm component.
 */
public class VolunteerShiftSignupController {
    
    private static final String SIGNUP_STATUS = 'Confirmed';
    
    /**
     * @description Retrieve volunteers, searching by names.
     * @param nameInput
     * @return list of contacts
     */
    @AuraEnabled
    public static List<VolunteerViewModel> searchContacts(String nameInput) {
        List<VolunteerViewModel> results = new List<VolunteerViewModel>();
        VolunteerService service = VolunteerService.getInstance();
        List<Contact> contacts = service.findContactByFuzzyNameSearch(nameInput);
        
        for (Contact c : contacts) {
            results.add(new VolunteerViewModel(c));
        }
        
        return results;
    }
    
    /**
     * @description Signs the contact up for a volunteer shift.
     * @param contactId
     * @param shiftIds
     */
    @AuraEnabled
    public static List<GW_Volunteers__Volunteer_Hours__c> signUpContactForShifts(String contactId, String[] shiftIds) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        return vsService.signContactUpForHours(contactId, shiftIds, SIGNUP_STATUS);
    }
    
}