public without sharing class VolunteerRecordFinderCtrl {
    
    public static final String NO_MATCHES = 'NO_MATCHES';
    
    @AuraEnabled
    public static VolunteerRecordFinderViewModel doSearch(String input) {
        VolunteerRecordFinderViewModel model = new VolunteerRecordFinderViewModel();
        VolunteerService vService = VolunteerService.getInstance();
        
        List<Contact> contacts = vService.findApprovedVolunteersByEmailOrPhone(input);
        
        if (contacts != null && !contacts.isEmpty()) {
            model.isSuccess = true;
            
            for (Contact c : contacts) {
                VolunteerViewModel vvm = new VolunteerViewModel();
                vvm.name = hideText(c.FirstName) + ' ' + hideText(c.LastName);
                vvm.id = c.Id;
                vvm.secondaryInfo = c.Phone;
                
                model.records.add(vvm);
            }
        }
        else {
            model.isSuccess = false;
            model.errorType = NO_MATCHES;
        }
        
        return model;
    }
    
    @AuraEnabled
    public static VolunteerRecordFinderViewModel doSecurityCheck(Id volunteerId, String input) {
        VolunteerRecordFinderViewModel model = new VolunteerRecordFinderViewModel();
        String normalizedInput = String.isNotBlank(input) ? input.normalizeSpace() : null;
        
        Contact c = [SELECT LastName FROM Contact WHERE Id = :volunteerId LIMIT 1];
        
        model.isSuccess = c.LastName.equalsIgnoreCase(normalizedInput);
        
        return model;
    }
    
    private static String hideText(String input) {
        String output = '';
        
        if (String.isNotBlank(input)) {
            Integer inputLength = input.length();
            String repeatChar = '*';
            
            output = input.substring(0,1) + repeatChar.repeat(inputLength - 2) + input.substring(inputLength - 1);
        }
        
        return output;
    }
    
}