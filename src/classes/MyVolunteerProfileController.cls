/**
* @author: John Schultz
* @date: 2018-04-10
* @description: Controller for MyVolunteerProfile component.
*/
public class MyVolunteerProfileController {
    
    /**
     * @description Retrieve volunteers, searching by names.
     * @param nameInput
     * @return list of contacts
     */
    @AuraEnabled
    public static List<VolunteerViewModel> searchContacts(String nameInput) {
        List<VolunteerViewModel> results = new List<VolunteerViewModel>();
        List<Contact> contacts = VolunteerService.findContactByFuzzyNameSearch(nameInput);
        
        for (Contact c : contacts) {
            results.add(new VolunteerViewModel(c));
        }
        
        return results;
    }
    
    
    @AuraEnabled
    public static List<VolunteerHoursViewModel> getUpcomingShifts(Id contactId) {
        List<VolunteerHoursViewModel> hours = new List<VolunteerHoursViewModel>();
        
        List<GW_Volunteers__Volunteer_Hours__c> records = VolunteerShiftService.findHoursByContactAndDate(
            new List<String>{contactId}, 
            Date.today(), 
            Date.today().addYears(5)
        );
        
        for (GW_Volunteers__Volunteer_Hours__c h : records) {
            VolunteerHoursViewModel hour = new VolunteerHoursViewModel();
            hour.jobName = h.GW_Volunteers__Volunteer_Job__r.Name;
            hour.jobId = h.GW_Volunteers__Volunteer_Job__c;
            hour.shiftId = h.GW_Volunteers__Volunteer_Shift__c;
            hour.hoursId = h.Id;
            hour.duration = h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c;
            hour.startDatetime = h.GW_Volunteers__Shift_Start_Date_Time__c;
            
            hours.add(hour);
        }
        
        return hours;
    }
    
    @AuraEnabled
    public static List<VolunteerHoursViewModel> deleteShift(Id contactId, Id hourId) {
        GW_Volunteers__Volunteer_Hours__c h = new GW_Volunteers__Volunteer_Hours__c(
            Id = hourId
        );
        delete h;
        
        return getUpcomingShifts(contactId);
    }
}