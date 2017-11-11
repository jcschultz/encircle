({
    TRAINED_VOLUNTEER : 'Trained Volunteer',
    
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
                    this.showToast(component, 'info', 'Thanks!', 'Your visit has been recorded. Thanks for visiting us today.')
                }
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    this.showToast(component, 'error', 'Error', 'There was an error recording your visit.')
                }
                console.error('error saving visitor', response);
            }
        });
        
        if (label === this.TRAINED_VOLUNTEER) {
            component.set('v.step', 'volunteer_search');
        }
        else {
            component.set('v.showSpinner', true);
        }
    
        $A.enqueueAction(action);
    },
    
    showToast : function(component, severity, title, message) {
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    }
    
})