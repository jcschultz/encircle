@IsTest
private class VolunteerShiftService_TEST {
    
    private static Campaign unplannedCmp;
    private static GW_Volunteers__Volunteer_Job__c unplannedJob;
    private static GW_Volunteers__Volunteer_Job__c facJob;
    private static Date startDate;
    private static Date endDate;
    private static Id hourId;
    private static Id conId;
    private static Id shiftId;
    
    static {
        hourId = '003W00000000001';
        conId = '003000000000001';
        shiftId = 'a0VW00000000001';
        
        unplannedCmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'Unplanned Campaign',
            IsActive = true
        );
        insert unplannedCmp;
    
        unplannedJob = new GW_Volunteers__Volunteer_Job__c(
            Name = 'Unplanned Job',
            GW_Volunteers__Campaign__c = unplannedCmp.Id,
            GW_Volunteers__Display_on_Website__c = false
        );
        facJob = new GW_Volunteers__Volunteer_Job__c(
            Name = 'Facilitator Job',
            GW_Volunteers__Campaign__c = unplannedCmp.Id,
            GW_Volunteers__Display_on_Website__c = false
        );
        insert new List<GW_Volunteers__Volunteer_Job__c>{unplannedJob, facJob};
    
        Encircle_Volunteer_Settings__c settings = new Encircle_Volunteer_Settings__c();
        settings.Unplanned_Volunteering_Job_Id__c = unplannedJob.Id;
        settings.Facilitator_Job_Id__c = facJob.Id;
        insert settings;
    
        startDate = Date.newInstance(2020, 8, 14);
        endDate = Date.newInstance(2020, 8, 17);
    }
    
    @IsTest
    private static void testGetShifts() {
        VolunteerShiftMapper.instance = new VolunteerShiftMapperStub();
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerShiftService service = VolunteerShiftService.getInstance();
        
        List<VolunteerShiftViewModel> shifts = service.getShiftsBetweenDates(startDate, endDate);
        System.assertEquals(1, shifts.size());
        System.assertEquals(1, shifts[0].hours.size());
    }
    
    @IsTest
    private static void testSignUp() {
        VolunteerShiftMapper.instance = new VolunteerShiftMapperStub();
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        EmailService.instance = new EmailServiceStub();
        VolunteerShiftService service = VolunteerShiftService.getInstance();
        
        List<VolunteerHoursViewModel> hours = service.signVolunteerUpForHours(
            null, null, null
        );
        
        System.assertEquals(1, hours.size());
    }
    
    @IsTest
    private static void testComplete() {
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerShiftService service = VolunteerShiftService.getInstance();
        
        List<VolunteerHoursViewModel> hours = service.completeHoursById(null);
        System.assertEquals(1, hours.size());
    }
    
    @IsTest
    private static void testUnplanned() {
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerShiftService service = VolunteerShiftService.getInstance();
        
        VolunteerHoursViewModel hour = service.signInToUnplannedShift(conId, 1);
        System.assertEquals(conId, hour.volunteerId);
        System.assertEquals(unplannedJob.Id, hour.jobId);
    }
    
    @IsTest
    private static void testFacilitator() {
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerShiftService service = VolunteerShiftService.getInstance();
        
        VolunteerHoursViewModel hour = service.signInToFacilitatorShift(conId, 1);
        System.assertEquals(conId, hour.volunteerId);
        System.assertEquals(facJob.Id, hour.jobId);
    }
    
    
    private class VolunteerShiftMapperStub extends VolunteerShiftMapper{
        public override List<VolunteerShiftViewModel> getActiveShiftsBetweenDates(Date s, Date e) {
            return shifts();
        }
        
        public override List<VolunteerShiftViewModel> getShiftsByIds(Id[] ids) {
            return shifts();
        }
        
        private List<VolunteerShiftViewModel> shifts() {
            VolunteerShiftViewModel shift = new VolunteerShiftViewModel();
            shift.id = shiftId;
            shift.startDateTime = Datetime.now();
            shift.duration = 1;
            shift.locationZip = '12345';
            shift.locationState = 'UT';
            shift.locationCity = 'mytown';
            shift.locationStreet = 'street st';
            shift.jobName = 'my job';
            return new List<VolunteerShiftViewModel>{shift};
        }
    }
    
    private class VolunteerHourMapperStub extends VolunteerHourMapper {
        public override List<VolunteerHoursViewModel> getHoursByShiftId(Id[] ids) {
            return hours();
        }
        
        public override List<VolunteerHoursViewModel> saveNewHours(List<VolunteerHoursViewModel> hh) {
            List<VolunteerHoursViewModel> hours = hours();
            
            for (VolunteerHoursViewModel h : hours) {
                h.volunteerId = hh[0].volunteerId;
                h.jobId = hh[0].jobId;
            }
            return hours;
        }
        
        public override List<VolunteerHoursViewModel> completeHours(Id[] ids) {
            return hours();
        }
        
        private List<VolunteerHoursViewModel> hours() {
            VolunteerHoursViewModel h = new VolunteerHoursViewModel();
            h.id = hourId;
            h.shiftId = shiftId;
            h.startDatetime = Datetime.now();
            h.duration = 1;
            h.locationZip = '12345';
            h.locationState = 'UT';
            h.locationCity = 'mytown';
            h.locationStreet = 'street st';
            h.jobName = 'my job';
            return new List<VolunteerHoursViewModel>{h};
        }
    }
    
    private class EmailServiceStub extends EmailService {
        public override void buildEmailWithAttachment(EmailInfo info) {}
        public override void sendEmails() {}
    }
    

}