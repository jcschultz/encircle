({
    
    chooseVolunteer : function(cmp, chosenVolunteer) {
        cmp.set('v.chosenVolunteer', chosenVolunteer);
        cmp.set('v.showSearchQuestion', (!chosenVolunteer.shifts || chosenVolunteer.shifts.length < 1));
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
    
    doVolunteerSignIn : function(cmp) {
        var action = cmp.get('c.signVolunteerInToHours');
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        var hourIds = [];
        
        if (chosenVolunteer.shifts.length) {
            for (var i = 0; i < chosenVolunteer.shifts.length; i++) {
                hourIds.push(chosenVolunteer.shifts[i].id);
            }
        }
    
        action.setParams({
            'hourIds' : hourIds
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error signing you in.');
                }
                console.error('error signing in volunteer', response);
            }
        });
        
        this.showSpinner(cmp);
    
        $A.enqueueAction(action);
    },
    
    findAvailableShifts : function(cmp) {
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        var action = cmp.get('c.findAvailableShifts');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                var shifts = response.getReturnValue();
                cmp.set('v.showSearchQuestion', false);
                
                if (shifts && shifts.length) {
                    cmp.set('v.availableShifts', shifts);
                    cmp.set('v.showShiftSelection', true);
                }
                else {
                    cmp.set('v.showNoShiftsAvailable', true);
                    cmp.set('v.showOtherSignIn', true);
                }
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error finding available shifts.');
                }
                console.error('error finding shifts', response);
            }
        });
        
        this.showSpinner(cmp);
        cmp.set('v.showNoShiftsAvailable', false);
        cmp.set('v.showShiftSelection', false);
        cmp.set('v.showOtherSignIn', false);
    
        $A.enqueueAction(action);
    },
    
    fireActionEvent : function(cmp, actionType, msg) {
        var evt = cmp.getEvent('dsActionEvent');
        
        evt.setParams({
            'action' : actionType,
            'message' : msg
        });
        
        evt.fire();
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
    
    hideSpinner : function(cmp) {
        this.fireActionEvent(cmp, 'TOGGLE_SPINNER', 'HIDE');
    },
    
    resetApp : function(cmp) {
        this.resetChosenVolunteer(cmp);
        this.fireActionEvent(cmp, 'RESET_APP', '');
    },
    
    resetChosenVolunteer : function(cmp) {
        cmp.set('v.chosenVolunteer', '');
        this.resetShiftSearch(cmp);
    },
    
    resetShiftSearch : function(cmp) {
        cmp.set('v.showSearchQuestion', false);
        cmp.set('v.showNoShiftsAvailable', false);
        cmp.set('v.showShiftSelection', false);
        cmp.set('v.showOtherSignIn', false);
        cmp.set('v.otherHours', 1);
        cmp.set('v.availableShifts', '');
    },
    
    showSpinner : function(cmp) {
        this.fireActionEvent(cmp, 'TOGGLE_SPINNER', 'SHOW');
    },
    
    showToast : function(cmp, severity, title, message) {
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    },
    
    signUpAndSignIn : function(cmp) {
        var availableShifts = cmp.get('v.availableShifts');
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        var shiftIds = [];
        var action = cmp.get('c.signVolunteerUpForShifts');
        
        for (var i = 0; i < availableShifts.length; i++) {
            if (availableShifts[i].selected) {
                shiftIds.push(availableShifts[i].id);
            }
        }
        
        action.setParams({
            'contactId' : chosenVolunteer.contactId,
            'shiftIds' : shiftIds
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error signing you up for the selected shifts.');
                }
                console.error('error signing up for shifts', response);
            }
        });
        
        this.showSpinner(cmp);
    
        $A.enqueueAction(action);
    },
    
    signUpForOtherHours : function(cmp) {
        var chosenVolunteer = cmp.get('v.chosenVolunteer');
        var hours = cmp.get('v.otherHours');
        var action = cmp.get('c.signVolunteerInForUnplannedShift');
    
        action.setParams({
            'contactId' : chosenVolunteer.contactId,
            'hours' : hours
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error signing you up for the other shift.');
                }
                console.error('error signing up for unplanned', response);
            }
        });
    
        this.showSpinner(cmp);
    
        $A.enqueueAction(action);
    },
    
    switchToOtherHours : function(cmp) {
        cmp.set('v.selectedShiftsCount', 0);
        cmp.set('v.availableShifts', '');
        cmp.set('v.showShiftSelection', false);
        cmp.set('v.showOtherSignIn', true);
    },
    
    toggleShift : function(cmp, idx) {
        var availableShifts = cmp.get('v.availableShifts');
        var selectedShiftsCount = cmp.get('v.selectedShiftsCount');
        
        availableShifts[idx].selected = !availableShifts[idx].selected;
        
        if (availableShifts[idx].selected) {
            selectedShiftsCount++;
        }
        else {
            selectedShiftsCount--;
        }
        
        cmp.set('v.availableShifts', availableShifts);
        cmp.set('v.selectedShiftsCount', selectedShiftsCount);
    },
    
});