({
    
    chooseFacilitator : function(cmp, chosenFacilitator) {
        cmp.set('v.chosenFacilitator', chosenFacilitator);
    },
    
    doNameSearch : function(cmp, nameInput) {
        var action = cmp.get('c.searchContacts');
        
        this.resetChosenFacilitator(cmp);
        
        action.setParams({
            'nameInput' : nameInput
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if ('SUCCESS' === state) {
                cmp.set('v.facilitatorResults', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                cmp.set('v.facilitatorResults', []);
                console.error('error searching facilitators', response.getError());
            }
        });
        
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
            // store chosen facilitator
            this.chooseFacilitator(cmp, event.getParam('selectedObject'));
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
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    },
    
    signIn : function(cmp) {
        var chosenFacilitator = cmp.get('v.chosenFacilitator');
        var hours = cmp.get('v.hours');
        var action = cmp.get('c.signIn');
        
        action.setParams({
            'contactId' : chosenFacilitator.contactId,
            'hours' : hours
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            this.hideSpinner(cmp);
            
            if ('SUCCESS' === state) {
                this.showToast(cmp, 'success', 'Thanks!', 'You are now signed in. Thanks for facilitating today.');
                this.resetApp(cmp);
            }
            else if ('ERROR' === state) {
                var errors = response.getError();
                
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