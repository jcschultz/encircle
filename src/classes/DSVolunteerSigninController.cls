/**
 * @description Controller for the door survey volunteer signin component.
 *
 * @author John Schultz
 * @date 2018-04-16
 */
public without sharing class DSVolunteerSigninController {
    
    /**
     * Finds contacts and their related volunteer hours.
     *
     * @param nameInput
     *
     * @return List of contacts and hours
     */
    @AuraEnabled
    public static List<DoorSurveyVolunteerViewModel> searchContacts(String nameInput) {
        Map<Id, DoorSurveyVolunteerViewModel> results = new Map<Id, DoorSurveyVolunteerViewModel>();
        List<String> contactIds = new List<String>();
        
        // first find matching contacts who are allowed to volunteer.
        List<Contact> contacts = VolunteerService.findContactByFuzzyNameSearch(nameInput);
        
        // if any contacts are found, find any shifts that they signed up for
        // that match today's date.
        if (contacts != null && !contacts.isEmpty()) {
            for (Contact c : contacts) {
                contactIds.add(c.Id);
                results.put(c.Id, new DoorSurveyVolunteerViewModel(c));
            }
            
            for (GW_Volunteers__Volunteer_Hours__c h :
                VolunteerShiftService.findHoursByContactAndDate(
                    contactIds,
                    Date.today(),
                    Date.today().addDays(1)
                )
            ) {
            
                results.get(h.GW_Volunteers__Contact__c).shifts.add(new DoorSurveyShiftViewModel(h));
            }
        }
        
        return results.values();
    }
    
    /**
     * Marks the hours as completed.
     *
     * @param hourIds
     */
    @AuraEnabled
    public static void signVolunteerInToHours(String[] hourIds) {
        VolunteerShiftService.completeHoursById(hourIds);
    }
    
    /**
     * Finds the shifts for today that still need volunteers.
     *
     * @return List of open shifts.
     */
    @AuraEnabled
    public static List<DoorSurveyShiftViewModel> findAvailableShifts() {
        List<DoorSurveyShiftViewModel> results = new List<DoorSurveyShiftViewModel>();
        
        for (GW_Volunteers__Volunteer_Shift__c vs :
            VolunteerShiftService.getShiftsBetweenDates(
                Date.today(),
                Date.today().addDays(1)
            )
        ) {
            
            if (vs.GW_Volunteers__Number_of_Volunteers_Still_Needed__c > 0) {
                results.add(new DoorSurveyShiftViewModel(vs));
            }
        }
        
        return results;
    }
    
    /**
     * Signs the volunteer up for shifts (creates hours) and also sign the volunteer
     * in to those hours (marks completed).
     *
     * @param contactId
     * @param shiftIds
     */
    @AuraEnabled
    public static void signVolunteerUpForShifts(String contactId, String[] shiftIds) {
        VolunteerShiftService.signContactUpForHours(contactId, shiftIds, VolunteerShiftService.COMPLETED_STATUS);
    }
    
    /**
     * Signs the volunteer into the unplanned shift/job/campaign
     *
     * @param contactId
     * @param hours
     */
    @AuraEnabled
    public static void signVolunteerInForUnplannedShift(String contactId, Decimal hours) {
        VolunteerShiftService.signInToUnplannedShift(contactId, hours);
    }
}