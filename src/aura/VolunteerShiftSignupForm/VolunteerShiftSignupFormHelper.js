({
    
    choseVolunteer : function(component, idx) {
        var volunteers = component.get('v.volunteerResults');
        var chosenVolunteer = volunteers[idx];
        component.set('v.chosenVolunteer', chosenVolunteer);
        component.find('nameInput').set('v.value', '');
    },
    
    displayNoVolunteerResults : function(component) {
        component.set('v.volunteerResults', '');
        component.set('v.showVolunteersPicklist', false);
        component.set('v.showNoVolunteers', true);
    },
    
    doNameSearch : function(component) {
        var action = component.get('c.searchContacts');
        var nameInput = component.find('nameInput').get('v.value');
        nameInput = nameInput ? nameInput.trim() : '';
        
        this.resetChosenVolunteer(component);
        this.resetVolunteerSearch(component);
        
        if (!nameInput.length) {
            component.set('v.volunteerResults', '');
            return;
        }
        
        if (nameInput.length < 3) {
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
    
    findShiftInList : function(component, shiftId) {
        var selectedShifts = component.get('v.selectedShifts');
        var index = -1;
        
        if (selectedShifts && selectedShifts.length) {
            for (var i = 0; i < selectedShifts.length; i++) {
                if (shiftId === selectedShifts[i].shiftId) {
                    index = i;
                    break;
                }
            }
        }
        
        return index;
    },
    
    handleNameSearchChange : function(component) {
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
    
    parseShiftToggle : function(component, event) {
        var shift = event.getParams();
        var selectedShifts = component.get('v.selectedShifts');
        var shiftIndex = this.findShiftInList(component, shift.shiftId);
        
        if (shift.selected && shiftIndex === -1) {
            // add to selectedShifts list
            selectedShifts.push(shift);
        }
        else if (!shift.selected && shiftIndex > -1) {
            selectedShifts.splice(shiftIndex, 1);
        }
    
        component.set('v.selectedShifts', selectedShifts);
    },
    
    resetChosenVolunteer : function(component) {
        component.set('v.chosenVolunteer', '');
        component.set('v.selectedShifts', []);
    },
    
    resetVolunteerSearch : function(component) {
        component.set('v.showVolunteersPicklist', false);
        component.set('v.showNoVolunteers', false);
    },
    
    signUp : function(component) {
        var shifts = component.get('v.selectedShifts');
        var volunteer = component.get('v.chosenVolunteer');
        var action = component.get('c.signUpContactForShifts');
        var isSubmitting = component.get('v.isSubmitting');
        var shiftIds = [];
        
        if (isSubmitting) {
            return;
        }
        
        component.set('v.signupError', '');
        
        for (var i = 0; i < shifts.length; i++) {
            shiftIds.push(shifts[i].shiftId);
        }
    
        action.setParams({
            'contactId' : volunteer.Id,
            'shiftIds' : shiftIds
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            if ('SUCCESS' === state) {
                component.set('v.showForm', false);
                component.set('v.didSuccessfullySave', true);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                component.set('v.showError', true);
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.errorHeading', 'There was an error saving your volunteer shift selection. Please try again.');
                        component.set('v.errorMsg', errors[0].message);
                    }
                }
                
                console.error('error signing up', errors);
            }
        });
    
        component.set('v.isSubmitting', true);
        component.set('v.showError', false);
        component.set('v.didSuccessfullySave', false);
    
        $A.enqueueAction(action);
    },
    
})