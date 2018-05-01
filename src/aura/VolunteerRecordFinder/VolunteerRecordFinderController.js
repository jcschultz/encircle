({
    
    handleCancelClick : function(cmp, event, helper) {
        helper.handleCancelClick(cmp);
    },
    
    handleSearchClick : function(cmp, event, helper) {
        helper.resetFinder(cmp);
        helper.fireSearchNotification(cmp);
        helper.searchForVolunteer(cmp);
    },
    
    handleVerifyClick : function(cmp, event, helper) {
        helper.handleVerifyClick(cmp);
    },
    
    handleVolunteerRecordFinderEvent : function(cmp, event, helper) {
        helper.handleVolunteerRecordFinderEvent(cmp, event);
    },
    
});