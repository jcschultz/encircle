@isTest
private class DSFacilitatorSigninController_TEST {
    
    private static Id conId;
    
    static {
        conId = '003000000000001';
    }
    
    @IsTest
    private static void testLoadData() {
        VolunteerService.instance = new VolunteerServiceStub();
        
        DoorSurveyVolunteerViewModel ds = DSFacilitatorSigninController.loadVolunteerData(conId);
        
        System.assertEquals(conId, ds.id);
        System.assert(ds.shifts.isEmpty());
    }
    
    @IsTest
    private static void testCoverage() {
        VolunteerShiftService.instance = new VolunteerShiftServiceStub();
        
        DSFacilitatorSigninController.signIn(conId, 1);
    }
    
    private class VolunteerServiceStub extends VolunteerService {
        public override VolunteerViewModel getVolunteerById(Id volunteerId) {
            VolunteerViewModel vvm = new VolunteerViewModel();
            vvm.id = conId;
            vvm.name = 'test name';
            
            return vvm;
        }
    }
    
    private class VolunteerShiftServiceStub extends VolunteerShiftService {
        public override VolunteerHoursViewModel signInToFacilitatorShift(String volunteerId, Decimal duration) {
            return null;
        }
    }
}