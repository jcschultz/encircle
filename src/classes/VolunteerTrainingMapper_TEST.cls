@IsTest
private class VolunteerTrainingMapper_TEST {
    
    @IsTest
    private static void testQueries() {
        Volunteer_Training__c t1 = new Volunteer_Training__c(
            Description__c = 'testing',
            Location__c = 'my location',
            StartDateTime__c = Datetime.now().addDays(1),
            EndDateTime__c = Datetime.now().addDays(1).addMinutes(30)
        );
    
        Volunteer_Training__c t2 = new Volunteer_Training__c(
            Description__c = 'testing 2',
            Location__c = 'other location',
            StartDateTime__c = Datetime.now().addDays(1).addHours(1),
            EndDateTime__c = Datetime.now().addDays(1).addHours(1).addMinutes(30)
        );
    
        Volunteer_Training__c t3 = new Volunteer_Training__c(
            Description__c = 'testing old',
            Location__c = 'my location',
            StartDateTime__c = Datetime.now().addDays(-1),
            EndDateTime__c = Datetime.now().addDays(-1).addMinutes(30)
        );
        
        insert new List<Volunteer_Training__c>{t1, t2, t3};
        
        VolunteerTrainingMapper mapper = VolunteerTrainingMapper.getInstance();
        
        List<VolunteerTrainingViewModel> test1 = mapper.getUpcomingTrainings();
        System.assertEquals(2, test1.size());
        System.assertEquals(t1.Description__c, test1[0].description);
        
        List<VolunteerTrainingViewModel> test2 = mapper.getUpcomingTrainingsByLocation(t1.Location__c);
        System.assertEquals(1, test2.size());
    }

}