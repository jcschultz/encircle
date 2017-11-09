({
    
    closeModal : function(component) {
        component.set('v.showModal', false);
    },
    
    loadPicklistValues : function(component) {
        this.loadPronouns(component);
        this.loadTrainingOptions(component);
    },
    
    loadPronouns : function(component) {
        var action = component.get('c.getPronouns');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                component.set('v.pronounOptions', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading pronoun picklist values',
                    response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    loadTrainingOptions : function(component) {
        var action = component.get('c.getTrainings');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                component.set('v.trainingOptions', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading training picklist values',
                    response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    submitForm : function(component) {
        var action = component.get('c.registerVolunteer');
        var volunteerInfo;
        
        if (!this.isFormValid(component)) {
            return;
        }
    
        volunteerInfo = {
            'firstName' : component.get('v.firstName'),
            'lastName' : component.get('v.lastName'),
            'preferredName' : component.get('v.preferredName'),
            'pronouns' : component.get('v.pronouns'),
            'street' : component.get('v.street'),
            'city' : component.get('v.city'),
            'state' : component.get('v.state'),
            'zip' : component.get('v.zip'),
            'country' : component.get('v.country'),
            'email' : component.get('v.email'),
            'phone1' : component.get('v.phone1'),
            'phone2' : component.get('v.phone2'),
            'phone3' : component.get('v.phone3'),
            'dobMonth' : component.get('v.dobMonth'),
            'dobDay' : component.get('v.dobDay'),
            'dobYear' : component.get('v.dobYear'),
            'ecFirstName' : component.get('v.ecFirstName'),
            'ecLastName' : component.get('v.ecLastName'),
            'ecRelationship' : component.get('v.ecRelationship'),
            'ecPhone1' : component.get('v.ecPhone1'),
            'ecPhone2' : component.get('v.ecPhone2'),
            'ecPhone3' : component.get('v.ecPhone3'),
            'reason' : component.get('v.reason'),
            'training' : component.get('v.training')
        };
        
        action.setParams({'volunteerInfo' : volunteerInfo});
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            component.set('v.showSpinner', false);
            component.set('v.modalType', state);
            component.set('v.showModal', true);
        
            if ('SUCCESS' === state) {
                console.log(state, response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.log(state, response.getError());
                
            }
        });
        
        component.set('v.showSpinner', true);
        
        $A.enqueueAction(action);
        
    },
    
    isFormValid : function(component) {
        var allValid = component.find('required').reduce(
            function(validSoFar, inputCmp) {
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        return allValid;
    },
    
    
})