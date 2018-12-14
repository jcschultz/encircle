public virtual without sharing class VolunteerShiftCalendarService {
    
    @TestVisible
    private static VolunteerShiftCalendarService instance;
    
    protected VolunteerShiftCalendarService() { }
    
    public static VolunteerShiftCalendarService getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerShiftCalendarService();
        return instance;
    }
    
    public virtual CalendarDataViewModel getCalendarFromDates(Date startDate, Date endDate) {
        Map<Date, List<VolunteerShiftViewModel>> dates = new Map<Date, List<VolunteerShiftViewModel>>();
        CalendarDataViewModel cdvm = new CalendarDataViewModel();
        VolunteerShiftService vsService = VolunteerShiftService.getInstance();
        Integer daysBetween = startDate.daysBetween(endDate);
        String lastMonth = '';
    
        // build the calendar dates.
        for (Integer i = 0; i < daysBetween; i++) {
            dates.put(startDate.addDays(i), new List<VolunteerShiftViewModel>());
        }
    
        cdvm.nextStartDate = endDate;
        cdvm.nextEndDate = cdvm.nextStartDate.addMonths(1);
    
        // inject volunteer shifts and sign-ups into the calendar.
        for (VolunteerShiftViewModel vs : vsService.getShiftsBetweenDates(startDate, endDate)) {
            Date d = vs.startDateTime.date();
        
            if (dates.containsKey(d)) {
                dates.get(d).add(vs);
            }
        }
    
        for (Date d : dates.keySet()) {
            List<VolunteerShiftViewModel> shifts = dates.get(d);
            Datetime dt = Datetime.newInstance(d, Time.newInstance(0,0,0,0));
            String monthLabel = dt.format('MMMMM');
            String monthAbbreviation = dt.format('MMM');
            Integer dateOfMonth = d.day();
            String dayOfWeek = dt.format('EEE');
        
            // need to create a new month header row if the data shows this as a new month.
            if (monthLabel != lastMonth) {
                CalendarRowViewModel monthRow = new CalendarRowViewModel(CalendarRowViewModel.ROW_TYPE_MONTH);
                monthRow.monthLabel = monthLabel;
                cdvm.days.add(monthRow);
                lastMonth = monthLabel;
            }
        
            CalendarRowViewModel dayRow = new CalendarRowViewModel(CalendarRowViewModel.ROW_TYPE_DAY);
            dayRow.monthLabel = monthLabel;
            dayRow.monthAbbreviation = monthAbbreviation;
            dayRow.dateOfMonth = dateOfMonth;
            dayRow.dayOfWeek = dayOfWeek;
        
            if (shifts != null && !shifts.isEmpty()) {
                for (VolunteerShiftViewModel vs : shifts) {
                    CalendarShiftViewModel shift = new CalendarShiftViewModel();
                    shift.jobName = vs.jobName;
                    shift.jobId = vs.jobId;
                    shift.shiftId = vs.id;
                    shift.startTime = vs.startDateTime.format('h:mm a');
                    shift.duration = vs.duration;
                    shift.volunteersNeeded = Integer.valueOf(vs.volunteersDesired);
                    shift.volunteersStillNeeded = Integer.valueOf(vs.volunteersStillNeeded);
                    shift.volunteersSignedUp = Integer.valueOf(vs.totalVolunteers);
                
                    if (vs.hours != null && !vs.hours.isEmpty()) {
                        for (VolunteerHoursViewModel h : vs.hours) {
                            if (h.volunteerId != null) {
                                CalendarVolunteerViewModel volunteer = new CalendarVolunteerViewModel();
                                volunteer.firstInitial = h.volunteerFirstName != null ? h.volunteerFirstName.left(1) : '';
                                volunteer.lastName = h.volunteerLastName;
                            
                                shift.volunteers.add(volunteer);
                            }
                        }
                    }
                
                    dayRow.shifts.add(shift);
                }
            }
        
            cdvm.days.add(dayRow);
        }
    
        return cdvm;
    }

}