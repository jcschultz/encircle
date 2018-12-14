@IsTest
private class VolunteerShiftSignupCtrl_TEST {
    
    private static Id conId;
    private static Id shiftId;
    
    static {
        conId = '003000000000001';
        shiftId = 'a0VW00000000001';
    }
    
    @IsTest
    private static void testSignUp() {
        VolunteerShiftService.instance = new VolunteerShiftServiceStub();
        
        List<VolunteerHoursViewModel> hours = VolunteerShiftSignupController.signUpVolunteerForShifts(conId, new List<Id>{shiftId});
        
        System.assertEquals(1, hours.size());
        System.assertEquals(conId, hours[0].volunteerId);
    }
    
    private class VolunteerShiftServiceStub extends VolunteerShiftService {
        public override List<VolunteerHoursViewModel> signVolunteerUpForHours(String volunteerId, String[] shiftIds, String status) {
            VolunteerHoursViewModel vhvm = new VolunteerHoursViewModel();
            vhvm.shiftId = shiftId;
            vhvm.volunteerId = conId;
            
            return new List<VolunteerHoursViewModel>{vhvm};
        }
    }
}