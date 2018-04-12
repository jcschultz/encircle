({
    
    choseVolunteer : function(cmp, event, helper) {
        helper.choseVolunteer(cmp, event);
    },
    
    handleVolunteerResultsChange : function(cmp, event, helper) {
        helper.handleVolunteerResultsChange(cmp);
    },
    
    nameInputChange : function(cmp, event, helper) {
        helper.handleNameSearchChange(cmp);
    },
    
    removeChosenVolunteer : function(cmp, event, helper) {
        helper.resetChosenVolunteer(cmp);
    },
});