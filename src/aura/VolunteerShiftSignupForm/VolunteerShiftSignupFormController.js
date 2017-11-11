({
    
    choseVolunteer : function(component, event, helper) {
        helper.resetVolunteerSearch(component);
        helper.choseVolunteer(component, event.target.dataset.idx);
    },
    
    closeModal : function(component, event, helper) {
        helper.closeModal(component);
    },
    
    handleShiftToggle : function(component, event, helper) {
        helper.parseShiftToggle(component, event);
    },
    
    handleSignUpClick : function(component, event, helper) {
        helper.signUp(component);
    },
    
    nameInputChange : function(component, event, helper) {
        helper.handleNameSearchChange(component);
    },
    
    removeChosenVolunteer : function(component, event, helper) {
        helper.resetChosenVolunteer(component);
    },
    
})