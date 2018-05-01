({
    
    fireMatchNotification : function(cmp) {
        var evt = cmp.getEvent('volunteerRecordFinderEvent');
        
        evt.setParams({
            'eventType' : 'VOLUNTEER_VERIFIED',
            'volunteerId' : cmp.get('v.selectedVolunteerId')
        });
        
        evt.fire();
    },
    
    fireSearchNotification : function(cmp) {
        var evt = cmp.getEvent('volunteerRecordFinderEvent');
        
        evt.setParams({
            'eventType' : 'SEARCHING'
        });
        
        evt.fire();
    },
    
    handleCancelClick : function(cmp) {
        cmp.set('v.showMatchingContacts', true);
        cmp.set('v.showLastNameVerification', false);
        cmp.set('v.lastNameInput', '');
    },
    
    handleVerifyClick : function(cmp) {
        var action = cmp.get('c.doSecurityCheck');
        var lastNameInput = cmp.get('v.lastNameInput');
        
        if (!lastNameInput || !lastNameInput.trim()) {
            return;
        }
        
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'volunteerId' : cmp.get('v.selectedVolunteerId'),
            'input' : lastNameInput.trim()
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var model = response.getReturnValue();
            
            cmp.set('v.showSpinner', false);
            
            if ('SUCCESS' === state) {
                if (model.isSuccess) {
                    cmp.set('v.showLastNameVerification', false);
                    cmp.set('v.lastNameInput', '');
                    this.fireMatchNotification(cmp);
                }
                else {
                    this.showToast('error', 'Error', 'Sorry, we weren\'t able to verify your identity.');
                }
            }
            else if ('ERROR' === state) {
                this.showToast('error', 'Error', 'There was an error searching for your record.');
                
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    console.error('error searching', errors[0]);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleVolunteerRecordFinderEvent : function(cmp, event) {
        var eventType = event.getParam('eventType');
        var volunteerId = event.getParam('volunteerId');
        
        if ('VOLUNTEER_SELECTED' === eventType) {
            event.stopPropagation();
            cmp.set('v.selectedVolunteerId', volunteerId);
            cmp.set('v.showMatchingContacts', false);
            cmp.set('v.showLastNameVerification', true);
        }
    },
    
    resetFinder : function(cmp) {
        cmp.set('v.matchingContacts', []);
        cmp.set('v.showMatchingContacts', false);
        cmp.set('v.showLastNameVerification', false);
    },
    
    searchForVolunteer : function(cmp) {
        var action = cmp.get('c.doSearch');
        
        cmp.set('v.showSpinner', true);
        
        action.setParams({
            'input' : cmp.get('v.phoneEmailInput')
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var model = response.getReturnValue();
            
            cmp.set('v.showSpinner', false);
            
            if ('SUCCESS' === state) {
                if (model.isSuccess) {
                    cmp.set('v.matchingContacts', model.records);
                    cmp.set('v.showMatchingContacts', true);
                }
                else if (model.errorType === 'NO_MATCHES') {
                    this.showToast('error', 'Error', 'Sorry, we couldn\'t find any matching volunteer records.');
                }
                else {
                    this.showToast('error', 'Error', 'There was an error searching for your record.');
                }
            }
            else if ('ERROR' === state) {
                this.showToast('error', 'Error', 'There was an error searching for your record.');
                
                var errors = response.getError();
                
                if (errors && errors[0]) {
                    console.error('error searching', errors[0]);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    showToast : function(severity, title, message) {
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type' : severity
        });
        
        toastEvent.fire();
    },
    
});