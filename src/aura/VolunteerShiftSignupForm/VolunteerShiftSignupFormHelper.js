({
    
    findShiftInList : function(cmp, shiftId) {
        let selectedShifts = cmp.get('v.selectedShifts');
        let index = -1;
        
        if (selectedShifts && selectedShifts.length) {
            for (let i = 0; i < selectedShifts.length; i++) {
                if (shiftId === selectedShifts[i].shiftId) {
                    index = i;
                    break;
                }
            }
        }
        
        return index;
    },
    
    parseShiftToggle : function(cmp, event) {
        let shift = event.getParams();
        let selectedShifts = cmp.get('v.selectedShifts');
        let shiftIndex = this.findShiftInList(cmp, shift.shiftId);
        
        if (shift.selected && shiftIndex === -1) {
            // add to selectedShifts list
            selectedShifts.push(shift);
        }
        else if (!shift.selected && shiftIndex > -1) {
            selectedShifts.splice(shiftIndex, 1);
        }
    
        cmp.set('v.selectedShifts', selectedShifts);
    },
    
    signUp : function(cmp) {
        let shifts = cmp.get('v.selectedShifts');
        let volunteerId = cmp.get('v.volunteerId');
        let action = cmp.get('c.signUpVolunteerForShifts');
        let isSubmitting = cmp.get('v.isSubmitting');
        let shiftIds = [];
        
        if (isSubmitting) {
            return;
        }
        
        cmp.set('v.signupError', '');
        
        for (let i = 0; i < shifts.length; i++) {
            shiftIds.push(shifts[i].shiftId);
        }
    
        action.setParams({
            'volunteerId' : volunteerId,
            'shiftIds' : shiftIds
        });
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            if ('SUCCESS' === state) {
                cmp.set('v.didSuccessfullySave', true);
    
                let navEvent = $A.get('e.force:navigateToURL');
    
                navEvent.setParams({
                    'url' : '/volunteers/s/my-volunteer-profile'
                });
    
                navEvent.fire();
            }
            else if ('ERROR' === state) {
                let errors = response.getError();
    
                cmp.set('v.showError', true);
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.errorHeading', 'There was an error saving your volunteer shift selection. Please try again.');
                        cmp.set('v.errorMsg', errors[0].message);
                    }
                }
                
                console.error('error signing up', errors);
            }
    
            cmp.set('v.showSpinner', false);
        });
    
        cmp.set('v.showSpinner', true);
        cmp.set('v.showError', false);
        cmp.set('v.didSuccessfullySave', false);
    
        $A.enqueueAction(action);
    },
    
})