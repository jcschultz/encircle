@IsTest
private class VolunteerHourMapper_TEST {
    
    private static Account acc;
    private static Contact con;
    private static Campaign cmp;
    private static GW_Volunteers__Volunteer_Job__c job;
    private static GW_Volunteers__Volunteer_Shift__c shift;
    private static Date startDate;
    private static Date endDate;
    
    static {
        acc = new Account(
            Name = 'VolunteerShiftService_TEST'
        );
        insert acc;
        
        con = new Contact(
            AccountId = acc.Id,
            FirstName = 'test',
            LastName = 'VolunteerShiftService_TEST',
            Email = 'VolunteerShiftService_TEST@example.com'
        );
        insert con;
        
        cmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'VolunteerShiftService_TEST Campaign',
            IsActive = true
        );
        insert cmp;
        
        job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'VolunteerShiftService_TEST Job',
            GW_Volunteers__Campaign__c = cmp.Id,
            GW_Volunteers__Display_on_Website__c = true,
            GW_Volunteers__Location_City__c = 'myCity',
            GW_Volunteers__Location__c = 'UT',
            GW_Volunteers__Location_Street__c = '123 Street',
            GW_Volunteers__Location_Zip_Postal_Code__c = '12345'
        );
        insert job;
        
        shift = new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = Datetime.newInstance(2020, 8, 15)
        );
        insert shift;
        
        startDate = Date.newInstance(2020, 8, 14);
        endDate = Date.newInstance(2020, 8, 17);
    }
    
    @IsTest
    private static void testSaveAndGet() {
        VolunteerHourMapper mapper = VolunteerHourMapper.getInstance();
        
        VolunteerHoursViewModel vhvm = new VolunteerHoursViewModel();
        vhvm.volunteerId = con.Id;
        vhvm.duration = 1;
        vhvm.startDate = shift.GW_Volunteers__Start_Date_Time__c.date();
        vhvm.status = 'Confirmed';
        vhvm.jobId = job.Id;
        vhvm.shiftId = shift.Id;
        
        List<VolunteerHoursViewModel> hours = mapper.saveNewHours(
            new List<VolunteerHoursViewModel>{vhvm}
        );
        
        System.assertEquals(1, hours.size());
        System.assertEquals(vhvm.volunteerId, hours[0].volunteerId);
        System.assertEquals(vhvm.duration, hours[0].duration);
        System.assertEquals(vhvm.startDate, hours[0].startDate);
        System.assertEquals(vhvm.status, hours[0].status);
        System.assertEquals(vhvm.jobId, hours[0].jobId);
        System.assertEquals(vhvm.shiftId, hours[0].shiftId);
        System.assertEquals(shift.GW_Volunteers__Start_Date_Time__c.format('MMMMM'), hours[0].monthLabel);
        System.assertEquals(shift.GW_Volunteers__Start_Date_Time__c.format('MMM'), hours[0].monthAbbreviation);
        System.assertEquals(shift.GW_Volunteers__Start_Date_Time__c.day(), hours[0].dateOfMonth);
        System.assertEquals(shift.GW_Volunteers__Start_Date_Time__c.format('EEE'), hours[0].dayOfWeek);
        System.assertEquals(shift.GW_Volunteers__Start_Date_Time__c.format('h:mm a'), hours[0].startTime);
        
        List<VolunteerHoursViewModel> hoursByShift = mapper.getHoursByShiftId(
            new List<Id>{shift.Id}
        );
    
        System.assertEquals(1, hoursByShift.size());
        System.assertEquals(vhvm.volunteerId, hoursByShift[0].volunteerId);
        System.assertEquals(vhvm.duration, hoursByShift[0].duration);
        System.assertEquals(vhvm.startDate, hoursByShift[0].startDate);
        System.assertEquals(vhvm.status, hoursByShift[0].status);
        System.assertEquals(vhvm.jobId, hoursByShift[0].jobId);
        System.assertEquals(vhvm.shiftId, hoursByShift[0].shiftId);
    
        List<VolunteerHoursViewModel> hoursByVolunteer = mapper.getHoursByVolunteerIdsAndDate(
            new List<Id>{con.Id},
            startDate,
            endDate
        );
    
        System.assertEquals(1, hoursByVolunteer.size());
        System.assertEquals(vhvm.volunteerId, hoursByVolunteer[0].volunteerId);
        System.assertEquals(vhvm.duration, hoursByVolunteer[0].duration);
        System.assertEquals(vhvm.startDate, hoursByVolunteer[0].startDate);
        System.assertEquals(vhvm.status, hoursByVolunteer[0].status);
        System.assertEquals(vhvm.jobId, hoursByVolunteer[0].jobId);
        System.assertEquals(vhvm.shiftId, hoursByVolunteer[0].shiftId);
        
        mapper.completeHours(new List<Id>{hours[0].id});
        
        List<VolunteerHoursViewModel> hoursById = mapper.getHoursById(
            new List<Id>{hours[0].id}
        );
        
        System.assertEquals(1, hoursById.size());
        System.assertEquals(VolunteerHourMapper.COMPLETED_STATUS, hoursById[0].status);
    }
}