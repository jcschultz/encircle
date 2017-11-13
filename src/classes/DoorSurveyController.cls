/**
 * @description Controller for the door survey component.
 *
 * @author John Schultz
 * @date 2017-11-11
 */
public without sharing class DoorSurveyController {
    
    /**
     * @description Retrieves the visitor types for the door survey.
     *
     * @return
     */
    @AuraEnabled
    public static List<String> getVisitorTypes() {
        List<String> visitorTypes = new List<String>();
    
        Schema.DescribeFieldResult fieldResult = Door_Activity__c.Visitor_Type__c.getDescribe();
    
        for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
            visitorTypes.add(ple.getValue());
        }
        
        return visitorTypes;
    }
    
    /**
     * @description Saves the door activity.
     *
     * @param visitorType
     * @param activityDate (YYYY-MM-DD)
     * @param hour (0 - 23)
     */
    @AuraEnabled
    public static void saveActivity(String visitorType, String activityDate, String hour) {
        DoorActivityService.saveDoorActivity(Date.valueOf(activityDate), hour, visitorType);
    }
    
    /**
     * Finds contacts and their related volunteer hours.
     *
     * @param nameInput
     *
     * @return List of contacts and hours
     */
    @AuraEnabled
    public static List<VolunteerResult> searchContacts(String nameInput) {
        Map<Id, VolunteerResult> results = new Map<Id, VolunteerResult>();
        List<String> contactIds = new List<String>();
        
        // first find matching contacts who are allowed to volunteer.
        List<Contact> contacts = VolunteerService.findByFuzzyNameSearch(nameInput);
        
        // if any contacts are found, find any shifts that they signed up for
        // that match today's date.
        if (contacts != null && !contacts.isEmpty()) {
            for (Contact c : contacts) {
                contactIds.add(c.Id);
                results.put(c.Id, new VolunteerResult(c));
            }
            
            for (GW_Volunteers__Volunteer_Hours__c h :
                VolunteerShiftService.findHoursByContactAndDate(
                    contactIds,
                    Date.today(),
                    Date.today().addDays(1)
                )
            ) {
            
                results.get(h.GW_Volunteers__Contact__c).shifts.add(new ShiftResult(h));
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
    public static List<ShiftResult> findAvailableShifts() {
        List<ShiftResult> results = new List<ShiftResult>();
        
        for (GW_Volunteers__Volunteer_Shift__c vs :
            VolunteerShiftService.getShiftsBetweenDates(
                Date.today(),
                Date.today().addDays(1)
            )
        ) {
            
            if (vs.GW_Volunteers__Number_of_Volunteers_Still_Needed__c > 0) {
                results.add(new ShiftResult(vs));
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
    
    
    public class VolunteerResult {
        @AuraEnabled
        public String contactId;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public List<ShiftResult> shifts;
        
        public VolunteerResult(Contact c) {
            this.contactId = c.Id;
            this.name = c.Name;
            this.shifts = new List<ShiftResult>();
        }
    }
    
    public class ShiftResult {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String shiftName;
        @AuraEnabled
        public String startTime;
        @AuraEnabled
        public Boolean selected;
        
        public ShiftResult(GW_Volunteers__Volunteer_Hours__c h) {
            this.id = h.Id;
            this.shiftName = h.GW_Volunteers__Volunteer_Job__r.Name;
            this.startTime = h.GW_Volunteers__Shift_Start_Date_Time__c.format('h:mm a');
        }
        
        public ShiftResult(GW_Volunteers__Volunteer_Shift__c s) {
            this.id = s.Id;
            this.shiftName = s.GW_Volunteers__Volunteer_Job__r.Name;
            this.startTime = s.GW_Volunteers__Start_Date_Time__c.format('h:mm a');
            this.selected = false;
        }
    }
}