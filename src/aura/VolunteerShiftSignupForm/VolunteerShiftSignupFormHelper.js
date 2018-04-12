({
    
    choseVolunteer : function(cmp, chosenVolunteer) {
        cmp.set('v.chosenVolunteer', chosenVolunteer);
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
    
    findShiftInList : function(cmp, shiftId) {
        var selectedShifts = cmp.get('v.selectedShifts');
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
    
    handleTypeAheadEvent : function(cmp, event) {
        var actionType = event.getParam('action');
        
        if ('USER_INPUT' === actionType) {
            // do search and return results to typeahead.
            this.doNameSearch(cmp, event.getParam('userInput'));
        }
        else if ('SELECTION' === actionType) {
            // store chosen volunteer
            this.choseVolunteer(cmp, event.getParam('selectedObject'));
        }
    },
    
    parseShiftToggle : function(cmp, event) {
        var shift = event.getParams();
        var selectedShifts = cmp.get('v.selectedShifts');
        var shiftIndex = this.findShiftInList(cmp, shift.shiftId);
        
        if (shift.selected && shiftIndex === -1) {
            // add to selectedShifts list
            selectedShifts.push(shift);
        }
        else if (!shift.selected && shiftIndex > -1) {
            selectedShifts.splice(shiftIndex, 1);
        }
    
        cmp.set('v.selectedShifts', selectedShifts);
    },
    
    resetChosenVolunteer : function(cmp) {
        cmp.set('v.chosenVolunteer', '');
        cmp.set('v.selectedShifts', []);
    },
    
    signUp : function(cmp) {
        var shifts = cmp.get('v.selectedShifts');
        var volunteer = cmp.get('v.chosenVolunteer');
        var action = cmp.get('c.signUpContactForShifts');
        var isSubmitting = cmp.get('v.isSubmitting');
        var shiftIds = [];
        
        if (isSubmitting) {
            return;
        }
        
        cmp.set('v.signupError', '');
        
        for (var i = 0; i < shifts.length; i++) {
            shiftIds.push(shifts[i].shiftId);
        }
    
        action.setParams({
            'contactId' : volunteer.id,
            'shiftIds' : shiftIds
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            if ('SUCCESS' === state) {
                cmp.set('v.showForm', false);
                cmp.set('v.didSuccessfullySave', true);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
    
                cmp.set('v.showError', true);
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.errorHeading', 'There was an error saving your volunteer shift selection. Please try again.');
                        cmp.set('v.errorMsg', errors[0].message);
                    }
                }
                
                console.error('error signing up', errors);
            }
        });
    
        cmp.set('v.isSubmitting', true);
        cmp.set('v.showError', false);
        cmp.set('v.didSuccessfullySave', false);
    
        $A.enqueueAction(action);
    },
    
})