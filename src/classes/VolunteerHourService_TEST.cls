@IsTest
private class VolunteerHourService_TEST {
    
    @IsTest
    private static void testGetHours() {
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerHourService service = VolunteerHourService.getInstance();
        
        List<VolunteerHoursViewModel> hours = service.getUpcomingHoursByVolunteerId('003000000000001');
        System.assertNotEquals(null, hours);
    }
    
    @IsTest
    private static void testDelete() {
        VolunteerHourMapper.instance = new VolunteerHourMapperStub();
        VolunteerHourService service = VolunteerHourService.getInstance();
    
        List<VolunteerHoursViewModel> hours = service.deleteHours('003000000000001', new List<Id>{'a0VW00000000001'});
        System.assertNotEquals(null, hours);
    }
    
    @IsTest
    private static void testDeleteHours() {
    
    }
    
    private class VolunteerHourMapperStub extends VolunteerHourMapper {
        
        public override List<VolunteerHoursViewModel> getHoursByVolunteerIdsAndDate(Id[] volunteerIds, Date startDate, Date endDate) {
            return new List<VolunteerHoursViewModel>();
        }
        
        public override void deleteHours(Id[] ids) {}
    }

}