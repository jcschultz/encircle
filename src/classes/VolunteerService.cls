/**
 * @author John Schultz
 * @date 2017-11-08
 *
 * @description Service layer for working with volunteers (contacts)
 */
public class VolunteerService {
    
    /**
     * @description Method for registering a new volunteer and setting them up
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
     * @description Retrieves contact by phone number.
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
}