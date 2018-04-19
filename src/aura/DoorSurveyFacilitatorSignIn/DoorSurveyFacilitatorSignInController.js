({
    cancelFacilitatorSignIn : function(cmp, event, helper) {
        helper.resetApp(cmp);
    },
    
    changeFacilitatorClick : function(cmp, event, helper) {
        helper.resetChosenFacilitator(cmp);
    },
    
    handleTypeAheadEvent : function(cmp, event, helper) {
        helper.handleTypeAheadEvent(cmp, event);
    },
    
    signIn : function(cmp, event, helper) {
        helper.signIn(cmp);
    },
    
    
});