@IsTest
private class VolunteerShiftCalendarCtrl_TEST {
    
    @IsTest
    private static void testInitialData() {
        VolunteerShiftCalendarService.instance = new VolunteerShiftCalendarServiceStub();
        
        CalendarDataViewModel cdvm = VolunteerShiftCalendarController.getInitialData();
        System.assertEquals(1, cdvm.days.size());
        System.assertEquals(1, cdvm.days[0].shifts.size());
        System.assertEquals(1, cdvm.days[0].shifts[0].volunteers.size());
        System.assertEquals('j', cdvm.days[0].shifts[0].volunteers[0].firstInitial);
    }
    
    @IsTest
    private static void testGetCalendarData() {
        VolunteerShiftCalendarService.instance = new VolunteerShiftCalendarServiceStub();
        
        CalendarDataViewModel cdvm = VolunteerShiftCalendarController.getCalendarData('2020-10-05', '2020-10-06');
        System.assertEquals(1, cdvm.days.size());
        System.assertEquals(1, cdvm.days[0].shifts.size());
        System.assertEquals(1, cdvm.days[0].shifts[0].volunteers.size());
        System.assertEquals('j', cdvm.days[0].shifts[0].volunteers[0].firstInitial);
    }
    
    @IsTest
    private static void testGetCalendarFromDates() {
        VolunteerShiftCalendarService.instance = new VolunteerShiftCalendarServiceStub();
        
        CalendarDataViewModel cdvm = VolunteerShiftCalendarController.getCalendarFromDates(Date.today(), Date.today());
        System.assertEquals(1, cdvm.days.size());
        System.assertEquals(1, cdvm.days[0].shifts.size());
        System.assertEquals(1, cdvm.days[0].shifts[0].volunteers.size());
        System.assertEquals('j', cdvm.days[0].shifts[0].volunteers[0].firstInitial);
    }
    
    private class VolunteerShiftCalendarServiceStub extends VolunteerShiftCalendarService {
        public override CalendarDataViewModel getCalendarFromDates(Date startDate, Date endDate) {
            CalendarDataViewModel cdvm = new CalendarDataViewModel();
            cdvm.nextStartDate = Date.today().addDays(1);
            cdvm.nextEndDate = Date.today().addDays(2);
            
            CalendarRowViewModel crvm = new CalendarRowViewModel('day');
            
            CalendarShiftViewModel csvm = new CalendarShiftViewModel();
            
            CalendarVolunteerViewModel cvvm = new CalendarVolunteerViewModel();
            cvvm.firstInitial = 'j';
            cvvm.lastName = 'schultz';
            
            csvm.volunteers.add(cvvm);
            crvm.shifts.add(csvm);
            cdvm.days.add(crvm);
            
            return cdvm;
        }
    }
}