({
    
    doInit : function(cmp, event, helper) {
        helper.getVisitorTypes(cmp);
    },
    
    handleActivityClick : function(cmp, event, helper) {
        helper.handleActivityClick(cmp, event);
    },
    
    handleDoorSurveyActionEvent : function(cmp, event, helper) {
        helper.handleDoorSurveyActionEvent(cmp, event);
    },
    
});