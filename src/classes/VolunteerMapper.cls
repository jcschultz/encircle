public virtual without sharing class VolunteerMapper {
    private enum ContactType {ALL, VOLUNTEER, FACILTATOR}
    
    @TestVisible
    private static VolunteerMapper instance;
    
    protected VolunteerMapper() { }
    
    public static VolunteerMapper getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerMapper();
        return instance;
    }
    
    public virtual VolunteerViewModel saveVolunteer(VolunteerViewModel vol) {
        if (vol.id == null) {
            VolunteerViewModel existingVolunteer;
    
            // first check to see if a contact already exists with that phone number
            existingVolunteer = findByPhone(vol.phone);
    
            if (existingVolunteer != null) {
                vol.id = existingVolunteer.id;
            }
        }
        
        Contact c = new Contact();
        c.Id = vol.id;
        c.Legal_First_Name__c = vol.legalFirstName;
        c.LastName = vol.lastName;
        c.FirstName = vol.firstName;
        c.Pronouns__c = vol.pronouns;
        c.MailingStreet = vol.mailingStreet;
        c.MailingCity = vol.mailingCity;
        c.MailingState = vol.mailingState;
        c.MailingPostalCode = vol.mailingPostalCode;
        c.MailingCountry = vol.mailingCountry;
        c.Email = vol.email;
        c.Phone = vol.phone;
        c.Birthdate = vol.birthdate;
        c.Emergency_Contact_First_Name__c = vol.emergencyContactFirstName;
        c.Emergency_Contact_Last_Name__c = vol.emergencyContactLastName;
        c.Emergency_Contact_Relationship__c = vol.emergencyContactRelationship;
        c.Emergency_Contact_Phone__c = vol.emergencyContactPhone;
        c.Volunteer__c = true;
        
        // upsert contact and details
        upsert c;
        
        return findById(c.Id);
    }
    
    public virtual VolunteerViewModel findById(Id volunteerId) {
        VolunteerViewModel volunteer;
    
        String whereClause = ' WHERE Id = \'' + volunteerId + '\' ';
    
        List<VolunteerViewModel> volunteers = queryContact(whereClause);
    
        if (volunteers != null && !volunteers.isEmpty()) {
            volunteer = volunteers[0];
        }
    
        return volunteer;
    }
    
    public virtual VolunteerViewModel findByPhone(String phone) {
        VolunteerViewModel volunteer;
        
        String whereClause = ' WHERE Phone = \'' + phone + '\' ';
        
        List<VolunteerViewModel> volunteers = queryContact(whereClause);
        
        if (volunteers != null && !volunteers.isEmpty()) {
            volunteer = volunteers[0];
        }
        
        return volunteer;
    }
    
    public virtual List<VolunteerViewModel> findVolunteerByFuzzyNameSearch(String searchTerm) {
        return fuzzySearchByType(searchTerm, ContactType.VOLUNTEER);
    }
    
    public virtual List<VolunteerViewModel> findFacilitatorByFuzzyNameSearch(String searchTerm) {
        return fuzzySearchByType(searchTerm, ContactType.FACILTATOR);
    }
    
    public virtual List<VolunteerViewModel> findVolunteersByEmailOrPhone(String input) {
        List<VolunteerViewModel> volunteers;
        
        if (isValidEmail(input) || isValidPhone(input)) {
            volunteers = new List<VolunteerViewModel>();
            String escapedInputForEmail = escapeInputForSosl(input);
            String cleanedPhone = cleanPhone(input);
            String searchTerms = String.isNotBlank(escapedInputForEmail) ? escapedInputForEmail : '';
            
            if (String.isNotBlank(searchTerms) && String.isNotBlank(cleanedPhone)) {
                searchTerms += ' OR ';
            }
            
            searchTerms += String.isNotBlank(cleanedPhone) ? cleanedPhone : '';
            
            System.debug('searchTerms: ' + JSON.serialize(searchTerms));
            
            if (String.isNotBlank(searchTerms)) {
                List<String> fields = getFields();
                String queryString = String.format(
                    'FIND :searchTerms IN ALL FIELDS RETURNING Contact ({0})',
                    new List<String> {String.join(fields, ',')}
                );
                
                List<List<SObject>> results = Search.query(queryString);
                
                if (results != null && !results.isEmpty() && results[0] != null && !results[0].isEmpty()) {
                    for (SObject s : results[0]) {
                        volunteers.add(new VolunteerViewModel((Contact)s));
                    }
                }
            }
        }
        
        return volunteers;
    }
    
    private List<VolunteerViewModel> fuzzySearchByType(String searchTerm, ContactType ct) {
        if (String.isEmpty(searchTerm)) {
            return null;
        }
        
        List<String> terms = new List<String>();
    
        for (String s : searchTerm.split(' ')) {
            terms.add('\'%' + s + '%\'');
        }
        
        String whereClause = ' WHERE ( ';
        
        List<String> likes = new List<String>();
        for (String t : terms) {
            likes.add(' FirstName LIKE ' + t + ' ');
            likes.add(' LastName LIKE ' + t + ' ');
            likes.add(' Legal_First_Name__c LIKE ' + t + ' ');
        }
        
        whereClause += String.join(likes, ' OR ');
        
        whereClause += ') ';
    
        if (ct == ContactType.VOLUNTEER) {
            whereClause += ' AND Volunteer__c = true ';
        }
        else if (ct == ContactType.FACILTATOR) {
            whereClause += ' AND Facilitator__c = true ';
        }
        
        return queryContact(whereClause);
    }
    
    private List<VolunteerViewModel> queryContact(String whereClause) {
        List<VolunteerViewModel> volunteers;
        
        List<String> fields = getFields();

        String queryString = String.format(
            'SELECT {0} FROM Contact ',
            new List<String> {String.join(fields, ',')}
        );
    
        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }
        
        queryString += ' ORDER BY FirstName ';
        
        for (Contact c : Database.query(queryString)) {
            if (volunteers == null) {
                volunteers = new List<VolunteerViewModel>();
            }
            
            volunteers.add(new VolunteerViewModel(c));
        }
        
        
        return volunteers;
    }
    
    private List<String> getFields() {
        List<String> fields = new List<String> {
            'Id',
            'Name',
            'Legal_First_Name__c',
            'LastName',
            'FirstName',
            'Pronouns__c',
            'MailingStreet',
            'MailingCity',
            'MailingState',
            'MailingPostalCode',
            'MailingCountry',
            'Email',
            'Phone',
            'Birthdate',
            'Emergency_Contact_First_Name__c',
            'Emergency_Contact_Last_Name__c',
            'Emergency_Contact_Relationship__c',
            'Emergency_Contact_Phone__c',
            'Allowed_to_Volunteer__c',
            'Volunteer__c',
            'Facilitator__c'
        };
        
        return fields;
    }
    
    private Boolean isValidEmail(String input) {
        return String.isNotBlank(input) &&
            input.indexOf('@') > 0 &&
            input.indexOf('.') > -1 &&
            input.countMatches('@') == 1;
    }
    
    private Boolean isValidPhone(String input) {
        String cleaned = cleanPhone(input);
        
        return String.isNotBlank(cleaned) &&
            cleaned.length() == 10;
    }
    
    private String cleanPhone(String input) {
        String dirtyInput = String.isNotBlank(input) ? input : '';
        Pattern nonNumeric = Pattern.compile('[^0-9]');
        Matcher matcher = nonNumeric.matcher(dirtyInput);
        
        return matcher.replaceAll('');
    }
    
    private String escapeInputForSosl(String input) {
        String escapedText = String.escapeSingleQuotes(input);
        
        // remove reserved logical operators
        escapedText = escapedText.replaceAll('(?i)( AND NOT | AND | OR )', ' ');
        
        // match special characters to escape
        Pattern myPattern = Pattern.compile('(\\?|\\&|\\||\\!|\\{|\\}|\\[|\\]|\\(|\\)|\\^|\\~|\\*|\\:|\\"|\\+|\\-)');
        Matcher myMatcher = myPattern.matcher(escapedText);
        
        // escape special characters
        escapedText = myMatcher.replaceAll('\\\\\\\\$1');
        
        // collapse extra whitespace
        escapedText = escapedText.replaceAll('( )+', ' ').trim();
        
        return escapedText;
    }
}