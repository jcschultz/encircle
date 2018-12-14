@isTest
private class MyVolunteerProfileController_TEST {
    private static Id hourId;
    private static Id conId;
    private static Id shiftId;
    private static Id jobId;
    
    static {
        conId = '003000000000001';
        hourId = '003W00000000001';
        shiftId = 'a0VW00000000001';
        jobId = 'a0TW00000000001';
    }
    
    @IsTest
    private static void testLoadData() {
        VolunteerService.instance = new VolunteerServiceStub();
        
        VolunteerViewModel vvm = MyVolunteerProfileController.loadVolunteerViewModel(conId);
        
        System.assertEquals(conId, vvm.id);
        System.assertEquals(1, vvm.hours.size());
    }
    
    private class VolunteerServiceStub extends VolunteerService {
        public override VolunteerViewModel getVolunteerAndUpcomingShifts(Id volunteerId) {
            VolunteerViewModel vvm = new VolunteerViewModel();
            vvm.id = conId;
            vvm.name = 'test name';
    
            VolunteerHoursViewModel hour = new VolunteerHoursViewModel();
            hour.id = hourId;
            hour.jobName = 'job name';
            hour.startDatetime = Datetime.now();
            hour.shiftId = shiftId;
            hour.volunteerId = conId;
    
            vvm.hours = new List<VolunteerHoursViewModel>();
            vvm.hours.add(hour);
    
            return vvm;
        }
    }
    
}