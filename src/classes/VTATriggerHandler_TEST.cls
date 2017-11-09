@IsTest
private class VTATriggerHandler_TEST {
    
    private static testMethod void testDateChange() {
        Contact con = new Contact(
            FirstName = 'testVTTriggerHandler_TEST',
            LastName = 'testVTTriggerHandler_TEST'
        );
        insert con;
    
        Volunteer_Training__c training1 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        Volunteer_Training__c training2 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        insert new List<Volunteer_Training__c>{training1, training2};
    
        Volunteer_Training_Attendance__c vta = new Volunteer_Training_Attendance__c(
            Volunteer_Training__c = training1.Id,
            Volunteer__c = con.Id
        );
        insert vta;
        
        Volunteer_Training_Attendance__c test1 = [
            SELECT StartDateTime__c
            FROM Volunteer_Training_Attendance__c
            WHERE Id = :vta.Id
        ];
        
        // test beforeInsert
        System.assertEquals(training1.StartDateTime__c, test1.StartDateTime__c);
        
        // test reparenting
        vta.Volunteer_Training__c = training2.Id;
        update vta;
    
        Volunteer_Training_Attendance__c test2 = [
            SELECT StartDateTime__c
            FROM Volunteer_Training_Attendance__c
            WHERE Id = :vta.Id
        ];
        
        System.assertEquals(training2.StartDateTime__c, test2.StartDateTime__c);
    }
}