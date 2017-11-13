({
    TRAINED_VOLUNTEER : 'Trained Volunteer',
    
    chooseVolunteer : function(component, idx) {
        var volunteers = component.get('v.volunteerResults');
        var chosenVolunteer = volunteers[idx];
        component.set('v.chosenVolunteer', chosenVolunteer);
        component.set('v.nameInput', '');
        component.set('v.showSearchQuestion', (!chosenVolunteer.shifts || chosenVolunteer.shifts.length < 1));
    },
    
    doNameSearch : function(component) {
        var action = component.get('c.searchContacts');
        var nameInput = component.get('v.nameInput');
        nameInput = nameInput ? nameInput.trim() : '';
    
        this.resetChosenVolunteer(component);
        this.resetVolunteerSearch(component);
    
        if (!nameInput.length) {
            component.set('v.volunteerResults', '');
            return;
        }
    
        action.setParams({
            'nameInput' : nameInput
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                var results = response.getReturnValue();
            
                if (results && results.length) {
                    component.set('v.volunteerResults', results);
                    component.set('v.showVolunteersPicklist', true);
                }
                else {
                    this.displayNoVolunteerResults(component);
                }
            }
            else if ('ERROR' === state) {
                this.displayNoVolunteerResults(component);
                console.error('error searching volunteers', response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    doVolunteerSignIn : function(component) {
        var action = component.get('c.signVolunteerInToHours');
        var chosenVolunteer = component.get('v.chosenVolunteer');
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
    
            component.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                this.showToast(component, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(component);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(component, 'error', 'Error', 'There was an error signing you in.');
                }
                console.error('error signing in volunteer', response);
            }
        });
        
        component.set('v.showSpinner', true);
    
        $A.enqueueAction(action);
    },
    
    displayNoVolunteerResults : function(component) {
        component.set('v.volunteerResults', '');
        component.set('v.showVolunteersPicklist', false);
        component.set('v.showNoVolunteers', true);
        this.resetShiftSearch(component);
    },
    
    findAvailableShifts : function(component) {
        var chosenVolunteer = component.get('v.chosenVolunteer');
        var action = component.get('c.findAvailableShifts');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            component.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                var shifts = response.getReturnValue();
                component.set('v.showSearchQuestion', false);
                
                if (shifts && shifts.length) {
                    component.set('v.availableShifts', shifts);
                    component.set('v.showShiftSelection', true);
                }
                else {
                    component.set('v.showNoShiftsAvailable', true);
                }
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(component, 'error', 'Error', 'There was an error finding available shifts.');
                }
                console.error('error finding shifts', response);
            }
        });
        
        component.set('v.showSpinner', true);
        component.set('v.showNoShiftsAvailable', false);
        component.set('v.showShiftSelection', false);
    
        $A.enqueueAction(action);
    },
    
    getVisitorTypes : function(component) {
        var action = component.get('c.getVisitorTypes');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                component.set('v.visitorTypes', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error retrieving visitor types', error.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    handleActivityClick : function(component, event) {
        var label = event.getSource().get('v.label');
        var action = component.get('c.saveActivity');
        var now = new Date();
        var activityDate = now.getFullYear() + '-' + (now.getMonth()+1) + '-' + now.getDate();
        var hour = now.getHours().toString();
    
        action.setParams({
            'visitorType' : label,
            'activityDate' : activityDate,
            'hour' : hour
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            component.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                if (label !== this.TRAINED_VOLUNTEER) {
                    this.showToast(component, 'success', 'Thanks!', 'Your visit has been recorded. Thanks for visiting us today.');
                }
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    this.showToast(component, 'error', 'Error', 'There was an error recording your visit.');
                }
                console.error('error saving visitor', response);
            }
        });
        
        if (label === this.TRAINED_VOLUNTEER) {
            this.switchToVolunteerView(component);
        }
        else {
            component.set('v.showSpinner', true);
        }
    
        $A.enqueueAction(action);
    },
    
    handleVolunteerInputChange : function(component) {
        var delay = 400;
        var timer = component.get('v.timer');
        var that = this;
    
        clearTimeout(timer);
    
        timer = window.setTimeout(
            $A.getCallback(function(){
                that.doNameSearch(component);
            }),
            delay
        );
    
        component.set('v.timer', timer);
    },
    
    resetApp : function(component) {
        component.set('v.step', 'welcome');
        this.resetChosenVolunteer(component);
        this.resetVolunteerSearch(component);
    },
    
    resetChosenVolunteer : function(component) {
        component.set('v.chosenVolunteer', '');
        this.resetShiftSearch(component);
    },
    
    resetShiftSearch : function(component) {
        component.set('v.showSearchQuestion', false);
        component.set('v.showNoShiftsAvailable', false);
        component.set('v.showShiftSelection', false);
    },
    
    resetVolunteerSearch : function(component) {
        component.set('v.showVolunteersPicklist', false);
        component.set('v.showNoVolunteers', false);
        this.resetShiftSearch(component);
    },
    
    showToast : function(component, severity, title, message) {
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    },
    
    signUpAndSignIn : function(component) {
        var availableShifts = component.get('v.availableShifts');
        var chosenVolunteer = component.get('v.chosenVolunteer');
        var shiftIds = [];
        var action = component.get('c.signVolunteerUpForShifts');
        
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
            
            component.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                this.showToast(component, 'success', 'Thanks!', 'You are now signed in for your shifts. Thanks for volunteering today.');
                this.resetApp(component);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                if (errors && errors[0]) {
                    this.showToast(component, 'error', 'Error', 'There was an error signing you up for the selected shifts.');
                }
                console.error('error signing up for shifts', response);
            }
        });
        
        component.set('v.showSpinner', true);
    
        $A.enqueueAction(action);
    },
    
    switchToVolunteerView : function(component) {
        component.set('v.step', 'volunteer');
    },
    
    toggleShift : function(component, idx) {
        var availableShifts = component.get('v.availableShifts');
        var selectedShiftsCount = component.get('v.selectedShiftsCount');
        
        availableShifts[idx].selected = !availableShifts[idx].selected;
        
        if (availableShifts[idx].selected) {
            selectedShiftsCount++;
        }
        else {
            selectedShiftsCount--;
        }
        
        component.set('v.availableShifts', availableShifts);
        component.set('v.selectedShiftsCount', selectedShiftsCount);
    },
    
})