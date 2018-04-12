/**
 * @author John Schultz
 * @date 2017-11-09
 *
 * @description Controller for VolunteerShiftCalendar component.
 */
public without sharing class VolunteerShiftCalendarController {
    
    /**
     * Retrieves the volunteer calendar and data for the remainder of the current
     * month plus the following month.
     *
     * @return Calendar days and volunteer shifts
     */
    @AuraEnabled
    public static CalendarDataViewModel getInitialData() {
        Date startDate = Date.today();
        Date endDate = startDate.toStartOfMonth().addMonths(1);
        return getCalendarFromDates(startDate, endDate);
    }
    
    /**
     * Retrieves the volunteer calendar and data for the date range provided.
     *
     * @param startDateString Date in string format of YYYY-MM-DD
     * @param endDateString Date in string format of YYYY-MM-DD. The end date
     * is actually 1 day beyond the last day that will be included in the data.
     *
     * @return Calendar days and volunteer shifts
     */
    @AuraEnabled
    public static CalendarDataViewModel getCalendarData(String startDateString, String endDateString) {
        String[] startDateParts = startDateString.split('-');
        String[] endDateParts = endDateString.split('-');
        Date startDate = Date.newInstance(
            Integer.valueOf(startDateParts[0]),
            Integer.valueOf(startDateParts[1]),
            Integer.valueOf(startDateParts[2])
        );
        Date endDate = Date.newInstance(
            Integer.valueOf(endDateParts[0]),
            Integer.valueOf(endDateParts[1]),
            Integer.valueOf(endDateParts[2])
        );
        
        return getCalendarFromDates(startDate, endDate);
    }
    
    /**
     * Retrieves the volunteer calendar and data for the date range provided.
     *
     * @param startDate First date to include
     * @param endDate 1 day beyond the last day that will be included in the data.
     * In other words, if you want to include up to April 15, endDate should be
     * April 16.
     *
     * @return Calendar days and volunteer shifts.
     */
    public static CalendarDataViewModel getCalendarFromDates(Date startDate, Date endDate) {
        Map<Date, List<GW_Volunteers__Volunteer_Shift__c>> dates = new Map<Date, List<GW_Volunteers__Volunteer_Shift__c>>();
        CalendarDataViewModel cdvm = new CalendarDataViewModel();
        Integer daysBetween = startDate.daysBetween(endDate);
        String lastMonth = '';
        
        // build the calendar dates.
        for (Integer i = 0; i < daysBetween; i++) {
            dates.put(startDate.addDays(i), new List<GW_Volunteers__Volunteer_Shift__c>());
        }
    
        cdvm.nextStartDate = endDate;
        cdvm.nextEndDate = cdvm.nextStartDate.addMonths(1);
        
        // inject volunteer shifts and sign-ups into the calendar.
        for (GW_Volunteers__Volunteer_Shift__c vs : VolunteerShiftService.getShiftsBetweenDates(startDate, endDate)) {
            Date d = vs.GW_Volunteers__Start_Date_Time__c.date();
            
            if (dates.containsKey(d)) {
                dates.get(d).add(vs);
            }
        }
        
        for (Date d : dates.keySet()) {
            List<GW_Volunteers__Volunteer_Shift__c> shifts = dates.get(d);
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
                for (GW_Volunteers__Volunteer_Shift__c vs : shifts) {
                    CalendarShiftViewModel shift = new CalendarShiftViewModel();
                    shift.jobName = vs.GW_Volunteers__Volunteer_Job__r.Name;
                    shift.jobId = vs.GW_Volunteers__Volunteer_Job__c;
                    shift.shiftId = vs.Id;
                    shift.startTime = vs.GW_Volunteers__Start_Date_Time__c.format('h:mm a');
                    shift.duration = vs.GW_Volunteers__Duration__c;
                    shift.volunteersNeeded = Integer.valueOf(vs.GW_Volunteers__Desired_Number_of_Volunteers__c);
                    shift.volunteersStillNeeded = Integer.valueOf(vs.GW_Volunteers__Number_of_Volunteers_Still_Needed__c);
                    shift.volunteersSignedUp = Integer.valueOf(vs.GW_Volunteers__Total_Volunteers__c);
                    
                    if (vs.GW_Volunteers__Volunteer_Hours__r != null && !vs.GW_Volunteers__Volunteer_Hours__r.isEmpty()) {
                        for (GW_Volunteers__Volunteer_Hours__c h : vs.GW_Volunteers__Volunteer_Hours__r) {
                            if (h.GW_Volunteers__Contact__r != null) {
                                CalendarVolunteerViewModel volunteer = new CalendarVolunteerViewModel();
                                volunteer.firstInitial = h.GW_Volunteers__Contact__r.FirstName != null ? h.GW_Volunteers__Contact__r.FirstName.left(1) : '';
                                volunteer.lastName = h.GW_Volunteers__Contact__r.LastName;
                                
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