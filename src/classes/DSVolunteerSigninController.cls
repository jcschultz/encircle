/**
 * @description Controller for the door survey volunteer signin component.
 *
 * @author John Schultz
 * @date 2018-04-16
 */
public without sharing class DSVolunteerSigninController {
    
    @AuraEnabled
    public static DoorSurveyVolunteerViewModel loadVolunteerData(Id volunteerId) {
        VolunteerService service = VolunteerService.getInstance();
        VolunteerViewModel vvm = service.getVolunteerAndTodaysUpcomingShifts(volunteerId);
        return new DoorSurveyVolunteerViewModel(vvm);
    }
    
    /**
     * Marks the hours as completed.
     *
     * @param hourIds
     */
    @AuraEnabled
    public static void signVolunteerInToHours(String[] hourIds) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        vsService.completeHoursById(hourIds);
    }
    
    /**
     * Finds the shifts for today that still need volunteers.
     *
     * @return List of open shifts.
     */
    @AuraEnabled
    public static List<DoorSurveyShiftViewModel> findAvailableShifts() {
        List<DoorSurveyShiftViewModel> results = new List<DoorSurveyShiftViewModel>();
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        
        for (VolunteerShiftViewModel vs :
            vsService.getShiftsBetweenDates(
                Date.today(),
                Date.today().addDays(1)
            )
        ) {
            
            if (vs.volunteersStillNeeded > 0) {
                results.add(new DoorSurveyShiftViewModel(vs));
            }
        }
        
        return results;
    }
    
    /**
     * Signs the volunteer up for shifts (creates hours) and also sign the volunteer
     * in to those hours (marks completed).
     *
     * @param volunteerId
     * @param shiftIds
     */
    @AuraEnabled
    public static void signVolunteerUpForShifts(String volunteerId, String[] shiftIds) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        vsService.signVolunteerUpForHours(volunteerId, shiftIds, VolunteerShiftService.COMPLETED_STATUS);
    }
    
    /**
     * Signs the volunteer into the unplanned shift/job/campaign
     *
     * @param volunteerId
     * @param hours
     */
    @AuraEnabled
    public static void signVolunteerInForUnplannedShift(String volunteerId, Decimal hours) {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        vsService.signInToUnplannedShift(volunteerId, hours);
    }
}