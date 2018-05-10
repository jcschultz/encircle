@IsTest
private class VolunteerService_TEST {
    
    private static Contact con;
    private static Contact facilitator;
    private static String phone;
    
    static {
        phone = '8568484606';
        
        con = new Contact(
            FirstName = 'testing',
            LastName = 'lastName',
            Phone = phone,
            Allowed_to_Volunteer__c = true,
            Volunteer__c = true
        );
        
        facilitator = new Contact(
            FirstName = 'Facilitator',
            LastName = 'Facilitator',
            Phone = '6064848658',
            Facilitator__c = true
        );
    }
    
    static testMethod void testRegistration() {
        VolunteerService service = VolunteerService.getInstance();
        Volunteer_Training__c training = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        insert training;
        
        
        Test.startTest();
        
        service.registerNewVolunteer(con, null);
        
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
        System.assertEquals(false, conTest1.Notify_of_Upcoming_Trainings__c);
        
        // testing update on existing
        con.FirstName = 'newFirst';
        service.registerNewVolunteer(con, 'X');
    
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
        service.registerNewVolunteer(con, training.Id);
        
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
    
    static testMethod void testFuzzySearch() {
        VolunteerService service = VolunteerService.getInstance();
        insert new List<Contact>{con, facilitator};
        
        Test.startTest();
        
        // testing for no results
        List<Contact> noResults = service.findContactByFuzzyNameSearch('xxxx');
        System.assertEquals(0, noResults.size());
        
        // testing for positive results
        List<Contact> hasResults = service.findContactByFuzzyNameSearch('tes las');
        System.assertEquals(1, hasResults.size());
        List<Contact> facilitators = service.findFacilitatorByFuzzyNameSearch('Facilitator');
        System.assertEquals(1, facilitators.size());
        
        Test.stopTest();
    }
}