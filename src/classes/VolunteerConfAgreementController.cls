public class VolunteerConfAgreementController {
    @AuraEnabled
    public static VolunteerViewModel loadVolunteerViewModel(Id volunteerId) {
        VolunteerService service = VolunteerService.getInstance();
        return service.getVolunteerById(volunteerId);
    }
}