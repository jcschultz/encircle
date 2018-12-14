({
    
    handleHomeClick : function(cmp, event, helper) {
        helper.goHome(cmp);
    },
    
    handleInit : function(cmp, event, helper) {
        helper.checkSession(cmp);
    },
    
    handleLogOutClick : function(cmp, event, helper) {
        helper.logOut(cmp);
    },
    
    handleVolunteerRecordFinderEvent : function(cmp, event, helper) {
        helper.handleVolunteerRecordFinderEvent(cmp, event);
    },
});