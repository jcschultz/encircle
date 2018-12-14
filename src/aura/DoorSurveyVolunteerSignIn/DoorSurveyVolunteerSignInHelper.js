({
    
    chooseVolunteer : function(cmp, volunteerId) {
        let action = cmp.get('c.loadVolunteerData');
    
        action.setParams({'volunteerId' : volunteerId});
    
        action.setCallback(this, function(response){
            let state = response.getState();
        
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                let volunteer = response.getReturnValue();
                cmp.set('v.chosenVolunteer', volunteer);
                cmp.set('v.showSearchQuestion', (!volunteer.shifts || volunteer.shifts.length < 1));
            } else if ('ERROR' === state) {
                let errors = response.getError();
            
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error loading your info.');
                }
                console.error('error loading volunteer', response);
            }
        });
    
        this.showSpinner(cmp);
        $A.enqueueAction(action);
    },
    
    doVolunteerSignIn : function(cmp) {
        let action = cmp.get('c.signVolunteerInToHours');
        let chosenVolunteer = cmp.get('v.chosenVolunteer');
        let hourIds = [];
    
        if (chosenVolunteer.shifts.length) {
            for (let i = 0; i < chosenVolunteer.shifts.length; i++) {
                hourIds.push(chosenVolunteer.shifts[i].id);
            }
        }
    
        action.setParams({
            'hourIds' : hourIds
        });
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                let errors = response.getError();
    
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
        let chosenVolunteer = cmp.get('v.chosenVolunteer');
        let action = cmp.get('c.findAvailableShifts');
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                let shifts = response.getReturnValue();
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
                let errors = response.getError();
    
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
        let evt = cmp.getEvent('dsActionEvent');
    
        evt.setParams({
            'action' : actionType,
            'message' : msg
        });
        
        evt.fire();
    },
    
    handleTypeAheadEvent : function(cmp, event) {
        let actionType = event.getParam('action');
        let volunteerId = event.getParam('selectedObject');
        
        if ('SELECTION' === actionType) {
            if (volunteerId) {
                // store chosen volunteer
                this.chooseVolunteer(cmp, volunteerId);
            } else {
                this.resetChosenVolunteer(cmp);
            }
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
        let toastEvent = $A.get('e.force:showToast');
    
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    },
    
    signUpAndSignIn : function(cmp) {
        let availableShifts = cmp.get('v.availableShifts');
        let chosenVolunteer = cmp.get('v.chosenVolunteer');
        let shiftIds = [];
        let action = cmp.get('c.signVolunteerUpForShifts');
    
        for (let i = 0; i < availableShifts.length; i++) {
            if (availableShifts[i].selected) {
                shiftIds.push(availableShifts[i].id);
            }
        }
        
        action.setParams({
            'volunteerId' : chosenVolunteer.id,
            'shiftIds' : shiftIds
        });
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                let errors = response.getError();
    
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
        let chosenVolunteer = cmp.get('v.chosenVolunteer');
        let hours = cmp.get('v.otherHours');
        let action = cmp.get('c.signVolunteerInForUnplannedShift');
    
        action.setParams({
            'volunteerId' : chosenVolunteer.id,
            'hours' : hours
        });
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            this.hideSpinner(cmp);
        
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in. Thanks for volunteering today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                let errors = response.getError();
    
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
        let availableShifts = cmp.get('v.availableShifts');
        let selectedShiftsCount = cmp.get('v.selectedShiftsCount');
    
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