public class VolTrainingRegistrationViewModel {
    @AuraEnabled
    public List<VolunteerTrainingViewModel> myTrainings;
    @AuraEnabled
    public List<VolunteerTrainingViewModel> upcomingTrainings;
    @AuraEnabled
    public List<VolunteerTrainingViewModel> getTrainingsExclusiveOfMe() {
        Map<Id, VolunteerTrainingViewModel> trainings = new Map<Id, VolunteerTrainingViewModel>();
        
        if (upcomingTrainings != null && !upcomingTrainings.isEmpty()) {
            for (VolunteerTrainingViewModel t : upcomingTrainings) {
                trainings.put(t.id, t);
            }
        }
        
        if (myTrainings != null && !myTrainings.isEmpty()) {
            for (VolunteerTrainingViewModel t : myTrainings) {
                if (trainings.containsKey(t.trainingId)) {
                    trainings.remove(t.trainingId);
                }
            }
        }
        
        return trainings.values();
    }
    
    public VolTrainingRegistrationViewModel() {
        myTrainings = new List<VolunteerTrainingViewModel>();
        upcomingTrainings = new List<VolunteerTrainingViewModel>();
    }
}