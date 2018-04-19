({
    FACILITATOR : 'Facilitator',
    TRAINED_VOLUNTEER : 'Trained Volunteer',
    
    getVisitorTypes : function(cmp) {
        var action = cmp.get('c.getVisitorTypes');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                cmp.set('v.visitorTypes', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error retrieving visitor types', error.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    handleActivityClick : function(cmp, event) {
        var label = event.getSource().get('v.label');
        var action = cmp.get('c.saveActivity');
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
            
            this.toggleSpinner(cmp, 'HIDE');
        
            if ('SUCCESS' === state) {
                if (label !== this.TRAINED_VOLUNTEER && label !== this.FACILITATOR) {
                    this.showToast(cmp, 'success', 'Thanks!', 'Your visit has been recorded. Thanks for visiting us today.');
                }
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error recording your visit.');
                }
                console.error('error saving visitor', response);
            }
        });
        
        if (label === this.TRAINED_VOLUNTEER) {
            this.switchToVolunteerView(cmp);
        }
        if (label === this.FACILITATOR) {
            this.switchToFacilitatorView(cmp);
        }
        else {
            this.toggleSpinner(cmp, 'SHOW');
        }
    
        $A.enqueueAction(action);
    },
    
    handleDoorSurveyActionEvent : function(cmp, event) {
        const action = event.getParam('action');
        const message = event.getParam('message');
        
        if ('RESET_APP' === action) {
            this.resetApp(cmp);
        }
        else if ('TOGGLE_SPINNER' === action) {
            this.toggleSpinner(cmp, message);
        }
    },
    
    resetApp : function(cmp) {
        cmp.set('v.step', 'welcome');
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
    
    switchToFacilitatorView : function(cmp) {
        cmp.set('v.step', 'facilitator');
    },
    
    switchToVolunteerView : function(cmp) {
        cmp.set('v.step', 'volunteer');
    },
    
    toggleSpinner : function(cmp, showOrHide) {
        cmp.set('v.showSpinner', (showOrHide === 'SHOW'));
    },
    
});