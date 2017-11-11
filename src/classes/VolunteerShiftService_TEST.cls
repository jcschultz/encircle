@IsTest
private class VolunteerShiftService_TEST {
    
    @IsTest
    static void testShiftService() {
        Account acc = new Account(
            Name = 'VolunteerShiftService_TEST'
        );
        insert acc;
    
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'test',
            LastName = 'VolunteerShiftService_TEST',
            Email = 'VolunteerShiftService_TEST@example.com'
        );
        insert con;
    
        Campaign cmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'VolunteerShiftService_TEST Campaign',
            IsActive = true
        );
        insert cmp;
    
        GW_Volunteers__Volunteer_Job__c job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'VolunteerShiftService_TEST Job',
            GW_Volunteers__Campaign__c = cmp.Id,
            GW_Volunteers__Display_on_Website__c = true
        );
        insert job;
    
        GW_Volunteers__Volunteer_Shift__c shift = new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = Datetime.newInstance(2020, 8, 15)
        );
        insert shift;
        
        Test.startTest();
        
        Date startDate = Date.newInstance(2020, 8, 14);
        Date endDate = Date.newInstance(2020, 8, 17);
        
        // testing without any sign ups.
        List<GW_Volunteers__Volunteer_Shift__c> shifts1 = VolunteerShiftService.getShiftsBetweenDates(startDate, endDate);
        System.assertEquals(1, shifts1.size());
        System.assertEquals(0, shifts1[0].GW_Volunteers__Volunteer_Hours__r.size());
        
        // testing signup.
        List<GW_Volunteers__Volunteer_Hours__c> hours = VolunteerShiftService.signContactUpForHours(con.Id, new List<String>{shift.Id}, 'Confirmed');
        System.assertEquals(1, hours.size());
        List<GW_Volunteers__Volunteer_Shift__c> shifts2 = VolunteerShiftService.getShiftsBetweenDates(startDate, endDate);
        System.assertEquals(1, shifts2.size());
        System.assertEquals(1, shifts2[0].GW_Volunteers__Volunteer_Hours__r.size());
        System.assertEquals(con.Id, shifts2[0].GW_Volunteers__Volunteer_Hours__r[0].GW_Volunteers__Contact__c);
        
        Test.stopTest();
    }

}