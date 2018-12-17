({
    doInit : function(cmp, event, helper) {
        helper.loadVolunteerDetails(cmp);
    },
    
    handleShiftToggle : function(cmp, event, helper) {
        helper.parseShiftToggle(cmp, event);
    },
    
    handleSignUpClick : function(cmp, event, helper) {
        helper.signUp(cmp);
    },
    
    handleVolunteerIdChange : function(cmp, event, helper) {
        helper.loadVolunteerDetails(cmp);
    },
    
    
})