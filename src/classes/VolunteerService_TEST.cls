@IsTest
private class VolunteerService_TEST {
    
    private static Id conId;
    private static VolunteerViewModel staticVol;
    private static Date birthDate;
    
    static {
        conId = '003000000000001';
        birthDate = Date.today();
    
        staticVol = new VolunteerViewModel();
        staticVol.id = conId;
        staticVol.legalFirstName = 'legalFirst';
        staticVol.lastName = 'lastVolunteerMapperTest';
        staticVol.firstName = 'nickname';
        staticVol.pronouns = 'He/His/Him';
        staticVol.mailingStreet = '123 street Ave Dr';
        staticVol.mailingCity = 'Towntown';
        staticVol.mailingState = 'TN';
        staticVol.mailingPostalCode = '97643';
        staticVol.mailingCountry = 'USA';
        staticVol.email = 'volunteermapper@example.com';
        staticVol.phone = '8818181881';
        staticVol.birthdate = birthDate;
        staticVol.emergencyContactFirstName = 'emFirst';
        staticVol.emergencyContactLastName = 'emLast';
        staticVol.emergencyContactRelationship = 'cousin';
        staticVol.emergencyContactPhone = '4541712487';
    }
    
    @IsTest
    private static void testGetById() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        VolunteerViewModel vol = service.getVolunteerById(conId);
        System.assertEquals(staticVol.lastName, vol.lastName);
    }
    
    @IsTest
    private static void testGetVolunteerAndShifts() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        VolunteerViewModel vol = service.getVolunteerAndUpcomingShifts(conId);
        System.assertEquals(staticVol.lastName, vol.lastName);
        System.assertEquals(1, vol.hours.size());
    }
    
    @IsTest
    private static void testGetVolunteerAndShiftsToday() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        VolunteerViewModel vol = service.getVolunteerAndTodaysUpcomingShifts(conId);
        
        System.assertEquals(staticVol.lastName, vol.lastName);
        System.assertEquals(1, vol.hours.size());
    }
    
    @IsTest
    private static void testRegisterNew() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        Map<String, String> volunteerInfo = new Map<String, String>{
            'firstName' => 'testFirst',
            'lastName' => 'testLast',
            'preferredName' => 'testPN',
            'pronouns' => 'He/him/his',
            'street' => '123 test st lane',
            'city' => 'testville',
            'state' => 'TN',
            'zip' => '44544',
            'country' => 'USA',
            'email' => 'VolunteerRegistrationControllerTEST@example.com',
            'phone1' => '856',
            'phone2' => '848',
            'phone3' => '4607',
            'dobYear' => '1900',
            'dobMonth' => '12',
            'dobDay' => '15',
            'ecFirstName' => 'testEcFirst',
            'ecLastName' => 'testEcLast',
            'ecRelationship' => 'mom',
            'ecPhone1' => '856',
            'ecPhone2' => '848',
            'ecPhone3' => '4608',
            'reason' => 'my reason',
            'homeless' => 'false',
            'hospitalized' => 'true',
            'hospitalizationExplanation' => 'dfdf',
            'volunteeringForSchool' => 'true',
            'volunteeringForSchoolLength' => '1 month'
        };
        
        VolunteerViewModel vol = service.registerNewVolunteer(volunteerInfo);
        System.assertEquals(volunteerInfo.get('lastName'), vol.lastName);
    }
    
    @IsTest
    private static void testVolFuzzy() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        List<VolunteerViewModel> vols = service.findVolunteerByFuzzyNameSearch('test');
        System.assertEquals(1, vols.size());
    }
    
    @IsTest
    private static void testFacFuzzy() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        List<VolunteerViewModel> vols = service.findFacilitatorByFuzzyNameSearch('test');
        System.assertEquals(1, vols.size());
    }
    
    @IsTest
    private static void testMatched() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        Boolean isMatched = service.isVolunteerMatched(conId, staticVol.lastName);
        System.assertEquals(true, isMatched);
    }
    
    @IsTest
    private static void testNotMatched() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        Boolean isMatched = service.isVolunteerMatched(conId, 'nomatch');
        System.assertEquals(false, isMatched);
    }
    
    @IsTest
    private static void testVolByEmailPhone() {
        VolunteerMapper.instance = new VolunteerMapperStub();
        VolunteerService service = VolunteerService.getInstance();
        
        List<VolunteerViewModel> vols = service.findVolunteersByEmailOrPhone('test');
        System.assertEquals(1, vols.size());
    }
    
    
    private class VolunteerMapperStub extends VolunteerMapper {
        public override VolunteerViewModel saveVolunteer(VolunteerViewModel vol) {
            vol.id = conId;
            return vol;
        }
        
        public override List<VolunteerViewModel> findVolunteerByFuzzyNameSearch(String searchTerm) {
            return new List<VolunteerViewModel>{returnVol()};
        }
    
        public override List<VolunteerViewModel> findFacilitatorByFuzzyNameSearch(String searchTerm) {
            return new List<VolunteerViewModel>{returnVol()};
        }
        
        public override VolunteerViewModel findById(Id volunteerId) {
            return returnVol();
        }
    
        public override List<VolunteerViewModel> findVolunteersByEmailOrPhone(String input) {
            return new List<VolunteerViewModel>{returnVol()};
        }
        
        private VolunteerViewModel returnVol() {
            return staticVol;
        }
    }
    
    private class VolunteerHourMapperStub extends VolunteerHourMapper {
        public override List<VolunteerHoursViewModel> getHoursByVolunteerIdsAndDate(Id[] volunteerIds, Date startDate, Date endDate) {
            VolunteerHoursViewModel h = new VolunteerHoursViewModel();
            h.volunteerId = conId;
            h.duration = 1;
            h.startDate = Date.today();
            h.status = 'Confirmed';
            h.jobId = 'a0TW00000000001';
            h.shiftId = 'a0VW00000000001';
            return new List<VolunteerHoursViewModel>{h};
        }
    }
}