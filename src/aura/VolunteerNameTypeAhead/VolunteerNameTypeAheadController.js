({
    
    choseVolunteer : function(cmp, event, helper) {
        helper.choseVolunteer(cmp, event);
    },
    
    nameInputChange : function(cmp, event, helper) {
        helper.handleNameSearchChange(cmp);
    },
    
    removeChosenVolunteer : function(cmp, event, helper) {
        helper.resetChosenVolunteer(cmp);
        helper.clearNameInput(cmp);
    },
});