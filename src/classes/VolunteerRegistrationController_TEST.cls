@IsTest
private class VolunteerRegistrationController_TEST {
    
    static testMethod void testRegistration() {
        Volunteer_Training__c training = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now()
        );
        insert training;
        
        Map<String, String> volunteerInfo = new Map<String, String>{
            'firstName' => 'testFirst',
            'lastName' => 'testLast',
            'preferredName' => 'testPN',
            'pronouns' => 'He/him/his',
            'street' => '123 test st lane',
            'city' => 'testville',
            'state' => 'TN',
            'zip' => '44544',
            'country' => 'USA',
            'email' => 'VolunteerRegistrationControllerTEST@example.com',
            'phone1' => '856',
            'phone2' => '848',
            'phone3' => '4607',
            'dobYear' => '1900',
            'dobMonth' => '12',
            'dobDay' => '15',
            'ecFirstName' => 'testEcFirst',
            'ecLastName' => 'testEcLast',
            'ecRelationship' => 'mom',
            'ecPhone1' => '856',
            'ecPhone2' => '848',
            'ecPhone3' => '4608',
            'reason' => 'my reason',
            'training' => training.Id,
            'homeless' => 'false',
            'hospitalized' => 'true',
            'hospitalizationExplanation' => 'dfdf',
            'volunteeringForSchool' => 'true',
            'volunteeringForSchoolLength' => '1 month'
        };
        
        Test.startTest();
        
        VolunteerRegistrationController.registerVolunteer(volunteerInfo);
        
        Test.stopTest();
        
        Contact testCon = [
            SELECT
                Id,
                Legal_First_Name__c
            FROM Contact
            WHERE FirstName = :volunteerInfo.get('preferredName')
            AND LastName = :volunteerInfo.get('lastName')
            LIMIT 1
        ];
    
        System.assertEquals(volunteerInfo.get('firstName'), testCon.Legal_First_Name__c);
    }
    
    static testMethod void testPicklists() {
        Volunteer_Training__c training1 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(1)
        );
        Volunteer_Training__c training2 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(-1)
        );
        insert new List<Volunteer_Training__c>{training1, training2};
        
        Test.startTest();
    
        List<TrainingModel> trainings = VolunteerRegistrationController.getTrainings();
        System.assertEquals(1, trainings.size());
        System.assertEquals(training1.Id, trainings[0].id);
    
        System.assertNotEquals(null, VolunteerRegistrationController.getPronouns());
        
        Test.stopTest();
    }

}