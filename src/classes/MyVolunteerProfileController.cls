/**
* @author: John Schultz
* @date: 2018-04-10
* @description: Controller for MyVolunteerProfile component.
*/
public without sharing class MyVolunteerProfileController {
    
    
    @AuraEnabled
    public static VolunteerViewModel loadVolunteerViewModel(Id volunteerId) {
        VolunteerService service = VolunteerService.getInstance();
        return service.getVolunteerAndUpcomingShifts(volunteerId);
    }
}