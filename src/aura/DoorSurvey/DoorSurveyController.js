({
    
    cancelVolunteerSignIn : function(cmp, event, helper) {
        helper.resetApp(cmp);
    },
    
    changeVolunteerClick : function(cmp, event, helper) {
        helper.resetChosenVolunteer(cmp);
    },
    
    doInit : function(cmp, event, helper) {
        helper.getVisitorTypes(cmp);
    },
    
    handleActivityClick : function(cmp, event, helper) {
        helper.handleActivityClick(cmp, event);
    },
    
    handleShiftSearchClick : function(cmp, event, helper) {
        helper.findAvailableShifts(cmp);
    },
    
    handleTypeAheadEvent : function(cmp, event, helper) {
        helper.handleTypeAheadEvent(cmp, event);
    },
    
    signUpAndSignIn : function(cmp, event, helper) {
        helper.signUpAndSignIn(cmp);
    },
    
    signUpForOtherHours : function(cmp, event, helper) {
        helper.signUpForOtherHours(cmp);
    },
    
    switchToOtherHours : function(cmp, event, helper) {
        helper.switchToOtherHours(cmp);
    },
    
    toggleShift : function(cmp, event, helper) {
        helper.toggleShift(cmp, event.target.dataset.idx);
    },
    
    volunteerSignIn : function(cmp, event, helper) {
        helper.doVolunteerSignIn(cmp);
    },
    
})