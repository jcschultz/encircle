/**
 * @author John Schultz
 * @date 2017-11-08
 *
 * @description Service layer for working with volunteers (contacts)
 */
public virtual without sharing class VolunteerService {
    
    private enum ContactType {ALL, VOLUNTEER, FACILTATOR}
    
    @TestVisible
    private static VolunteerService instance;

    protected VolunteerService() { }

    public static VolunteerService getInstance() {
        if (instance != null) {
            return instance;
        }

        instance = new VolunteerService();
        return instance;
    }
    
    public virtual VolunteerViewModel getVolunteerById(Id volunteerId) {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        return mapper.findById(volunteerId);
    }
    
    public virtual VolunteerViewModel getVolunteerAndUpcomingShifts(Id volunteerId) {
        return getVolunteerAndUpcomingShiftsByIdAndDate(
            volunteerId,
            Date.today(),
            null
        );
    }
    
    public virtual VolunteerViewModel getVolunteerAndTodaysUpcomingShifts(Id volunteerId) {
        return getVolunteerAndUpcomingShiftsByIdAndDate(
            volunteerId,
            Date.today(),
            Date.today().addDays(1)
        );
    }
    
    private VolunteerViewModel getVolunteerAndUpcomingShiftsByIdAndDate(Id volunteerId, Date startDate, Date endDate) {
        VolunteerHourMapper hourMapper = VolunteerHourMapper.getInstance();
        VolunteerViewModel vvm = getVolunteerById(volunteerId);
    
        if (vvm == null) {
            return null;
        }
    
        List<VolunteerHoursViewModel> hours = hourMapper.getHoursByVolunteerIdsAndDate(
            new List<Id>{vvm.id},
            startDate,
            endDate
        );
        
        if (hours != null && !hours.isEmpty()) {
            for (VolunteerHoursViewModel h : hours) {
                if (h.status != VolunteerHourMapper.COMPLETED_STATUS) {
                    if (vvm.hours == null) {
                        vvm.hours = new List<VolunteerHoursViewModel>();
                    }
                    vvm.hours.add(h);
                }
            }
        }
    
        return vvm;
    }
    
    public virtual VolunteerViewModel registerNewVolunteer(Map<String, Object> volunteerInfo) {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        VolunteerViewModel newVol = new VolunteerViewModel();
    
        newVol.legalFirstName = (String)volunteerInfo.get('firstName');
        newVol.lastName = (String)volunteerInfo.get('lastName');
        newVol.firstName = String.isNotBlank((String)volunteerInfo.get('preferredName'))
            ? (String)volunteerInfo.get('preferredName') : newVol.legalFirstName;
        newVol.pronouns = (String)volunteerInfo.get('pronouns');
        newVol.mailingStreet = (String)volunteerInfo.get('street');
        newVol.mailingCity = (String)volunteerInfo.get('city');
        newVol.mailingState = (String)volunteerInfo.get('state');
        newVol.mailingPostalCode = (String)volunteerInfo.get('zip');
        newVol.mailingCountry = (String)volunteerInfo.get('country');
        newVol.email = (String)volunteerInfo.get('email');
        newVol.phone = (String)volunteerInfo.get('phone1') +
            (String)volunteerInfo.get('phone2') +
            (String)volunteerInfo.get('phone3');
        newVol.birthdate = Date.valueOf((String)volunteerInfo.get('dobYear') +
            '-' + (String)volunteerInfo.get('dobMonth') +
            '-' + volunteerInfo.get('dobDay'));
        newVol.emergencyContactFirstName = (String)volunteerInfo.get('ecFirstName');
        newVol.emergencyContactLastName = (String)volunteerInfo.get('ecLastName');
        newVol.emergencyContactRelationship = (String)volunteerInfo.get('ecRelationship');
        newVol.emergencyContactPhone = (String)volunteerInfo.get('ecPhone1') +
            (String)volunteerInfo.get('ecPhone2') + (String)volunteerInfo.get('ecPhone3');
        newVol.volunteeringReason = (String)volunteerInfo.get('reason');
        newVol.isVolunteer = true;
        newVol.isFacilitator = false;
        newVol.allowedToVolunteer = false;
        newVol.currentlyHomeless = Boolean.valueOf((String)volunteerInfo.get('homeless'));
        newVol.hospitalizedintheLast6Months = Boolean.valueOf((String)volunteerInfo.get('hospitalized'));
        newVol.hospitalizationExplanation = (String)volunteerInfo.get('hospitalizationExplanation');
        newVol.volunteeringforSchoolCommService = Boolean.valueOf((String)volunteerInfo.get('volunteeringForSchool'));
        newVol.plannedLengthforSchoolCommService = (String)volunteerInfo.get('volunteeringForSchoolLength');
        
        return mapper.saveVolunteer(newVol);
    }
    
    public virtual List<VolunteerViewModel> findVolunteerByFuzzyNameSearch(String searchTerm) {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        return mapper.findVolunteerByFuzzyNameSearch(searchTerm);
    }
    
    public virtual List<VolunteerViewModel> findFacilitatorByFuzzyNameSearch(String searchTerm) {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        return mapper.findFacilitatorByFuzzyNameSearch(searchTerm);
    }
    
    public virtual Boolean isVolunteerMatched(Id volunteerId, String input) {
        String normalizedInput = String.isNotBlank(input) ? input.normalizeSpace() : null;
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        VolunteerViewModel volunteer = mapper.findById(volunteerId);
        
        return volunteer.lastName.equalsIgnoreCase(normalizedInput);
    }
    
    public virtual List<VolunteerViewModel> findVolunteersByEmailOrPhone(String input) {
        VolunteerMapper mapper = VolunteerMapper.getInstance();
        return mapper.findVolunteersByEmailOrPhone(input);
    }
}