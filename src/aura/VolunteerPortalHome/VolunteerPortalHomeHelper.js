({
    
    checkForSignedIn : function(cmp) {
        if (cmp.get('v.volunteerId')) {
            this.goToPage('/volunteers/s/my-volunteer-profile');
        }
    },
    
    goToPage : function(url) {
        let navEvent = $A.get('e.force:navigateToURL');
    
        navEvent.setParams({
            'url' : url
        });
    
        navEvent.fire();
    },
    
});