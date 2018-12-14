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
        VolunteerShiftCalendarService service = VolunteerShiftCalendarService.getInstance();
        return service.getCalendarFromDates(startDate, endDate);
    }
    
    
}