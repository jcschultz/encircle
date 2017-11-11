({
    
    choseVolunteer : function(component, idx) {
        var volunteers = component.get('v.volunteerResults');
        var chosenVolunteer = volunteers[idx];
        component.set('v.chosenVolunteer', chosenVolunteer);
        component.find('nameInput').set('v.value', '');
    },
    
    closeModal : function(component) {
        component.set('v.showModal', false);
        component.set('v.modalType', '');
        component.set('v.modalError', '');
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
        var shiftIds = [];
        
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
    
            component.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                console.log('hours', response.getReturnValue());
                component.set('v.modalType', 'SUCCESS');
                component.set('v.showModal', true);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    component.set('v.modalType', 'ERROR');
                    component.set('v.modalError', 'There was an error saving your volunteer shift selection. Please try again.');
                    component.set('v.showModal', true);
                }
                
                console.error('error signing up', errors);
            }
        });
        
        component.set('v.showSpinner', true);
    
        $A.enqueueAction(action);
    },
    
})