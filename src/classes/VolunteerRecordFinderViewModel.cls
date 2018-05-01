public class VolunteerRecordFinderViewModel {
    @AuraEnabled
    public List<VolunteerViewModel> records;
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String errorType;
    @AuraEnabled
    public String errorMessage;
    
    public VolunteerRecordFinderViewModel() {
        isSuccess = false;
        records = new List<VolunteerViewModel>();
    }
    
}