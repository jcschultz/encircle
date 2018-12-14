@IsTest
private class VolunteerRegistrationController_TEST {
    
    @IsTest
    private static void testRegistration() {
        
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
            'homeless' => 'false',
            'hospitalized' => 'true',
            'hospitalizationExplanation' => 'dfdf',
            'volunteeringForSchool' => 'true',
            'volunteeringForSchoolLength' => '1 month'
        };
        
        VolunteerViewModel vvm = VolunteerRegistrationController.registerVolunteer(volunteerInfo);
        System.assertNotEquals(null, vvm);
    }
    
    @IsTest
    private static void testPicklists() {
        System.assertNotEquals(null, VolunteerRegistrationController.getPronouns());
    }
    
    private class VolunteerServiceStub extends VolunteerService {
        public override VolunteerViewModel registerNewVolunteer(Map<String, Object> volunteerInfo) {
            return new VolunteerViewModel();
        }
    }

}