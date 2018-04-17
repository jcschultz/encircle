@IsTest
private class DoorSurveyController_TEST {
    
    static testMethod void testVisitors() {
        Test.startTest();
        
        List<String> visitorTypes = DoorSurveyController.getVisitorTypes();
        System.assertNotEquals(0, visitorTypes.size());
        
        DoorSurveyController.saveActivity(visitorTypes[0], '2020-10-25', '3');
        List<Door_Activity__c> activities = new List<Door_Activity__c>([SELECT Id, X3__c FROM Door_Activity__c]);
        System.assertEquals(1, activities.size());
        System.assertEquals(1, activities[0].X3__c);
        
        Test.stopTest();
    }
    
}