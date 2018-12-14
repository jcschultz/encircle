public without sharing class VolNameTypeAheadCtrl {
    
    @AuraEnabled
    public static List<DoorSurveyVolunteerViewModel> searchVolunteers(String nameInput, String volunteerType) {
        List<DoorSurveyVolunteerViewModel> results = new List<DoorSurveyVolunteerViewModel>();
        VolunteerService service = VolunteerService.getInstance();
        List<VolunteerViewModel> volunteers;
        
        if (volunteerType == 'FACILITATOR') {
            volunteers = service.findFacilitatorByFuzzyNameSearch(nameInput);
        } else {
            volunteers = service.findVolunteerByFuzzyNameSearch(nameInput);
        }
        
        if (volunteers != null && !volunteers.isEmpty()) {
            for (VolunteerViewModel v : volunteers) {
                results.add(new DoorSurveyVolunteerViewModel(v));
            }
        }
        
        return results;
    }
}