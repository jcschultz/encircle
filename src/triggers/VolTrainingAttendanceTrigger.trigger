trigger VolTrainingAttendanceTrigger on Volunteer_Training_Attendance__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {

    
    new VolTrainingAttendanceTriggerHandler().run();
}