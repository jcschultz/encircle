@IsTest
private class TrainingService_TEST {

    static testMethod void testUpcomingTrainings() {
        Volunteer_Training__c training1 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(1)
        );
        Volunteer_Training__c training2 = new Volunteer_Training__c(
            StartDateTime__c = Datetime.now().addDays(-1)
        );
        insert new List<Volunteer_Training__c>{training1, training2};
    
        Test.startTest();
    
        List<TrainingModel> trainings = TrainingService.getUpcomingTrainings();
        System.assertEquals(1, trainings.size());
        System.assertEquals(training1.Id, trainings[0].id);
    
        Test.stopTest();
    }
}