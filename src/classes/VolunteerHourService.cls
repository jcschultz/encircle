public virtual without sharing class VolunteerHourService {
    public static final String ORG_WIDE_EMAIL_VOLUNTEER_MANAGER;
    
    static {
        ORG_WIDE_EMAIL_VOLUNTEER_MANAGER = 'Encircle Volunteer Manager';
    }
    
    @TestVisible
    private static VolunteerHourService instance;
    
    protected VolunteerHourService() { }
    
    public static VolunteerHourService getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerHourService();
        return instance;
    }
    
    public virtual List<VolunteerHoursViewModel> getUpcomingHoursByVolunteerId(Id volunteerId) {
        VolunteerHourMapper mapper = VolunteerHourMapper.getInstance();
        return mapper.getHoursByVolunteerIdsAndDate(
            new List<Id>{volunteerId},
            Date.today(),
            null
        );
    }
    
    public virtual List<VolunteerHoursViewModel> deleteHours(Id volunteerId, Id[] hourIds) {
        VolunteerHourMapper mapper = VolunteerHourMapper.getInstance();
        mapper.deleteHours(hourIds);
        return getUpcomingHoursByVolunteerId(volunteerId);
    }
}