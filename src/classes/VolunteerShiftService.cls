/**
 *
 * @description Service layer for volunteer shifts and jobs
 *
 * @author John Schultz
 * @date 2017-11-10
 */
public class VolunteerShiftService {
    
    public static final List<String> SIGNED_UP_STATUSES;
    public static final String COMPLETED_STATUS;
    
    static {
        SIGNED_UP_STATUSES = new List<String>{
            'Prospect',
            'Confirmed',
            'Web Sign Up'
        };
        
        COMPLETED_STATUS = 'Completed';
    }
    
    /**
     * Retrieves the volunteer shifts and any related sign-ups/hours.
     *
     * @param startDate
     * @param endDate (non-inclusive. this is 1 day beyond the last date)
     *
     * @return List of volunteer shifts
     */
    public static List<GW_Volunteers__Volunteer_Shift__c> getShiftsBetweenDates(Date startDate, Date endDate) {
        Datetime startDateTime = Datetime.newInstance(startDate, Time.newInstance(0,0,0,0));
        Datetime endDateTime = Datetime.newInstance(endDate, Time.newInstance(0,0,0,0));
        return [
            SELECT
                Id,
                GW_Volunteers__Description__c,
                GW_Volunteers__Desired_Number_of_Volunteers__c,
                GW_Volunteers__Duration__c,
                GW_Volunteers__Job_Location_City__c,
                GW_Volunteers__Job_Location_State_Province__c,
                GW_Volunteers__Job_Location_Street__c,
                GW_Volunteers__Job_Location_Zip_Postal_Code__c,
                Name,
                GW_Volunteers__Number_of_Volunteers_Still_Needed__c,
                GW_Volunteers__Start_Date_Time__c,
                GW_Volunteers__Total_Volunteers__c,
                GW_Volunteers__Volunteer_Job__c,
                GW_Volunteers__Volunteer_Job__r.Name,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Volunteer_Website_Time_Zone__c,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__r.GW_Volunteers__Volunteer_Website_Time_Zone__c,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__c,
                (
                    SELECT
                        Id,
                        Name,
                        GW_Volunteers__Contact__c,
                        GW_Volunteers__Contact__r.FirstName,
                        GW_Volunteers__Contact__r.LastName
                    FROM GW_Volunteers__Volunteer_Hours__r
                    WHERE GW_Volunteers__Status__c IN :SIGNED_UP_STATUSES
                )
            FROM GW_Volunteers__Volunteer_Shift__c
            WHERE GW_Volunteers__Start_Date_Time__c >= :startDateTime
            AND GW_Volunteers__Start_Date_Time__c < :endDateTime
            AND GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Campaign__r.IsActive = true
            AND GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Display_On_Website__c = true
            ORDER BY GW_Volunteers__Start_Date_Time__c ASC
        ];
    }
    
    /**
     * Creates volunteer hours (assigns volunteer to shift)
     *
     * @param contactId
     * @param shiftIds
     * @param status (Confirmed, Web Sign Up)
     *
     * @return List of volunteer hours
     */
    public static List<GW_Volunteers__Volunteer_Hours__c> signContactUpForHours(String contactId, String[] shiftIds, String status) {
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>();
        
        for (GW_Volunteers__Volunteer_Shift__c vs : [
            SELECT
                Id,
                GW_Volunteers__Duration__c,
                GW_Volunteers__Start_Date_Time__c,
                GW_Volunteers__Volunteer_Job__c
            FROM GW_Volunteers__Volunteer_Shift__c
            WHERE Id IN :shiftIds
        ]) {
            
            hours.add(new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId,
                GW_Volunteers__Hours_Worked__c = vs.GW_Volunteers__Duration__c,
                GW_Volunteers__Number_of_Volunteers__c = 1,
                GW_Volunteers__Start_Date__c = vs.GW_Volunteers__Start_Date_Time__c.date(),
                GW_Volunteers__Status__c = status,
                GW_Volunteers__Volunteer_Job__c = vs.GW_Volunteers__Volunteer_Job__c,
                GW_Volunteers__Volunteer_Shift__c = vs.Id
            ));
        }
        
        insert hours;
        
        return hours;
    }
    
    /**
     * Finds volunteer shift hours for the contacts and date range.
     *
     * @param contactIds
     * @param startDate
     * @param endDate
     *
     * @return List of volunteer hour records.
     */
    public static List<GW_Volunteers__Volunteer_Hours__c> findHoursByContactAndDate(String[] contactIds, Date startDate, Date endDate) {
        return [
            SELECT
                GW_Volunteers__Contact__c,
                Id,
                GW_Volunteers__Shift_Start_Date_Time__c,
                GW_Volunteers__Volunteer_Job__r.Name
            FROM GW_Volunteers__Volunteer_Hours__c
            WHERE GW_Volunteers__Contact__c IN :contactIds
            AND GW_Volunteers__Start_Date__c >= :startDate
            AND GW_Volunteers__Start_Date__c < :endDate
            ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ASC
        ];
    }
    
    /**
     * Mark the volunteer hours as completed.
     *
     * @param hourIds
     *
     * @return List of completed hours.
     */
    public static List<GW_Volunteers__Volunteer_Hours__c> completeHoursById(String[] hourIds) {
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>();
        
        for (String h : hourIds) {
            hours.add(new GW_Volunteers__Volunteer_Hours__c(
                Id = h,
                GW_Volunteers__Status__c = COMPLETED_STATUS
            ));
        }
        
        update hours;
        
        return hours;
    }
    
}