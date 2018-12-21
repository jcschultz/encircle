@IsTest
private class VolTrainingRegistrationController_TEST {
    
    private static Id conId = '003000000000001';
    private static Id trainingId = 'a0qW00000000001';
    private static Id attendanceId = 'a0rW00000000001';
    
    @IsTest
    private static void testGetTrainings() {
        VolunteerTrainingService.instance = new VolunteerTrainingServiceStub();
        VolTrainingRegistrationViewModel vtrvm = VolTrainingRegistrationController.getTrainings(conId);
        System.assertNotEquals(null, vtrvm.myTrainings);
        System.assertNotEquals(null, vtrvm.getTrainingsExclusiveOfMe());
    }
    
    @IsTest
    private static void testRegister() {
        VolunteerTrainingService.instance = new VolunteerTrainingServiceStub();
        VolTrainingRegistrationViewModel vtrvm = VolTrainingRegistrationController.registerForTraining(conId, trainingId);
        System.assertNotEquals(null, vtrvm.myTrainings);
        System.assertNotEquals(null, vtrvm.getTrainingsExclusiveOfMe());
    }
    
    @IsTest
    private static void testUnregister() {
        VolunteerTrainingService.instance = new VolunteerTrainingServiceStub();
        VolTrainingRegistrationViewModel vtrvm = VolTrainingRegistrationController.unregisterFromTraining(conId, attendanceId);
        System.assertNotEquals(null, vtrvm.myTrainings);
        System.assertNotEquals(null, vtrvm.getTrainingsExclusiveOfMe());
    }
    
    
    private class VolunteerTrainingServiceStub extends VolunteerTrainingService {
        public override List<VolunteerTrainingViewModel> getMyUpcomingTrainings(Id volunteeerId) {
            return new List<VolunteerTrainingViewModel>();
        }
        
        public override List<VolunteerTrainingViewModel> getUpcomingTrainings() {
            return new List<VolunteerTrainingViewModel>();
        }
        
        public override VolunteerTrainingViewModel registerVolunteerForTraining(Id volunteerId, Id trainingId) {
            VolunteerTrainingViewModel vtvm = new VolunteerTrainingViewModel();
            vtvm.volunteerId = volunteerId;
            vtvm.trainingId = trainingId;
            return vtvm;
        }
        
        public override void unregisterAttendance(Id attendanceId) {
        
        }
        
    }
}