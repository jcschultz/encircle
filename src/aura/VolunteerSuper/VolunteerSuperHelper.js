({
    
    checkSession : function(cmp) {
        let volunteerId = window.sessionStorage.getItem('volunteerId');
        
        if (volunteerId) {
            cmp.set('v.volunteerId', volunteerId);
        }
        
        this.toggleVisibility(cmp);
    },
    
    goHome : function(cmp) {
        if (cmp.get('v.volunteerId')) {
            this.goToPage('/volunteers/s/my-volunteer-profile');
        } else {
            this.goToPage('/');
        }
    },
    
    goToPage : function(url) {
        let navEvent = $A.get('e.force:navigateToURL');
    
        navEvent.setParams({
            'url' : url
        });
    
        navEvent.fire();
    },
    
    handleVolunteerRecordFinderEvent : function(cmp, event) {
        const eventType = event.getParam('eventType');
        const volunteerId = event.getParam('volunteerId');
        
        if ('VOLUNTEER_VERIFIED' === eventType) {
            cmp.set('v.volunteerId', volunteerId);
            window.sessionStorage.setItem('volunteerId', volunteerId);
        }
        else if ('SEARCHING' === eventType) {
            cmp.set('v.volunteeerId', '');
            window.sessionStorage.removeItem('volunteerId');
        }
        
        this.toggleVisibility(cmp);
    },
    
    logOut : function(cmp) {
        window.sessionStorage.removeItem('volunteerId');
        this.goToPage('/');
    },
    
    toggleVisibility : function(cmp) {
        if (cmp.get('v.requireAuthentication') && !cmp.get('v.volunteerId')) {
            cmp.set('v.showRecordFinder', true);
            cmp.set('v.showBody', false);
        } else {
            cmp.set('v.showRecordFinder', false);
            cmp.set('v.showBody', true);
        }
    },
    
});