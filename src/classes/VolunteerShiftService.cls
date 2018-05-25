/**
 *
 * @description Service layer for volunteer shifts and jobs
 *
 * @author John Schultz
 * @date 2017-11-10
 */
public virtual class VolunteerShiftService {
    
    private enum UnplannedType {VOLUNTEER, FACILITATOR}
    
    public static final List<String> SIGNED_UP_STATUSES;
    public static final String COMPLETED_STATUS;
    public static final String ORG_WIDE_EMAIL_VOLUNTEER_MANAGER;
    
    static {
        SIGNED_UP_STATUSES = new List<String>{
            'Prospect',
            'Confirmed',
            'Web Sign Up'
        };
        
        COMPLETED_STATUS = 'Completed';
        ORG_WIDE_EMAIL_VOLUNTEER_MANAGER = 'Encircle Volunteer Manager';
    }
    
    @TestVisible
    private static VolunteerShiftService instance;

    protected VolunteerShiftService() { }

    public static VolunteerShiftService getInstance() {
        if (instance != null) {
            return instance;
        }

        instance = new VolunteerShiftService();
        return instance;
    }
    
    /**
     * Retrieves the volunteer shifts and any related sign-ups/hours.
     *
     * @param startDate
     * @param endDate (non-inclusive. this is 1 day beyond the last date)
     *
     * @return List of volunteer shifts
     */
    public virtual List<GW_Volunteers__Volunteer_Shift__c> getShiftsBetweenDates(Date startDate, Date endDate) {
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
                        OR GW_Volunteers__Status__c = :COMPLETED_STATUS
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
    public virtual List<GW_Volunteers__Volunteer_Hours__c> signContactUpForHours(String contactId, String[] shiftIds, String status) {
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
        
        
        if (!hours.isEmpty()) {
            insert hours;
            
            Set<Id> hoursIds = (new Map<Id, GW_Volunteers__Volunteer_Hours__c>(hours)).keySet();
            sendSignedUpConfirmationEmails(hoursIds);
        }
        
        return hours;
    }
    
    public virtual void sendSignedUpConfirmationEmails(Set<Id> hoursIds) {
        Set<Id> contactIds = new Set<Id>();
        EmailService eService = EmailService.getInstance();
        Id orgWideEmailAddressId;
        
        if (hoursIds == null || hoursIds.isEmpty()) {
            return;
        }
        
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>([
            SELECT
                Id,
                GW_Volunteers__Contact__c,
                GW_Volunteers__Contact__r.FirstName,
                GW_Volunteers__Volunteer_Job__c,
                GW_Volunteers__Volunteer_Job__r.Name,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_City__c,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location__c,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Street__c,
                GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Zip_Postal_Code__c,
                GW_Volunteers__Volunteer_Shift__c,
                GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Start_Date_Time__c,
                GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c
            FROM GW_Volunteers__Volunteer_Hours__c
            WHERE Id IN :hoursIds
                AND GW_Volunteers__Status__c IN :SIGNED_UP_STATUSES // only non-completed hours
                AND GW_Volunteers__Contact__c != null
                AND GW_Volunteers__Contact__r.Email != null
                AND GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Start_Date_Time__c != null
        ]);
        
        // get org wide email address to use as sender address on email.
        List<OrgWideEmailAddress> orgWideAddresses = new List<OrgWideEmailAddress>([
            SELECT Id, DisplayName FROM OrgWideEmailAddress
        ]);
        for (OrgWideEmailAddress owea : orgWideAddresses) {
            orgWideEmailAddressId = owea.Id;
            if (owea.DisplayName == ORG_WIDE_EMAIL_VOLUNTEER_MANAGER) {
                break;
            }
        }
        
        // if none of the email addresses match the volunteer manager display
        // name, just take the first one.
        if (orgWideEmailAddressId == null && !orgWideAddresses.isEmpty()) {
            orgWideEmailAddressId = orgWideAddresses[0].Id;
        }
        
        for (GW_Volunteers__Volunteer_Hours__c h : hours) {
            EmailService.EmailInfo info = new EmailService.EmailInfo();
            
            // duration in hours
            Decimal duration = h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c != null &&
                h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c > 0 ?
                h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c : 1;
            
            // set values used in invite attachment and email
            info.uids = h.Id + '-' + h.GW_Volunteers__Volunteer_Shift__c;
            info.startDatetime = h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Start_Date_Time__c;
            info.endDatetime = info.startDatetime.addMinutes(Integer.valueOf(duration * 60));
            info.location = locationBuilder(
                h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Street__c,
                h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_City__c,
                h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location__c,
                h.GW_Volunteers__Volunteer_Job__r.GW_Volunteers__Location_Zip_Postal_Code__c
            );
            info.inviteSummary = h.GW_Volunteers__Volunteer_Job__r.Name;
            info.subject = 'Encircle Volunteering Sign-Up Confirmation: ' + h.GW_Volunteers__Volunteer_Job__r.Name;
            info.orgWideEmailAddressId = orgWideEmailAddressId;
            info.recipientId = h.GW_Volunteers__Contact__c;
            
            String emailBody = '' +
            'Hi {0},\n' +
            '\n' +
            'Thank you for signing up to volunteer at Encircle! Below, you will '+
            'find the details for your volunteering shift. If you are not able ' +
            'to attend your shift, please remove the shift, so that others may ' +
            'sign up for it, by visiting: https://encircletogether.org/manage/\n' +
            '\n' +
            'Shift Name: {1}\n' +
            'Date and Time: {2}\n' +
            'Duration: {3} hour(s)\n' +
            'Location: {4}\n' +
            '\n' +
            'Sincerely,\n' +
            'Encircle';
            
            info.emailBody = String.format(
                emailBody,
                new String[] {
                    h.GW_Volunteers__Contact__r.FirstName,
                    h.GW_Volunteers__Volunteer_Job__r.Name,
                    h.GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Start_Date_Time__c.format('h:mm a, EEEE, MMMM d, yyyy'),
                    String.valueOf(duration),
                    info.location
                }
            );
            
            eService.buildEmailWithAttachment(info);
        }
        
        eService.sendEmails();
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
    public virtual List<GW_Volunteers__Volunteer_Hours__c> findHoursByContactAndDate(String[] contactIds, Date startDate, Date endDate) {
        List<GW_Volunteers__Volunteer_Hours__c> hours = new List<GW_Volunteers__Volunteer_Hours__c>([
            SELECT
                GW_Volunteers__Contact__c,
                Id,
                GW_Volunteers__Shift_Start_Date_Time__c,
                GW_Volunteers__Volunteer_Job__c,
                GW_Volunteers__Volunteer_Job__r.Name,
                GW_Volunteers__Volunteer_Shift__c,
                GW_Volunteers__Volunteer_Shift__r.GW_Volunteers__Duration__c
            FROM GW_Volunteers__Volunteer_Hours__c
            WHERE GW_Volunteers__Contact__c IN :contactIds
            AND GW_Volunteers__Start_Date__c >= :startDate
            AND GW_Volunteers__Start_Date__c < :endDate
            ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ASC
        ]);
        
        return hours;
    }
    
    /**
     * Mark the volunteer hours as completed.
     *
     * @param hourIds
     *
     * @return List of completed hours.
     */
    public virtual List<GW_Volunteers__Volunteer_Hours__c> completeHoursById(String[] hourIds) {
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
    
    /**
     * Signs a volunteer into the unplanned volunteer shift/job/campaign.
     *
     * @param contactId
     * @param duration
     *
     * @return Volunteer_Hours__c
     */
    public virtual GW_Volunteers__Volunteer_Hours__c signInToUnplannedShift(String contactId, Decimal duration) {
        return signInToUnplannedShift(contactId, duration, UnplannedType.VOLUNTEER);
    }
    
    /**
     * Signs a facilitator into the facilitator shift/job/campaign.
     *
     * @param contactId
     * @param duration
     *
     * @return Volunteer_Hours__c
     */
    public virtual GW_Volunteers__Volunteer_Hours__c signInToFacilitatorShift(String contactId, Decimal duration) {
        return signInToUnplannedShift(contactId, duration, UnplannedType.FACILITATOR);
    }
    
    private GW_Volunteers__Volunteer_Hours__c signInToUnplannedShift(String contactId, Decimal duration, UnplannedType upt) {
        Encircle_Volunteer_Settings__c settings = Encircle_Volunteer_Settings__c.getOrgDefaults();
        String jobId;
        
        if (upt == UnplannedType.VOLUNTEER) {
            jobId = settings.Unplanned_Volunteering_Job_Id__c;
        }
        else if (upt == UnplannedType.FACILITATOR) {
            jobId = settings.Facilitator_Job_Id__c;
        }
        
        GW_Volunteers__Volunteer_Job__c job = [
            SELECT
                GW_Volunteers__Campaign__c
            FROM GW_Volunteers__Volunteer_Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];
        
        GW_Volunteers__Volunteer_Hours__c hours = new GW_Volunteers__Volunteer_Hours__c(
            GW_Volunteers__Contact__c = contactId,
            GW_Volunteers__Hours_Worked__c = duration,
            GW_Volunteers__Number_of_Volunteers__c = 1,
            GW_Volunteers__Start_Date__c = Date.today(),
            GW_Volunteers__Status__c = COMPLETED_STATUS,
            GW_Volunteers__Volunteer_Job__c = jobId
        );
        
        insert hours;
        
        return hours;
    }
    
    private String locationBuilder(String street, String city, String state, String zip) {
        String location = '';
        
        if (String.isNotBlank(street)) {
            location += street;
            
            if (String.isNotBlank(city)) {
                location += ', ';
            }
        }
        
        if (String.isNotBlank(city)) {
            location += city;
            
            if (String.isNotBlank(state)) {
                location += ', ';
            }
        }
        
        location += String.isNotBlank(state) ? state + ' ' : '';
        location += String.isNotBlank(zip) ? zip : '';
        
        return location;
    }
    
}