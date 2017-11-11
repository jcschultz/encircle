/**
 * @author John Schultz
 * @date 2017-11-09
 * @description Controller for VolunteerShiftSignupForm component.
 */
public class VolunteerShiftSignupController {
    
    private static final String SIGNUP_STATUS = 'Confirmed';
    
    /**
     * @description Retrieve volunteers, searching by names.
     *
     * @param nameInput
     *
     * @return list of contacts
     */
    @AuraEnabled
    public static List<Contact> searchContacts(String nameInput) {
        return VolunteerService.findByFuzzyNameSearch(nameInput);
    }
    
    /**
     * @description Signs the contact up for a volunteer shift.
     *
     * @param contactId
     * @param shiftIds
     */
    @AuraEnabled
    public static List<GW_Volunteers__Volunteer_Hours__c> signUpContactForShifts(String contactId, String[] shiftIds) {
        return VolunteerShiftService.signContactUpForHours(contactId, shiftIds, SIGNUP_STATUS);
    }
    
}