({
    
    chooseVolunteer : function(cmp, chosenVolunteer) {
        cmp.set('v.chosenVolunteer', chosenVolunteer);
        
        if (chosenVolunteer) {
            this.loadUpcomingShifts(cmp);
        }
    },
    
    deleteShift : function(cmp, hourId) {
        var action = cmp.get('c.deleteShift');
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'contactId' : chosenVolunteer.id,
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
    
    doNameSearch : function(cmp, nameInput) {
        var action = cmp.get('c.searchContacts');
        
        this.resetChosenVolunteer(cmp);
        
        action.setParams({
            'nameInput' : nameInput
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                cmp.set('v.volunteerResults', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                cmp.set('v.volunteerResults', []);
                console.error('error searching volunteers', response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    handleShiftRowEvent : function(cmp, event) {
        var actionType = event.getParam('action');
        
        if ('DELETE' === actionType) {
            this.deleteShift(cmp, event.getParam('hourId'));
        }
    },
    
    handleTypeAheadEvent : function(cmp, event) {
        var actionType = event.getParam('action');
        
        if ('USER_INPUT' === actionType) {
            // do search and return results to typeahead.
            this.doNameSearch(cmp, event.getParam('userInput'));
        }
        else if ('SELECTION' === actionType) {
            // store chosen volunteer
            this.chooseVolunteer(cmp, event.getParam('selectedObject'));
        }
    },
    
    loadUpcomingShifts : function(cmp) {
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        var action = cmp.get('c.getUpcomingShifts');
        
        if (!chosenVolunteer) {
            return;
        }
        
        cmp.set('v.noUpcomingShifts', false);
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'contactId' : chosenVolunteer.id
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