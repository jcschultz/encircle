/**
 * @author John Schultz
 * @date 2017-11-09
 * @description Controller for VolunteerShiftSignupForm component.
 */
public class VolunteerShiftSignupController {
    
    private static final String SIGNUP_STATUS = 'Confirmed';
    
    /**
     * @description Signs the volunteer up for a volunteer shift.
     * @param volunteerId
     * @param shiftIds
     */
    @AuraEnabled
    public static List<VolunteerHoursViewModel> signUpVolunteerForShifts(String volunteerId, String[] shiftIds) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        return vsService.signVolunteerUpForHours(volunteerId, shiftIds, SIGNUP_STATUS);
    }
    
    @AuraEnabled
    public static VolunteerViewModel loadVolunteerViewModel(Id volunteerId) {
        VolunteerService service = VolunteerService.getInstance();
        return service.getVolunteerAndUpcomingShifts(volunteerId);
    }
    
}