@IsTest
private class VolunteerMapper_TEST {
    
    private static VolunteerViewModel testVolunteer;
    private static Date birthDate;
    
    static {
        birthDate = Date.today();
        
        testVolunteer = new VolunteerViewModel();
        testVolunteer.legalFirstName = 'legalFirst';
        testVolunteer.lastName = 'lastVolunteerMapperTest';
        testVolunteer.firstName = 'nickname';
        testVolunteer.pronouns = 'He/His/Him';
        testVolunteer.mailingStreet = '123 street Ave Dr';
        testVolunteer.mailingCity = 'Towntown';
        testVolunteer.mailingState = 'TN';
        testVolunteer.mailingPostalCode = '97643';
        testVolunteer.mailingCountry = 'USA';
        testVolunteer.email = 'volunteermapper@example.com';
        testVolunteer.phone = '8818181881';
        testVolunteer.birthdate = birthDate;
        testVolunteer.emergencyContactFirstName = 'emFirst';
        testVolunteer.emergencyContactLastName = 'emLast';
        testVolunteer.emergencyContactRelationship = 'cousin';
        testVolunteer.emergencyContactPhone = '4541712487';
    }
    
    @IsTest
    private static void testSaveNew() {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        
        // save new with no other contacts in database.
        VolunteerViewModel inserted1 = mapper.saveVolunteer(testVolunteer);
        
        Contact c1 = [SELECT Id FROM Contact WHERE LastName = :testVolunteer.lastName];
        System.assertEquals(inserted1.id, c1.Id);
        
        // save new with existing contact but without providing ID.
        mapper.saveVolunteer(testVolunteer);
        Contact c2 = [SELECT Id FROM Contact WHERE LastName = :testVolunteer.lastName];
        System.assertEquals(c1.Id, c2.Id);
        
        // save with existing id.
        testVolunteer.id = c2.Id;
        mapper.saveVolunteer(testVolunteer);
        List<Contact> contacts = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = :testVolunteer.lastName
        ]);
        System.assertEquals(1, contacts.size());
        System.assertEquals(c1.Id, contacts[0].Id);
    }
    
    @IsTest
    private static void testFindById() {
        Contact testContact = new Contact(
            Id = testVolunteer.id,
            Legal_First_Name__c = testVolunteer.legalFirstName,
            LastName = testVolunteer.lastName,
            FirstName = testVolunteer.firstName,
            Pronouns__c = testVolunteer.pronouns,
            MailingStreet = testVolunteer.mailingStreet,
            MailingCity = testVolunteer.mailingCity,
            MailingState = testVolunteer.mailingState,
            MailingPostalCode = testVolunteer.mailingPostalCode,
            MailingCountry = testVolunteer.mailingCountry,
            Email = testVolunteer.email,
            Phone = testVolunteer.phone,
            Birthdate = testVolunteer.birthdate,
            Emergency_Contact_First_Name__c = testVolunteer.emergencyContactFirstName,
            Emergency_Contact_Last_Name__c = testVolunteer.emergencyContactLastName,
            Emergency_Contact_Relationship__c = testVolunteer.emergencyContactRelationship,
            Emergency_Contact_Phone__c = testVolunteer.emergencyContactPhone
        );
        
        insert testContact;
        
        Test.startTest();
    
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        VolunteerViewModel retrieved = mapper.findById(testContact.Id);
        checkMatch(retrieved);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testFindByPhone() {
        Contact testContact = new Contact(
            Id = testVolunteer.id,
            Legal_First_Name__c = testVolunteer.legalFirstName,
            LastName = testVolunteer.lastName,
            FirstName = testVolunteer.firstName,
            Pronouns__c = testVolunteer.pronouns,
            MailingStreet = testVolunteer.mailingStreet,
            MailingCity = testVolunteer.mailingCity,
            MailingState = testVolunteer.mailingState,
            MailingPostalCode = testVolunteer.mailingPostalCode,
            MailingCountry = testVolunteer.mailingCountry,
            Email = testVolunteer.email,
            Phone = testVolunteer.phone,
            Birthdate = testVolunteer.birthdate,
            Emergency_Contact_First_Name__c = testVolunteer.emergencyContactFirstName,
            Emergency_Contact_Last_Name__c = testVolunteer.emergencyContactLastName,
            Emergency_Contact_Relationship__c = testVolunteer.emergencyContactRelationship,
            Emergency_Contact_Phone__c = testVolunteer.emergencyContactPhone
        );
        
        insert testContact;
        
        Test.startTest();
        
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        VolunteerViewModel retrieved = mapper.findByPhone(testContact.Phone);
        checkMatch(retrieved);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testFindByEmailOrPhone() {
        Contact testContact = new Contact(
            Id = testVolunteer.id,
            Legal_First_Name__c = testVolunteer.legalFirstName,
            LastName = testVolunteer.lastName,
            FirstName = testVolunteer.firstName,
            Pronouns__c = testVolunteer.pronouns,
            MailingStreet = testVolunteer.mailingStreet,
            MailingCity = testVolunteer.mailingCity,
            MailingState = testVolunteer.mailingState,
            MailingPostalCode = testVolunteer.mailingPostalCode,
            MailingCountry = testVolunteer.mailingCountry,
            Email = testVolunteer.email,
            Phone = testVolunteer.phone,
            Birthdate = testVolunteer.birthdate,
            Emergency_Contact_First_Name__c = testVolunteer.emergencyContactFirstName,
            Emergency_Contact_Last_Name__c = testVolunteer.emergencyContactLastName,
            Emergency_Contact_Relationship__c = testVolunteer.emergencyContactRelationship,
            Emergency_Contact_Phone__c = testVolunteer.emergencyContactPhone
        );
    
        insert testContact;
        
        Id[] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = testContact.Id;
        
        Test.startTest();
        Test.setFixedSearchResults(fixedSearchResults);
        
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        List<VolunteerViewModel> retrieved = mapper.findVolunteersByEmailOrPhone(testContact.Phone);
        checkMatch(retrieved[0]);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testFindVolunteerByName() {
        Contact testContact = new Contact(
            Id = testVolunteer.id,
            Legal_First_Name__c = testVolunteer.legalFirstName,
            LastName = testVolunteer.lastName,
            FirstName = testVolunteer.firstName,
            Pronouns__c = testVolunteer.pronouns,
            MailingStreet = testVolunteer.mailingStreet,
            MailingCity = testVolunteer.mailingCity,
            MailingState = testVolunteer.mailingState,
            MailingPostalCode = testVolunteer.mailingPostalCode,
            MailingCountry = testVolunteer.mailingCountry,
            Email = testVolunteer.email,
            Phone = testVolunteer.phone,
            Birthdate = testVolunteer.birthdate,
            Emergency_Contact_First_Name__c = testVolunteer.emergencyContactFirstName,
            Emergency_Contact_Last_Name__c = testVolunteer.emergencyContactLastName,
            Emergency_Contact_Relationship__c = testVolunteer.emergencyContactRelationship,
            Emergency_Contact_Phone__c = testVolunteer.emergencyContactPhone,
            Volunteer__c = true
        );
        
        insert testContact;
        
        Test.startTest();
        
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        List<VolunteerViewModel> retrieved = mapper.findVolunteerByFuzzyNameSearch(testContact.LastName);
        checkMatch(retrieved[0]);
        
        Test.stopTest();
    }
    
    @IsTest
    private static void testFindFacilitatorByName() {
        Contact testContact = new Contact(
            Id = testVolunteer.id,
            Legal_First_Name__c = testVolunteer.legalFirstName,
            LastName = testVolunteer.lastName,
            FirstName = testVolunteer.firstName,
            Pronouns__c = testVolunteer.pronouns,
            MailingStreet = testVolunteer.mailingStreet,
            MailingCity = testVolunteer.mailingCity,
            MailingState = testVolunteer.mailingState,
            MailingPostalCode = testVolunteer.mailingPostalCode,
            MailingCountry = testVolunteer.mailingCountry,
            Email = testVolunteer.email,
            Phone = testVolunteer.phone,
            Birthdate = testVolunteer.birthdate,
            Emergency_Contact_First_Name__c = testVolunteer.emergencyContactFirstName,
            Emergency_Contact_Last_Name__c = testVolunteer.emergencyContactLastName,
            Emergency_Contact_Relationship__c = testVolunteer.emergencyContactRelationship,
            Emergency_Contact_Phone__c = testVolunteer.emergencyContactPhone,
            Facilitator__c = true
        );
        
        insert testContact;
        
        Test.startTest();
        
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        List<VolunteerViewModel> retrieved = mapper.findFacilitatorByFuzzyNameSearch(testContact.Legal_First_Name__c);
        checkMatch(retrieved[0]);
        
        Test.stopTest();
    }
    
    private static void checkMatch(VolunteerViewModel retrieved) {
        System.assertEquals(testVolunteer.legalFirstName, retrieved.legalFirstName);
        System.assertEquals(testVolunteer.lastName, retrieved.lastName);
        System.assertEquals(testVolunteer.firstName, retrieved.firstName);
        System.assertEquals(testVolunteer.pronouns, retrieved.pronouns);
        System.assertEquals(testVolunteer.mailingStreet, retrieved.mailingStreet);
        System.assertEquals(testVolunteer.mailingCity, retrieved.mailingCity);
        System.assertEquals(testVolunteer.mailingState, retrieved.mailingState);
        System.assertEquals(testVolunteer.mailingPostalCode, retrieved.mailingPostalCode);
        System.assertEquals(testVolunteer.mailingCountry, retrieved.mailingCountry);
        System.assertEquals(testVolunteer.email, retrieved.email);
        System.assertEquals(testVolunteer.phone, retrieved.phone);
        System.assertEquals(testVolunteer.birthdate, retrieved.birthdate);
        System.assertEquals(testVolunteer.emergencyContactFirstName, retrieved.emergencyContactFirstName);
        System.assertEquals(testVolunteer.emergencyContactLastName, retrieved.emergencyContactLastName);
        System.assertEquals(testVolunteer.emergencyContactRelationship, retrieved.emergencyContactRelationship);
        System.assertEquals(testVolunteer.emergencyContactPhone, retrieved.emergencyContactPhone);
    }
}