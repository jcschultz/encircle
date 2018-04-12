@isTest
private class MyVolunteerProfileController_TEST {
    
    static testMethod void testSearchAndDelete() {
        Account acc = new Account(
            Name = 'MyVolunteerProfileController_TEST'
        );
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'test',
            LastName = 'MyVolunteerProfileController_TEST',
            Email = 'MyVolunteerProfileController_TEST@example.com',
            Volunteer__c = true,
            Allowed_to_Volunteer__c = true
        );
        insert con;
        
        Campaign cmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'MyVolunteerProfileController_TEST Campaign',
            IsActive = true
        );
        insert cmp;
        
        GW_Volunteers__Volunteer_Job__c job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'MyVolunteerProfileController_TEST Job',
            GW_Volunteers__Campaign__c = cmp.Id,
            GW_Volunteers__Display_on_Website__c = true
        );
        insert job;
        
        GW_Volunteers__Volunteer_Shift__c shift = new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = Datetime.now().addDays(5)
        );
        insert shift;
        
        GW_Volunteers__Volunteer_Hours__c hour = new GW_Volunteers__Volunteer_Hours__c(
            GW_Volunteers__Contact__c = con.Id,
            GW_Volunteers__Hours_Worked__c = shift.GW_Volunteers__Duration__c,
            GW_Volunteers__Number_of_Volunteers__c = 1,
            GW_Volunteers__Start_Date__c = shift.GW_Volunteers__Start_Date_Time__c.date(),
            GW_Volunteers__Status__c = 'Confirmed',
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Volunteer_Shift__c = shift.Id
        );
        insert hour;
        
        Test.startTest();
        
        // testing search.
        List<VolunteerViewModel> contacts = MyVolunteerProfileController.searchContacts('test');
        System.assertEquals(1, contacts.size());
        System.assertEquals(con.Id, contacts[0].id);
        
        // test getting upcoming hours
        List<VolunteerHoursViewModel> upcoming = MyVolunteerProfileController.getUpcomingShifts(con.Id);
        System.assertEquals(1, upcoming.size());
        
        // test deleting
        List<VolunteerHoursViewModel> remaining = MyVolunteerProfileController.deleteShift(con.Id, hour.Id);
        System.assertEquals(0, remaining.size());
        
        Test.stopTest();
    }
    
}