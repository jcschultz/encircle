public without sharing class VolTrainingRegistrationController {
    
    @AuraEnabled
    public static VolTrainingRegistrationViewModel getTrainings(Id volunteerId) {
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        
        VolTrainingRegistrationViewModel vm = new VolTrainingRegistrationViewModel();
        vm.myTrainings = service.getMyUpcomingTrainings(volunteerId);
        vm.upcomingTrainings = service.getUpcomingTrainings();
        return vm;
    }
    
    @AuraEnabled
    public static VolTrainingRegistrationViewModel registerForTraining(Id volunteerId, Id trainingId) {
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        service.registerVolunteerForTraining(volunteerId, trainingId);
        
        return getTrainings(volunteerId);
    }
    
    @AuraEnabled
    public static VolTrainingRegistrationViewModel unregisterFromTraining(Id volunteerId, Id attendanceId) {
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        service.unregisterAttendance(attendanceId);
        
        return getTrainings(volunteerId);
    }
}