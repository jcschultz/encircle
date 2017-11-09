@IsTest
private class VTTriggerHandler_TEST {
    
    private static testMethod void testChangedDate() {
        Contact con = new Contact(
            FirstName = 'testVTTriggerHandler_TEST',
            LastName = 'testVTTriggerHandler_TEST'
        );
        insert con;
        
        Volunteer_Training__c training = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        insert training;
        
        Volunteer_Training_Attendance__c vta = new Volunteer_Training_Attendance__c(
            Volunteer_Training__c = training.Id,
            Volunteer__c = con.Id
        );
        insert vta;
        
        Test.startTest();
        
        training.StartDateTime__c = Datetime.now().addDays(2);
        update training;
        
        Test.stopTest();
        
        Volunteer_Training_Attendance__c testVta = [
            SELECT
                Id,
                StartDateTime__c
            FROM Volunteer_Training_Attendance__c
            WHERE Id = :vta.Id
        ];
    
        System.assertEquals(training.StartDateTime__c, testVta.StartDateTime__c);
    }
}