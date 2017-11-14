@IsTest
private class VolunteerShiftSignupCtrl_TEST {
    
    static testMethod void testSearchAndSignup() {
        Account acc = new Account(
            Name = 'VolunteerShiftService_TEST'
        );
        insert acc;
    
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'test',
            LastName = 'VolunteerShiftService_TEST',
            Email = 'VolunteerShiftService_TEST@example.com',
            Volunteer__c = true,
            Allowed_to_Volunteer__c = true
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
        
        // testing search.
        List<Contact> contacts = VolunteerShiftSignupController.searchContacts('test');
        System.assertEquals(1, contacts.size());
        System.assertEquals(con.Id, contacts[0].Id);
        
        // test signup
        List<GW_Volunteers__Volunteer_Hours__c> hours = VolunteerShiftSignupController.signUpContactForShifts(con.Id, new List<String>{shift.Id});
        System.assertEquals(1, hours.size());
        System.assertEquals(shift.Id, hours[0].GW_Volunteers__Volunteer_Shift__c);
        System.assertEquals(con.Id, hours[0].GW_Volunteers__Contact__c);
        
        Test.stopTest();
    }

}