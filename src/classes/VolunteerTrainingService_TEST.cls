@IsTest
private class VolunteerTrainingService_TEST {
    
    private static Id conId = '003000000000001';
    private static Id trainingId = 'a0qW00000000001';
    private static Id attendanceId = 'a0rW00000000001';
    
    @IsTest
    private static void testGetTrainings() {
        VolunteerTrainingMapper.instance = new VolunteerTrainingMapperStub();
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        System.assertNotEquals(null, service.getUpcomingTrainings());
    }
    
    @IsTest
    private static void testGetMyTrainings() {
        VolunteerTrainingAttendanceMapper.instance = new VolunteerTrainingAttendanceMapperStub();
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        System.assertNotEquals(null, service.getMyUpcomingTrainings(conId));
    }
    
    @IsTest
    private static void testRegister() {
        VolunteerTrainingAttendanceMapper.instance = new VolunteerTrainingAttendanceMapperStub();
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        VolunteerTrainingViewModel vtvm = service.registerVolunteerForTraining(conId, trainingId);
        System.assertEquals(conId, vtvm.volunteerId);
        System.assertEquals(trainingId, vtvm.trainingId);
    }
    
    @IsTest
    private static void testUnregister() {
        VolunteerTrainingAttendanceMapper.instance = new VolunteerTrainingAttendanceMapperStub();
        VolunteerTrainingService service = VolunteerTrainingService.getInstance();
        service.unregisterAttendance(attendanceId);
    }
    
    private class VolunteerTrainingMapperStub extends VolunteerTrainingMapper {
        public override List<VolunteerTrainingViewModel> getUpcomingTrainings() {
            return new List<VolunteerTrainingViewModel>();
        }
    }
    
    private class VolunteerTrainingAttendanceMapperStub extends VolunteerTrainingAttendanceMapper {
        public override List<VolunteerTrainingViewModel> getUpcomingAttendanceByVolunteerId(Id volunteerId) {
            return new List<VolunteerTrainingViewModel>();
        }
        
        public override List<VolunteerTrainingViewModel> saveAttendance(List<VolunteerTrainingViewModel> models) {
            return models;
        }
        
        public override void deleteAttendance(List<Id> ids) {}
    }
}