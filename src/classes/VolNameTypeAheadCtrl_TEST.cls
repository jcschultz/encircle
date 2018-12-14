@IsTest
private class VolNameTypeAheadCtrl_TEST {
    private static Id conId;
    private static Id shiftId;
    private static Id hourId;
    
    static {
        conId = '003000000000001';
        shiftId = 'a0VW00000000001';
        hourId = '003W00000000001';
    }
    
    @IsTest
    private static void testSearch() {
        VolunteerService.instance = new VolunteerServiceStub();
        
        List<DoorSurveyVolunteerViewModel> facs = VolNameTypeAheadCtrl.searchVolunteers('test', 'FACILITATOR');
        System.assertEquals(1, facs.size());
        System.assertEquals(conId, facs[0].id);
        System.assertEquals(1, facs[0].shifts.size());
        System.assertEquals(hourId, facs[0].shifts[0].id);
    
        List<DoorSurveyVolunteerViewModel> vols = VolNameTypeAheadCtrl.searchVolunteers('test', 'VOLUNTEER');
        System.assertEquals(1, vols.size());
        System.assertEquals(conId, vols[0].id);
        System.assertEquals(1, vols[0].shifts.size());
        System.assertEquals(hourId, vols[0].shifts[0].id);
    }
    
    
    private class VolunteerServiceStub extends VolunteerService {
        public override List<VolunteerViewModel> findFacilitatorByFuzzyNameSearch(String nameInput) {
            return volunteers();
        }
    
        public override List<VolunteerViewModel> findVolunteerByFuzzyNameSearch(String nameInput) {
            return volunteers();
        }
        
        private List<VolunteerViewModel> volunteers() {
            VolunteerViewModel vvm = new VolunteerViewModel();
            vvm.id = conId;
            vvm.name = 'john schultz';
            
            VolunteerHoursViewModel vhvm = new VolunteerHoursViewModel();
            vhvm.id = hourId;
            vhvm.jobName = 'job name';
            vhvm.startDatetime = Datetime.now();
            
            vvm.hours = new List<VolunteerHoursViewModel>{vhvm};
            
            return new List<VolunteerViewModel>{vvm};
        }
    }
}