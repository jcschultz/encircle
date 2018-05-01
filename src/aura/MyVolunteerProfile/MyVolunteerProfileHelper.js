({
    
    chooseVolunteer : function(cmp, chosenVolunteer) {
        cmp.set('v.chosenVolunteer', chosenVolunteer);
        
        if (chosenVolunteer) {
            this.loadUpcomingShifts(cmp);
        }
    },
    
    deleteShift : function(cmp, hourId) {
        var action = cmp.get('c.deleteShift');
        var volunteerId = cmp.get('v.chosenVolunteer');
        
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'contactId' : volunteerId,
            'hourId' : hourId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if ('SUCCESS' === state) {
                this.upcomingShiftsCallback(cmp, response.getReturnValue());
            }
            
            cmp.set('v.showSpinner', false);
        });
        
        $A.enqueueAction(action);
    },
    
    handleShiftRowEvent : function(cmp, event) {
        var actionType = event.getParam('action');
        
        if ('DELETE' === actionType) {
            this.deleteShift(cmp, event.getParam('hourId'));
        }
    },
    
    handleVolunteerRecordFinderEvent : function(cmp, event) {
        var eventType = event.getParam('eventType');
        var volunteerId = event.getParam('volunteerId');
        
        if ('VOLUNTEER_VERIFIED' === eventType) {
            // store chosen volunteer
            this.chooseVolunteer(cmp, event.getParam('volunteerId'));
        }
        else if ('SEARCHING' === eventType) {
            this.resetChosenVolunteer(cmp);
        }
    },
    
    loadUpcomingShifts : function(cmp) {
        var volunteerId = cmp.get('v.chosenVolunteer');
        var action = cmp.get('c.getUpcomingShifts');
        
        if (!volunteerId) {
            return;
        }
        
        cmp.set('v.noUpcomingShifts', false);
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'contactId' : volunteerId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if ('SUCCESS' === state) {
                this.upcomingShiftsCallback(cmp, response.getReturnValue());
            }
            
            cmp.set('v.showSpinner', false);
        });
        
        $A.enqueueAction(action);
    },
    
    resetChosenVolunteer : function(cmp) {
        cmp.set('v.chosenVolunteer', '');
        cmp.set('v.upcomingShifts', []);
        cmp.set('v.noUpcomingShifts', false);
    },
    
    upcomingShiftsCallback : function(cmp, data) {
        var upcomingShifts = data;
        cmp.set('v.upcomingShifts', upcomingShifts);
        
        if (!upcomingShifts || upcomingShifts.length < 1) {
            cmp.set('v.noUpcomingShifts', true);
        }
    },
    
});