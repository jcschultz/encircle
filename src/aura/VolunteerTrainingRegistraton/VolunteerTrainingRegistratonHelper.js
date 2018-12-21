({
    
    loadTrainingViewModel : function(cmp) {
        const action = cmp.get('c.getTrainings');
        const volunteerId = cmp.get('v.volunteerId');
        
        if (!volunteerId) {
            return;
        }
        
        action.setParams({'volunteerId' : volunteerId});
        
        action.setCallback(this, function(response){
            const state = response.getState();
    
            cmp.set('v.showSpinner', false);
            
            if ('SUCCESS' === state) {
                cmp.set('v.trainingVM', response.getReturnValue());
            } else {
                this.showToast(cmp, 'error', 'Error', 'There was an error retreiving the trainings.');
            }
        });
        
        cmp.set('v.showSpinner', true);
        
        $A.enqueueAction(action);
    },
    
    register : function(cmp, trainingId) {
        const action = cmp.get('c.registerForTraining');
        
        action.setParams({
            'volunteerId' : cmp.get('v.volunteerId'),
            'trainingId' : trainingId
        });
        
        action.setCallback(this, function(response) {
            const state = response.getState();
            
            cmp.set('v.showSpinner', false);
            
            if ('SUCCESS' === state) {
                cmp.set('v.trainingVM', response.getReturnValue());
                this.showToast(cmp, 'success', 'You are registered!', 'You are now registered. See you at the training!');
            } else {
                this.showToast(cmp, 'error', 'Error', 'There was an error registering you for the training.');
            }
        });
    
        cmp.set('v.showSpinner', true);
        
        $A.enqueueAction(action);
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
    
    unregister : function(cmp, attendanceId) {
        const action = cmp.get('c.unregisterFromTraining');
    
        action.setParams({
            'volunteerId' : cmp.get('v.volunteerId'),
            'attendanceId' : attendanceId
        });
    
        action.setCallback(this, function(response) {
            const state = response.getState();
        
            cmp.set('v.showSpinner', false);
        
            if ('SUCCESS' === state) {
                cmp.set('v.trainingVM', response.getReturnValue());
                this.showToast(cmp, 'success', '', 'You have successfully unregistered from the training.');
            } else {
                this.showToast(cmp, 'error', 'Error', 'There was an error unregistering you from the training.');
            }
        });
    
        cmp.set('v.showSpinner', true);
        
        $A.enqueueAction(action);
    },
});