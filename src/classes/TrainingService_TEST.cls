@IsTest
private class TrainingService_TEST {
    
    static testMethod void testUpcomingTrainings() {
        Volunteer_Training__c training1 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(1),
            Location__c = 'here'
        );
        Volunteer_Training__c training2 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(-1)
        );
        insert new List<Volunteer_Training__c>{training1, training2};
    
        Test.startTest();
    
        List<TrainingModel> trainings = TrainingService.getUpcomingTrainings();
        System.assertEquals(1, trainings.size());
        System.assertEquals(training1.Id, trainings[0].id);
        System.assert(trainings[0].detailedName.contains('here'));
    
        List<Volunteer_Training__c> byId = TrainingService.getTrainingsById(new Set<String>{training2.Id});
        System.assertEquals(1, byId.size());
        System.assertEquals(training2.StartDateTime__c, byId[0].StartDateTime__c);
    
        Test.stopTest();
    }
}