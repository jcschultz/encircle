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
    public static final String CONFIRMED_STATUS;
    public static final String COMPLETED_STATUS;
    public static final String ORG_WIDE_EMAIL_VOLUNTEER_MANAGER;
    
    static {
        SIGNED_UP_STATUSES = new List<String>{
            'Prospect',
            'Confirmed',
            'Web Sign Up'
        };
        
        CONFIRMED_STATUS = 'Confirmed';
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
    public virtual List<VolunteerShiftViewModel> getShiftsBetweenDates(Date startDate, Date endDate) {
        Map<Id, VolunteerShiftViewModel> shiftMap = new Map<Id, VolunteerShiftViewModel>();
        VolunteerShiftMapper shiftMapper = VolunteerShiftMapper.getInstance();
        VolunteerHourMapper hourMapper = VolunteerHourMapper.getInstance();
        
        List<VolunteerShiftViewModel> shifts = shiftMapper.getActiveShiftsBetweenDates(startDate, endDate);
        
        if (shifts == null || shifts.isEmpty()) {
            return null;
        }
    
        for (VolunteerShiftViewModel s : shifts) {
            shiftMap.put(s.id, s);
        }
        
        List<VolunteerHoursViewModel> hours = hourMapper.getHoursByShiftId(
            new List<Id>(shiftMap.keySet())
        );
        
        if (hours != null && !hours.isEmpty()) {
            for (VolunteerHoursViewModel h : hours) {
                if (shiftMap.get(h.shiftId).hours == null) {
                    shiftMap.get(h.shiftId).hours = new List<VolunteerHoursViewModel>();
                }
                
                shiftMap.get(h.shiftId).hours.add(h);
            }
        }
        
        return shifts;
    }
    
    /**
     * Creates volunteer hours (assigns volunteer to shift)
     *
     * @param volunteerId
     * @param shiftIds
     * @param status (Confirmed, Web Sign Up)
     *
     * @return List of volunteer hours
     */
    public virtual List<VolunteerHoursViewModel> signVolunteerUpForHours(String volunteerId, String[] shiftIds, String status) {
        List<VolunteerHoursViewModel> newHours = new List<VolunteerHoursViewModel>();
        VolunteerShiftMapper shiftMapper = VolunteerShiftMapper.getInstance();
        VolunteerHourMapper hourMapper = VolunteerHourMapper.getInstance();
        
        List<VolunteerShiftViewModel> shifts = shiftMapper.getShiftsByIds(shiftIds);
        
        for (VolunteerShiftViewModel s : shifts) {
            VolunteerHoursViewModel h = new VolunteerHoursViewModel();
            h.volunteerId = volunteerId;
            h.duration = s.duration;
            h.startDate = s.startDateTime.date();
            h.status = status;
            h.jobId = s.jobId;
            h.shiftId = s.id;
            
            newHours.add(h);
        }
        
        List<VolunteerHoursViewModel> hours = hourMapper.saveNewHours(newHours);
        sendSignedUpConfirmationEmails(hours);
        
        return hours;
        
    }
    
    public virtual void sendSignedUpConfirmationEmails(List<VolunteerHoursViewModel> hours) {
        EmailService eService = EmailService.getInstance();
        Id orgWideEmailAddressId;
        
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
        
        for (VolunteerHoursViewModel h : hours) {
            EmailService.EmailInfo info = new EmailService.EmailInfo();
            
            // duration in hours
            Decimal duration = h.duration != null &&
                h.duration > 0 ?
                h.duration : 1;
            
            // set values used in invite attachment and email
            info.uids = h.id + '-' + h.shiftId;
            info.startDatetime = h.startDatetime;
            info.endDatetime = info.startDatetime.addMinutes(Integer.valueOf(duration * 60));
            info.location = locationBuilder(
                h.locationStreet,
                h.locationCity,
                h.locationState,
                h.locationZip
            );
            info.inviteSummary = h.jobName;
            info.subject = 'Encircle Volunteering Sign-Up Confirmation: ' + h.jobName;
            info.orgWideEmailAddressId = orgWideEmailAddressId;
            info.recipientId = h.volunteerId;
            
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
                    h.volunteerFirstName,
                    h.jobName,
                    h.startDatetime.format('h:mm a, EEEE, MMMM d, yyyy'),
                    String.valueOf(duration),
                    info.location
                }
            );
            
            eService.buildEmailWithAttachment(info);
        }
        
        eService.sendEmails();
    }
    
    /**
     * Mark the volunteer hours as completed.
     *
     * @param hourIds
     *
     * @return List of completed hours.
     */
    public virtual List<VolunteerHoursViewModel> completeHoursById(String[] hourIds) {
        VolunteerHourMapper mapper = VolunteerHourMapper.getInstance();
        return mapper.completeHours(hourIds);
    }
    
    /**
     * Signs a volunteer into the unplanned volunteer shift/job/campaign.
     *
     * @param volunteerId
     * @param duration
     *
     * @return Volunteer_Hours__c
     */
    public virtual VolunteerHoursViewModel signInToUnplannedShift(String volunteerId, Decimal duration) {
        return signInToUnplannedShift(volunteerId, duration, UnplannedType.VOLUNTEER);
    }
    
    /**
     * Signs a facilitator into the facilitator shift/job/campaign.
     *
     * @param volunteerId
     * @param duration
     *
     * @return Volunteer_Hours__c
     */
    public virtual VolunteerHoursViewModel signInToFacilitatorShift(String volunteerId, Decimal duration) {
        return signInToUnplannedShift(volunteerId, duration, UnplannedType.FACILITATOR);
    }
    
    private VolunteerHoursViewModel signInToUnplannedShift(String volunteerId, Decimal duration, UnplannedType upt) {
        VolunteerHourMapper hourMapper = VolunteerHourMapper.getInstance();
        Encircle_Volunteer_Settings__c settings = Encircle_Volunteer_Settings__c.getOrgDefaults();
        String jobId;
        
        if (upt == UnplannedType.VOLUNTEER) {
            jobId = settings.Unplanned_Volunteering_Job_Id__c;
        }
        else if (upt == UnplannedType.FACILITATOR) {
            jobId = settings.Facilitator_Job_Id__c;
        }
    
        VolunteerHoursViewModel h = new VolunteerHoursViewModel();
        h.volunteerId = volunteerId;
        h.duration = duration;
        h.startDate = Date.today();
        h.status = COMPLETED_STATUS;
        h.jobId = jobId;
    
        List<VolunteerHoursViewModel> hours = hourMapper.saveNewHours(new List<VolunteerHoursViewModel>{h});
        
        return hours[0];
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