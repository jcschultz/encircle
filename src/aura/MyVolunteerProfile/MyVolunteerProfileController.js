({
    doInit : function(cmp, event, helper) {
        helper.loadVolunteerDetails(cmp);
    },
    
    handleShiftRowEvent : function(cmp, event, helper) {
        helper.handleShiftRowEvent(cmp, event);
    },
    
    handleSignUpClick : function(cmp, event, helper) {
        helper.goToShiftSignUpPage();
    },
    
    handleVolunteerIdChange : function(cmp, event, helper) {
        helper.loadVolunteerDetails(cmp);
    },
    
});