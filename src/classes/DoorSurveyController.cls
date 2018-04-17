/**
 * @description Controller for the door survey component.
 *
 * @author John Schultz
 * @date 2017-11-11
 */
public without sharing class DoorSurveyController {
    
    /**
     * @description Retrieves the visitor types for the door survey.
     *
     * @return
     */
    @AuraEnabled
    public static List<String> getVisitorTypes() {
        List<String> visitorTypes = new List<String>();
    
        Schema.DescribeFieldResult fieldResult = Door_Activity__c.Visitor_Type__c.getDescribe();
    
        for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
            visitorTypes.add(ple.getValue());
        }
        
        return visitorTypes;
    }
    
    /**
     * @description Saves the door activity.
     *
     * @param visitorType
     * @param activityDate (YYYY-MM-DD)
     * @param hour (0 - 23)
     */
    @AuraEnabled
    public static void saveActivity(String visitorType, String activityDate, String hour) {
        DoorActivityService.saveDoorActivity(Date.valueOf(activityDate), hour, visitorType);
    }
    
}