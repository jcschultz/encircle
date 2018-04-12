public class DoorSurveyVolunteerViewModel {
    @AuraEnabled
    public String contactId;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public List<DoorSurveyShiftViewModel> shifts;
    
    public DoorSurveyVolunteerViewModel(Contact c) {
        this.contactId = c.Id;
        this.name = c.Name;
        this.shifts = new List<DoorSurveyShiftViewModel>();
    }
}