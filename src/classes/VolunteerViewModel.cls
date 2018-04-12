public class VolunteerViewModel {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Id id;
    
    public VolunteerViewModel(Contact c) {
        name = c.Name;
        id = c.Id;
    }
}