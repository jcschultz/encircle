trigger VolunteerTrainingTrigger on Volunteer_Training__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {

    
    new VolunteerTrainingTriggerHandler().run();
}