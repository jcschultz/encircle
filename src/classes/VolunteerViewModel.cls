public class VolunteerViewModel {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String secondaryInfo;
    @AuraEnabled
    public List<VolunteerHoursViewModel> hours;
    @AuraEnabled
    public String legalFirstName;
    @AuraEnabled
    public String lastName;
    @AuraEnabled
    public String firstName;
    @AuraEnabled
    public String pronouns;
    @AuraEnabled
    public String mailingStreet;
    @AuraEnabled
    public String mailingCity;
    @AuraEnabled
    public String mailingState;
    @AuraEnabled
    public String mailingPostalCode;
    @AuraEnabled
    public String mailingCountry;
    @AuraEnabled
    public String email;
    @AuraEnabled
    public String phone;
    @AuraEnabled
    public Date birthdate;
    @AuraEnabled
    public String emergencyContactFirstName;
    @AuraEnabled
    public String emergencyContactLastName;
    @AuraEnabled
    public String emergencyContactRelationship;
    @AuraEnabled
    public String emergencyContactPhone;
    @AuraEnabled
    public Boolean allowedToVolunteer;
    @AuraEnabled
    public Boolean isVolunteer;
    @AuraEnabled
    public Boolean isFacilitator;
    
    public String volunteeringReason;
    public Boolean currentlyHomeless;
    public Boolean hospitalizedintheLast6Months;
    public String hospitalizationExplanation;
    public Boolean volunteeringforSchoolCommService;
    public String plannedLengthforSchoolCommService;
    
    
    
    public VolunteerViewModel(Contact c) {
        name = c.Name;
        id = c.Id;
        legalFirstName = c.Legal_First_Name__c;
        lastName = c.LastName;
        firstName = c.FirstName;
        pronouns = c.Pronouns__c;
        mailingStreet = c.MailingStreet;
        mailingCity = c.MailingCity;
        mailingState = c.MailingState;
        mailingPostalCode = c.MailingPostalCode;
        mailingCountry = c.MailingCountry;
        email = c.Email;
        phone = c.Phone;
        birthdate = c.Birthdate;
        emergencyContactFirstName = c.Emergency_Contact_First_Name__c;
        emergencyContactLastName = c.Emergency_Contact_Last_Name__c;
        emergencyContactRelationship = c.Emergency_Contact_Relationship__c;
        emergencyContactPhone = c.Emergency_Contact_Phone__c;
        allowedToVolunteer = c.Allowed_to_Volunteer__c;
        isVolunteer = c.Volunteer__c;
        isFacilitator = c.Facilitator__c;
    }
    
    public VolunteerViewModel() {}
}