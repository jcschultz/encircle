public without sharing class VolunteerRecordFinderCtrl {
    
    public static final String NO_MATCHES = 'NO_MATCHES';
    
    @AuraEnabled
    public static VolunteerRecordFinderViewModel doSearch(String input) {
        VolunteerRecordFinderViewModel model = new VolunteerRecordFinderViewModel();
        VolunteerService vService = VolunteerService.getInstance();
        
        List<VolunteerViewModel> volunteers = vService.findVolunteersByEmailOrPhone(input);
        
        if (volunteers != null && !volunteers.isEmpty()) {
            model.isSuccess = true;
            
            for (VolunteerViewModel v : volunteers) {
                VolunteerViewModel vvm = new VolunteerViewModel();
                vvm.name = hideText(v.firstName) + ' ' + hideText(v.lastName);
                vvm.id = v.id;
                vvm.secondaryInfo = v.phone;
                
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
        VolunteerService service = VolunteerService.getInstance();
        VolunteerRecordFinderViewModel model = new VolunteerRecordFinderViewModel();
        
        model.isSuccess = service.isVolunteerMatched(volunteerId, input);
        
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