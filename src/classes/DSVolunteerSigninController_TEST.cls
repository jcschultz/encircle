@isTest
private class DSVolunteerSigninController_TEST {
    
    private static Id hourId;
    private static Id conId;
    private static Id shiftId;
    private static Id shift2Id;
    private static Id jobId;
    
    static {
        conId = '003000000000001';
        hourId = '003W00000000001';
        conId = '003000000000001';
        shiftId = 'a0VW00000000001';
        shift2Id = 'a0VW00000000002';
        jobId = 'a0TW00000000001';
    }
    
    @IsTest
    private static void testLoadData() {
        VolunteerService.instance = new VolunteerServiceStub();
        
        DoorSurveyVolunteerViewModel ds = DSVolunteerSigninController.loadVolunteerData(conId);
        
        System.assertEquals(conId, ds.id);
        System.assertEquals(1, ds.shifts.size());
        
    }
    
    @IsTest
    private static void testFindingShifts() {
        VolunteerShiftService.instance = new VolunteerShiftServiceStub();
        
        List<DoorSurveyShiftViewModel> shifts = DSVolunteerSigninController.findAvailableShifts();
        
        System.assertEquals(1, shifts.size());
        System.assertEquals(shiftId, shifts[0].id);
    }
    
    @IsTest
    private static void testCoverage() {
        VolunteerShiftService.instance = new VolunteerShiftServiceStub();
        
        DSVolunteerSigninController.signVolunteerInToHours(new List<Id>{hourId});
        DSVolunteerSigninController.signVolunteerUpForShifts(conId, new List<Id>{shiftId});
        DSVolunteerSigninController.signVolunteerInForUnplannedShift(conId, 1);
    }
    
    
    private class VolunteerServiceStub extends VolunteerService {
        public override VolunteerViewModel getVolunteerAndTodaysUpcomingShifts(Id volunteerId) {
            VolunteerViewModel vvm = new VolunteerViewModel();
            vvm.id = conId;
            vvm.name = 'test name';
            
            VolunteerHoursViewModel hour = new VolunteerHoursViewModel();
            hour.id = hourId;
            hour.jobName = 'job name';
            hour.startDatetime = Datetime.now();
            
            vvm.hours = new List<VolunteerHoursViewModel>();
            vvm.hours.add(hour);
            
            return vvm;
        }
    }
    
    private class VolunteerShiftServiceStub extends VolunteerShiftService {
        public override List<VolunteerHoursViewModel> completeHoursById(String[] hourIds) {
            return null;
        }
    
        public override List<VolunteerShiftViewModel> getShiftsBetweenDates(Date s, Date e) {
            List<VolunteerShiftViewModel> shifts = new List<VolunteerShiftViewModel>();
    
            VolunteerShiftViewModel shift1 = new VolunteerShiftViewModel();
            shift1.volunteersStillNeeded = 2;
            shift1.id = shiftId;
            shift1.jobName = 'job 1';
            shift1.startDateTime = Datetime.now();
            shifts.add(shift1);
    
            VolunteerShiftViewModel shift2 = new VolunteerShiftViewModel();
            shift2.volunteersStillNeeded = 0;
            shift2.id = shift2Id;
            shift2.jobName = 'job 2';
            shift2.startDateTime = Datetime.now();
            shifts.add(shift2);
            
            return shifts;
        }
    
        public override List<VolunteerHoursViewModel> signVolunteerUpForHours(String volunteerId, String[] shiftIds, String status) {
            return null;
        }
    
        public override VolunteerHoursViewModel signInToUnplannedShift(String volunteerId, Decimal duration) {
            return null;
        }
    }
}