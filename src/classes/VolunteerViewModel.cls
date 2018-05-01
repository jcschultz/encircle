public class VolunteerViewModel {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String secondaryInfo;
    
    public VolunteerViewModel(Contact c) {
        name = c.Name;
        id = c.Id;
    }
    
    public VolunteerViewModel() {}
}