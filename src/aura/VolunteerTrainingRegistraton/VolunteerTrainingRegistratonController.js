({
    
    doInit : function(cmp, event, helper) {
        helper.loadTrainingViewModel(cmp);
    },
    
    handleRegisterClick : function(cmp, event, helper) {
        helper.register(cmp, event.getSource().get('v.value'));
    },
    
    handleUnregisterClick : function(cmp, event, helper) {
        helper.unregister(cmp, event.getSource().get('v.value'));
    },
    
    handleVolunteerIdChange : function(cmp, event, helper) {
        helper.loadTrainingViewModel(cmp);
    },
    
});