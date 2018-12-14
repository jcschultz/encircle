@IsTest
private class VolunteerShiftMapper_TEST {
    
    private static Campaign cmp;
    private static GW_Volunteers__Volunteer_Job__c job;
    private static GW_Volunteers__Volunteer_Shift__c shift;
    private static Date startDate;
    private static Date endDate;
    
    static {
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
    private static void testGettingShiftsById() {
        VolunteerShiftMapper mapper = VolunteerShiftMapper.getInstance();
        
        List<VolunteerShiftViewModel> shifts = mapper.getShiftsByIds(
            new List<Id>{shift.Id}
        );
        
        System.assertEquals(1, shifts.size());
        System.assertEquals(job.Name, shifts[0].jobName);
        System.assertEquals(job.Id, shifts[0].jobId);
        System.assertEquals(cmp.Id, shifts[0].campaignId);
        System.assertEquals(shift.Id, shifts[0].id);
    }
    
    @IsTest
    private static void testGetByDates() {
        VolunteerShiftMapper mapper = VolunteerShiftMapper.getInstance();
        
        List<VolunteerShiftViewModel> shifts = mapper.getActiveShiftsBetweenDates(
            startDate,
            endDate
        );
        
        System.assertEquals(1, shifts.size());
        System.assertEquals(1, shifts.size());
        System.assertEquals(job.Name, shifts[0].jobName);
        System.assertEquals(job.Id, shifts[0].jobId);
        System.assertEquals(cmp.Id, shifts[0].campaignId);
        System.assertEquals(shift.Id, shifts[0].id);
    }
    
    @IsTest
    private static void testNoActiveCampaigns() {
        cmp.IsActive = false;
        update cmp;
    
        VolunteerShiftMapper mapper = VolunteerShiftMapper.getInstance();
    
        List<VolunteerShiftViewModel> shifts = mapper.getActiveShiftsBetweenDates(
            startDate,
            endDate
        );
        
        System.assertEquals(null, shifts);
    }
    
    @IsTest
    private static void testBadDates() {
        cmp.IsActive = false;
        update cmp;
        
        VolunteerShiftMapper mapper = VolunteerShiftMapper.getInstance();
        
        List<VolunteerShiftViewModel> shifts = mapper.getActiveShiftsBetweenDates(
            Date.newInstance(2009, 1, 1),
            Date.newInstance(2009, 1, 2)
        );
        
        System.assertEquals(null, shifts);
    }
}