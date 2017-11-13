({
    
    cancelVolunteerSignIn : function(component, event, helper) {
        helper.resetApp(component);
    },
    
    changeVolunteerClick : function(component, event, helper) {
        helper.resetChosenVolunteer(component);
    },
    
    chooseVolunteer : function(component, event, helper) {
        helper.resetVolunteerSearch(component);
        helper.chooseVolunteer(component, event.target.dataset.idx);
    },
    
    doInit : function(component, event, helper) {
        helper.getVisitorTypes(component);
    },
    
    handleActivityClick : function(component, event, helper) {
        helper.handleActivityClick(component, event);
    },
    
    handleShiftSearchClick : function(component, event, helper) {
        helper.findAvailableShifts(component);
    },
    
    handleVolunteerInputChange : function(component, event, helper) {
        helper.handleVolunteerInputChange(component);
    },
    
    signUpAndSignIn : function(component, event, helper) {
        helper.signUpAndSignIn(component);
    },
    
    toggleShift : function(component, event, helper) {
        helper.toggleShift(component, event.target.dataset.idx);
    },
    
    volunteerSignIn : function(component, event, helper) {
        helper.doVolunteerSignIn(component);
    },
    
})