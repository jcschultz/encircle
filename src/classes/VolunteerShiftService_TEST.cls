@IsTest
private class VolunteerShiftService_TEST {
    
    private static Account acc;
    private static Contact con;
    private static Campaign cmp;
    private static Campaign unplannedCmp;
    private static GW_Volunteers__Volunteer_Job__c job;
    private static GW_Volunteers__Volunteer_Job__c unplannedJob;
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
        unplannedCmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'Unplanned Campaign',
            IsActive = true
        );
        insert new List<Campaign>{cmp, unplannedCmp};
    
        job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'VolunteerShiftService_TEST Job',
            GW_Volunteers__Campaign__c = cmp.Id,
            GW_Volunteers__Display_on_Website__c = true
        );
        unplannedJob = new GW_Volunteers__Volunteer_Job__c(
            Name = 'Unplanned Job',
            GW_Volunteers__Campaign__c = unplannedCmp.Id,
            GW_Volunteers__Display_on_Website__c = false
        );
        insert new List<GW_Volunteers__Volunteer_Job__c>{job, unplannedJob};
    
        shift = new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = Datetime.newInstance(2020, 8, 15)
        );
        insert shift;
    
        Encircle_Volunteer_Settings__c settings = new Encircle_Volunteer_Settings__c();
        settings.Unplanned_Volunteering_Job_Id__c = unplannedJob.Id;
        insert settings;
    
        startDate = Date.newInstance(2020, 8, 14);
        endDate = Date.newInstance(2020, 8, 17);
    }
    
    static testMethod void testNoSignups() {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        Test.startTest();
        
        // testing without any sign ups.
        List<GW_Volunteers__Volunteer_Shift__c> shifts = vsService.getShiftsBetweenDates(startDate, endDate);
        System.assertEquals(1, shifts.size());
        System.assertEquals(0, shifts[0].GW_Volunteers__Volunteer_Hours__r.size());
        
        Test.stopTest();
    }
    
    static testMethod void testSignUpAndCompletion() {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        Test.startTest();
        
        // testing signup.
        List<GW_Volunteers__Volunteer_Hours__c> hours = vsService.signContactUpForHours(con.Id, new List<String>{shift.Id}, 'Confirmed');
        System.assertEquals(1, hours.size());
        List<GW_Volunteers__Volunteer_Shift__c> shifts = vsService.getShiftsBetweenDates(startDate, endDate);
        System.assertEquals(1, shifts.size());
        System.assertEquals(1, shifts[0].GW_Volunteers__Volunteer_Hours__r.size());
        System.assertEquals(con.Id, shifts[0].GW_Volunteers__Volunteer_Hours__r[0].GW_Volunteers__Contact__c);
        
        // testing finding hours
        List<GW_Volunteers__Volunteer_Hours__c> hours2 = vsService.findHoursByContactAndDate(new List<String>{con.Id}, startDate, endDate);
        System.assertEquals(1, hours2.size());
        
        // test completing hours
        vsService.completeHoursById(new List<String>{hours2[0].Id});
        GW_Volunteers__Volunteer_Hours__c hours3 = [SELECT GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__c WHERE Id = :hours2[0].Id LIMIT 1];
        System.assertEquals(VolunteerShiftService.COMPLETED_STATUS, hours3.GW_Volunteers__Status__c);
        
        Test.stopTest();
    }
    
    static testMethod void testUnPlanned() {
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        Test.startTest();
    
        GW_Volunteers__Volunteer_Hours__c hours = vsService.signInToUnplannedShift(con.Id, 2.0);
        System.assertEquals(unplannedJob.Id, hours.GW_Volunteers__Volunteer_Job__c);
    
        GW_Volunteers__Volunteer_Hours__c testHour = [SELECT GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__c WHERE Id = :hours.Id LIMIT 1];
        System.assertEquals(VolunteerShiftService.COMPLETED_STATUS, testHour.GW_Volunteers__Status__c);
        
        Test.stopTest();
    }

}