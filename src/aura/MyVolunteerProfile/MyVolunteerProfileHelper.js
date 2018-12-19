({
    
    
    deleteShift : function(cmp, hourId) {
        const action = cmp.get('c.deleteShift');
        const volunteer = cmp.get('v.volunteer');
        
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'volunteerId' : volunteer.id,
            'hourId' : hourId
        });
        
        action.setCallback(this, function(response){
            const state = response.getState();
            
            if ('SUCCESS' === state) {
                volunteer.hours = response.getReturnValue();
                cmp.set('v.volunteer', volunteer);
            }
            
            cmp.set('v.showSpinner', false);
        });
        
        $A.enqueueAction(action);
    },
    
    handleShiftRowEvent : function(cmp, event) {
        const actionType = event.getParam('action');
        
        if ('DELETE' === actionType) {
            this.deleteShift(cmp, event.getParam('hourId'));
        }
    },
    
    goToShiftSignUpPage : function() {
        const navEvent = $A.get('e.force:navigateToURL');
    
        navEvent.setParams({
            'url' : '/volunteers/s/volunteer-shift-signup'
        });
    
        navEvent.fire();
    },
    
    loadVolunteerDetails : function(cmp) {
        const volunteerId = cmp.get('v.volunteerId');
        
        if (!volunteerId) {
            cmp.set('v.volunteer', '');
            return;
        }
        
        cmp.set('v.showSpinner', true);
        
        const action = cmp.get('c.loadVolunteerViewModel');
        
        action.setParams({
            'volunteerId' : volunteerId
        });
        
        action.setCallback(this, function(response){
            const state = response.getState();
            
            if ('SUCCESS' === state) {
                cmp.set('v.volunteer', response.getReturnValue());
            }
            
            cmp.set('v.showSpinner', false);
        });
        
        $A.enqueueAction(action);
    },
    
});