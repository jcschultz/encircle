({
    
    chooseFacilitator : function(cmp, volunteerId) {
        let action = cmp.get('c.loadVolunteerData');
        
        action.setParams({'volunteerId' : volunteerId});
        
        action.setCallback(this, function(response){
            let state = response.getState();
    
            this.hideSpinner(cmp);
    
            if ('SUCCESS' === state) {
                cmp.set('v.chosenFacilitator', response.getReturnValue());
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
                // store chosen facilitator
                this.chooseFacilitator(cmp, volunteerId);
            } else {
                this.resetChosenFacilitator(cmp);
            }
            
        }
    },
    
    hideSpinner : function(cmp) {
        this.fireActionEvent(cmp, 'TOGGLE_SPINNER', 'HIDE');
    },
    
    resetApp : function(cmp) {
        this.resetChosenFacilitator(cmp);
        this.fireActionEvent(cmp, 'RESET_APP', '');
    },
    
    resetChosenFacilitator : function(cmp) {
        cmp.set('v.chosenFacilitator', '');
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
    
    signIn : function(cmp) {
        let chosenFacilitator = cmp.get('v.chosenFacilitator');
        let hours = cmp.get('v.hours');
        let action = cmp.get('c.signIn');
        
        action.setParams({
            'volunteerId' : chosenFacilitator.id,
            'hours' : hours
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            this.hideSpinner(cmp);
            
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in. Thanks for facilitating today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                let errors = response.getError();
                
                if (errors && errors[0]) {
                    this.showToast(cmp, 'error', 'Error', 'There was an error signing you in.');
                }
                console.error('error signing in', response);
            }
        });
        
        this.showSpinner(cmp);
        
        $A.enqueueAction(action);
    },
    
    
});