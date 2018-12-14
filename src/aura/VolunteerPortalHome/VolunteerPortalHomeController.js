({
    
    handleInit : function(cmp, event, helper) {
        helper.checkForSignedIn(cmp);
    },
    
    handleRegistrationClick : function(cmp, event, helper) {
        helper.goToPage('/volunteers/s/volunteer-registration');
    },
    
    handleSignInClick : function(cmp, event, helper) {
        helper.goToPage('/volunteers/s/my-volunteer-profile');
    },
    
});