public class DoorSurveyVolunteerViewModel {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public List<DoorSurveyShiftViewModel> shifts;
    
    public DoorSurveyVolunteerViewModel(VolunteerViewModel v) {
        this.id = v.id;
        this.name = v.name;
        this.shifts = new List<DoorSurveyShiftViewModel>();
        
        if (v.hours != null && !v.hours.isEmpty()) {
            for (VolunteerHoursViewModel h : v.hours) {
                shifts.add(new DoorSurveyShiftViewModel(h));
            }
        }
    }
}