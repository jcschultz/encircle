@IsTest
private class VolunteerService_TEST {
    
    static testMethod void testRegistration() {
        String phone = '8568484606';
        
        Volunteer_Training__c training = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        insert training;
        
        Contact con = new Contact(
            FirstName = 'testing',
            LastName = 'lastName',
            Phone = phone
        );
        
        Test.startTest();
        
        VolunteerService.registerNewVolunteer(con, null);
        
        Contact conTest1 = [
            SELECT
                Id,
                FirstName,
                LastName,
                Notify_of_Upcoming_Trainings__c
            FROM Contact
            WHERE Phone = :phone
        ];
    
        System.assertEquals(con.FirstName, conTest1.FirstName);
        System.assertEquals(con.LastName, conTest1.LastName);
        System.assertEquals(true, conTest1.Notify_of_Upcoming_Trainings__c);
        
        // testing update on existing
        con.FirstName = 'newFirst';
        VolunteerService.registerNewVolunteer(con, 'X');
    
        Contact conTest2 = [
            SELECT
                Id,
                FirstName,
                Notify_of_Upcoming_Trainings__c
            FROM Contact
            WHERE Id = :con.Id
        ];
    
        System.assertEquals(con.FirstName, conTest2.FirstName);
        System.assertEquals(true, conTest2.Notify_of_Upcoming_Trainings__c);
        
        // testing update on existing with training attendance
        VolunteerService.registerNewVolunteer(con, training.Id);
        
        Contact conTest3 = [
            SELECT
                Id,
                Notify_of_Upcoming_Trainings__c
            FROM Contact
            WHERE Id = :con.Id
        ];
    
        System.assertEquals(false, conTest3.Notify_of_Upcoming_Trainings__c);
        
        Volunteer_Training_Attendance__c vta = [
            SELECT
                Volunteer__c,
                Volunteer_Training__c
            FROM Volunteer_Training_Attendance__c
            LIMIT 1
        ];
    
        System.assertEquals(training.Id, vta.Volunteer_Training__c);
        System.assertEquals(con.Id, vta.Volunteer__c);
        
        Test.stopTest();
    }
}