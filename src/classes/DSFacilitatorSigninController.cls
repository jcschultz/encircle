/**
 * @description Controller for the Door Survey Facilitator Sign-In component
 *
 * @author John Schultz
 * @date 2018-04-18
 */
public without sharing class DSFacilitatorSigninController {
    
    @AuraEnabled
    public static DoorSurveyVolunteerViewModel loadVolunteerData(Id volunteerId) {
        VolunteerService service = VolunteerService.getInstance();
        VolunteerViewModel vvm = service.getVolunteerById(volunteerId);
        return new DoorSurveyVolunteerViewModel(vvm);
    }
    
    /**
     * Signs the facilitator into the facilitator shift/job/campaign
     *
     * @param volunteerId
     * @param hours
     */
    @AuraEnabled
    public static void signIn(String volunteerId, Decimal hours) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        vsService.signInToFacilitatorShift(volunteerId, hours);
    }

}