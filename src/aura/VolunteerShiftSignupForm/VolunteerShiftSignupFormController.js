({
    
    handleShiftToggle : function(cmp, event, helper) {
        helper.parseShiftToggle(cmp, event);
    },
    
    handleSignUpClick : function(cmp, event, helper) {
        helper.signUp(cmp);
    },
    
    handleTypeAheadEvent : function(cmp, event, helper) {
        helper.handleTypeAheadEvent(cmp, event);
    },
    
    
})