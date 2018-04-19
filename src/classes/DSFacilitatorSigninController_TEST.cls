@isTest
private class DSFacilitatorSigninController_TEST {
    
    private static Account acc;
    private static Contact con;
    private static Campaign cmp;
    private static Campaign unplannedCmp;
    private static GW_Volunteers__Volunteer_Job__c job;
    private static GW_Volunteers__Volunteer_Job__c unplannedJob;
    private static GW_Volunteers__Volunteer_Shift__c shift;
    private static GW_Volunteers__Volunteer_Hours__c hours;
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
            LastName = 'DSFacSIC_TEST',
            Email = 'DSFacSIC_TEST@example.com',
            Facilitator__c = true
        );
        insert con;
        
        cmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'DSFacilitatorSigninController_TEST Campaign',
            IsActive = true
        );
        unplannedCmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'Facilitator Campaign',
            IsActive = true
        );
        insert new List<Campaign>{cmp, unplannedCmp};
        
        job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'DSFacilitatorSigninController_TEST Job',
            GW_Volunteers__Campaign__c = cmp.Id,
            GW_Volunteers__Display_on_Website__c = true
        );
        unplannedJob = new GW_Volunteers__Volunteer_Job__c(
            Name = 'Facilitator Job',
            GW_Volunteers__Campaign__c = unplannedCmp.Id,
            GW_Volunteers__Display_on_Website__c = false
        );
        insert new List<GW_Volunteers__Volunteer_Job__c>{job, unplannedJob};
        
        shift = new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = Datetime.now(),
            GW_Volunteers__Desired_Number_of_Volunteers__c = 1
        );
        insert shift;
        
        hours = new GW_Volunteers__Volunteer_Hours__c(
            GW_Volunteers__Contact__c = con.Id,
            GW_Volunteers__Hours_Worked__c = 1,
            GW_Volunteers__Number_of_Volunteers__c = 1,
            GW_Volunteers__Start_Date__c = shift.GW_Volunteers__Start_Date_Time__c.date(),
            GW_Volunteers__Status__c = 'Confirmed',
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Volunteer_Shift__c = shift.Id
        );
        
        
        Encircle_Volunteer_Settings__c settings = new Encircle_Volunteer_Settings__c();
        settings.Facilitator_Job_Id__c = unplannedJob.Id;
        insert settings;
        
        startDate = Date.newInstance(2020, 8, 14);
        endDate = Date.newInstance(2020, 8, 17);
    }
    
    
    static testMethod void testSignIn() {
        Test.startTest();
        
        List<DoorSurveyVolunteerViewModel> results = DSFacilitatorSigninController.searchContacts(con.FirstName);
        System.assertEquals(1, results.size());
        System.assertEquals(con.Id, results[0].contactId);
    
        DSFacilitatorSigninController.signIn(con.Id, 2.5);
        List<GW_Volunteers__Volunteer_Hours__c> hoursTest = [SELECT GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__c];
        System.assertEquals(1, hoursTest.size());
        System.assertEquals(VolunteerShiftService.COMPLETED_STATUS, hoursTest[0].GW_Volunteers__Status__c);
        
        Test.stopTest();
    }
}