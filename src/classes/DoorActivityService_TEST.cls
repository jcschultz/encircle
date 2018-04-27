@IsTest
private class DoorActivityService_TEST {
    
    private static List<String> visitorTypes = new List<String>();
    private static Date today;
    private static String hourString;
    
    static {
        Schema.DescribeFieldResult fieldResult = Door_Activity__c.Visitor_Type__c.getDescribe();
    
        for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
            visitorTypes.add(ple.getValue());
        }
        
        today = Date.today();
        hourString = '3';
    }
    

    static testMethod void testSaveActivity() {
        DoorActivityService daService = DoorActivityService.getInstance();
        Test.startTest();
        
        // create new activity for 1st visitor type.
        daService.saveDoorActivity(today, hourString, visitorTypes[0]);
        // should only be 1 door activity. and only 1 event for that hour.
        List<Door_Activity__c> activities = new List<Door_Activity__c>([SELECT Id, X3__c FROM Door_Activity__c]);
        System.assertEquals(1, activities.size());
        System.assertEquals(1, activities[0].X3__c);
        
        // another visitor of the same type, same hour.
        daService.saveDoorActivity(today, hourString, visitorTypes[0]);
        // should still only be 1 activity but the hour should now be 2
        activities = new List<Door_Activity__c>([SELECT Id, X3__c FROM Door_Activity__c]);
        System.assertEquals(1, activities.size());
        System.assertEquals(2, activities[0].X3__c);
        
        // another visitor of a different type but same hour.
        daService.saveDoorActivity(today, hourString, visitorTypes[1]);
        // should now be 2 records
        activities = new List<Door_Activity__c>([SELECT Id, X3__c FROM Door_Activity__c]);
        System.assertEquals(2, activities.size());
        
        Test.stopTest();
    }

}