/**
 * @author John Schultz
 * @date 2017-11-08
 *
 * @description Service layer for working with volunteers (contacts)
 */
public class VolunteerService {
    
    private enum ContactType {ALL, VOLUNTEER, FACILTATOR}
    
    /**
     * Method for registering a new volunteer and setting them up
     * with a training attendance.
     *
     * @param con
     * @param trainingId
     */
    public static void registerNewVolunteer(Contact con, String trainingId) {
        Contact existingContact;
        Volunteer_Training_Attendance__c vta;
        
        // first check to see if a contact already exists with that phone number
        existingContact = findByPhone(con.Phone);
        
        if (existingContact != null) {
            con.Id = existingContact.Id;
        }
        
        con.Notify_of_Upcoming_Trainings__c = (String.isBlank(trainingId) ||
            trainingId == 'X');
        
        // upsert contact and details
        upsert con;
        
        // if a training id was provided, create a new corresponding training
        // attendance record.
        if (String.isNotBlank(trainingId) && trainingId != 'X') {
            vta = new Volunteer_Training_Attendance__c(
                Volunteer__c = con.Id,
                Volunteer_Training__c = trainingId
            );
            
            insert vta;
        }
    }
    
    /**
     * Retrieves contact by phone number.
     *
     * @param phone
     *
     * @return Contact
     */
    public static Contact findByPhone(String phone) {
        Contact c;
        
        List<Contact> results = new List<Contact>([
            SELECT
                Id
            FROM Contact
            WHERE Phone = :phone
            LIMIT 1
        ]);
        
        if (!results.isEmpty()) {
            c = results[0];
        }
        
        return c;
    }
    
    /**
     * Retrieves contact by fuzzy search on names
     *
     * @param searchTerm: A string of words, separated by spaces
     *
     * @return List of contacts
     */
    public static List<Contact> findContactByFuzzyNameSearch(String searchTerm) {
        return searchContacts(searchTerm, ContactType.VOLUNTEER);
    }
    
    /**
     * Retrieves facilitator contacts by fuzzy search on names.
     *
     * @param searchTerm: A string of words, separated by spaces
     *
     * @return List of contacts
     */
    public static List<Contact> findFacilitatorByFuzzyNameSearch(String searchTerm) {
        return searchContacts(searchTerm, ContactType.FACILTATOR);
    }
    
    
    /**
     * Retrieves a list of contacts based on fuzzy name match and contact type.
     *
     * @param searchTerm: A string of words, separated by spaces
     * @param ct: ContactType enum
     *
     * @return List of contacts
     */
    private static List<Contact> searchContacts(String searchTerm, ContactType ct) {
        List<Contact> contacts;
        List<String> terms = new List<String>();
    
        if (String.isNotBlank(searchTerm)) {
            for (String s : searchTerm.split(' ')) {
                terms.add('%' + s + '%');
            }
            
            String q = '';
            q += 'SELECT ';
            q += '  Id, ';
            q += '  Name ';
            q += 'FROM Contact ';
            q += 'WHERE ( ';
            q += '  FirstName LIKE :terms ';
            q += '  OR LastName LIKE :terms ';
            q += '  OR Legal_First_Name__c LIKE :terms ';
            q += ') ';
            
            if (ct == ContactType.VOLUNTEER) {
                q += ' AND Allowed_to_Volunteer__c = true ';
                q += ' AND Volunteer__c = true ';
            }
            else if (ct == ContactType.FACILTATOR) {
                q += ' AND Facilitator__c = true ';
            }
            
            q += 'ORDER BY FirstName ';
        
            contacts = Database.query(q);
        }
    
        return contacts;
    }
}