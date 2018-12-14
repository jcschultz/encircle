@IsTest
private class VolShiftCalService_TEST {
    
    private static Datetime startDateTime;
    private static Id hourId;
    private static Id conId;
    private static Id shiftId;
    private static Id jobId;
    
    static {
        startDateTime = Datetime.newInstance(2020, 2, 1, 12, 0, 0);
        hourId = '003W00000000001';
        conId = '003000000000001';
        shiftId = 'a0VW00000000001';
        jobId = 'a0TW00000000001';
    }
    
    @IsTest
    private static void testGetCal() {
        VolunteerShiftService.instance = new VolunteerShiftServiceStub();
        VolunteerShiftCalendarService service = VolunteerShiftCalendarService.getInstance();
        
        CalendarDataViewModel cdvm = service.getCalendarFromDates(
            startDateTime.date(),
            startDateTime.addDays(1).date()
        );
        
        System.assertEquals(startDateTime.addDays(1).date(), cdvm.nextStartDate);
        System.assertEquals(2, cdvm.days.size());
        System.assertEquals(1, cdvm.days[1].shifts.size());
        System.assertEquals(1, cdvm.days[1].shifts[0].volunteers.size());
    }
    
    
    private class VolunteerShiftServiceStub extends VolunteerShiftService {
        public override List<VolunteerShiftViewModel> getShiftsBetweenDates(Date s, Date e) {
            VolunteerShiftViewModel shift = new VolunteerShiftViewModel();
            shift.jobName = 'my job';
            shift.jobId = jobId;
            shift.id = shiftId;
            shift.startDateTime = startDateTime;
            shift.duration = 1;
            shift.volunteersDesired = 2;
            shift.volunteersStillNeeded = 1;
            shift.totalVolunteers = 1;
            
            VolunteerHoursViewModel hour = new VolunteerHoursViewModel();
            hour.volunteerFirstName = 'first';
            hour.volunteerLastName = 'last';
            hour.volunteerId = conId;
            hour.shiftId = shiftId;
            
            shift.hours = new List<VolunteerHoursViewModel>{hour};
            
            return new List<VolunteerShiftViewModel>{shift};
        }
    }
}