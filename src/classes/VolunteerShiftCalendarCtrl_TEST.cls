@IsTest
private class VolunteerShiftCalendarCtrl_TEST {
    
    static testMethod void testRetrieval() {
        
        Account acc = new Account(
            Name = 'VolunteerShiftCalendarCtrl_TEST'
        );
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'test',
            LastName = 'VolunteerShiftCalendarCtrl_TEST',
            Email = 'VolunteerShiftCalendarCtrl_TEST@example.com'
        );
        insert con;
        
        Campaign cmp = new Campaign(
            RecordTypeId = GW_Volunteers.VOL_SharedCode.recordtypeIdVolunteersCampaign,
            Name = 'Test Job Campaign',
            IsActive = true
        );
        insert cmp;
        
        GW_Volunteers__Volunteer_Job__c job = new GW_Volunteers__Volunteer_Job__c(
            Name = 'Test Job',
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
        
        GW_Volunteers__Volunteer_Hours__c hours = new GW_Volunteers__Volunteer_Hours__c(
            GW_Volunteers__Contact__c = con.Id,
            GW_Volunteers__Hours_Worked__c = 1,
            GW_Volunteers__Number_of_Volunteers__c = 1,
            GW_Volunteers__Start_Date__c = shift.GW_Volunteers__Start_Date_Time__c.date(),
            GW_Volunteers__Status__c = 'Confirmed',
            GW_Volunteers__Volunteer_Job__c = job.Id,
            GW_Volunteers__Volunteer_Shift__c = shift.Id
        );
        insert hours;
        
        Test.startTest();
        
        
        VolunteerShiftCalendarController.CalendarData cd = VolunteerShiftCalendarController.getCalendarData('2020-08-15', '2020-08-17');
        System.assertEquals(3, cd.days.size());
        System.assertEquals(CalendarDataViewModel.ROW_TYPE_MONTH, cd.days[0].rowType);
        System.assertEquals(CalendarDataViewModel.ROW_TYPE_DAY, cd.days[1].rowType);
        System.assertEquals(1, cd.days[1].shifts.size());
        System.assertEquals(shift.Id, cd.days[1].shifts[0].shiftId);
        System.assertEquals(1, cd.days[1].shifts[0].volunteers.size());
        System.assertEquals(con.LastName, cd.days[1].shifts[0].volunteers[0].lastName);
        
        VolunteerShiftCalendarController.CalendarData cd2 = VolunteerShiftCalendarController.getInitialData();
        System.assertNotEquals(null, cd2);
        
        Test.stopTest();
    }

}