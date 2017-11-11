/**
 * @description Service layer for Door Activity object.
 *
 * @author John Schultz
 * @date 2017-11-11
 */
public class DoorActivityService {
    
    /**
     * @description Saves a new or udpates an existing door activity record based
     * on date and visitor type. if a record exists, the corresponding hour field
     * is incremented.
     *
     * @param activityDate
     * @param hour (0-23)
     * @param visitorType
     *
     * @return door activity record
     */
    public static Door_Activity__c saveDoorActivity(Date activityDate, String hour, String visitorType) {
        String hourField;
        Decimal hourSum = 1;
        String queryString;
        Door_Activity__c doorActivity;
        
        doorActivity = new Door_Activity__c(
            Date__c = activityDate,
            Visitor_Type__c = visitorType
        );
        
        // we're using a separate field for each hour of the day. using the hour
        // string, we'll query the field by dynamically creating the field name.
        hourField = 'X' + hour + '__c';
        
        queryString = 'SELECT ' +
            'Id, ' +
            hourField + ' ' +
            'FROM Door_Activity__c ' +
            'WHERE Date__c = :activityDate ' +
            'AND Visitor_Type__c = :visitorType ' +
            'LIMIT 1';
        
        // check for a previous activity record with this date and visitor type.
        for (Door_Activity__c da : Database.query(queryString)) {
            doorActivity.Id = da.Id;
            hourSum = (Decimal)da.get(hourField) + 1;
        }
        
        // dynamically update the hour field with the sum for that hour
        doorActivity.put(hourField, hourSum);
        
        upsert doorActivity;
        
        return doorActivity;
    }
}