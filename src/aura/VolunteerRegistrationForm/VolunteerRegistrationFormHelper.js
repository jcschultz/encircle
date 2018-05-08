({
    
    
    loadPicklistValues : function(cmp) {
        this.loadPronouns(cmp);
        this.loadTrainingOptions(cmp);
    },
    
    loadPronouns : function(cmp) {
        var action = cmp.get('c.getPronouns');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                cmp.set('v.pronounOptions', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading pronoun picklist values',
                    response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    loadTrainingOptions : function(cmp) {
        var action = cmp.get('c.getTrainings');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                cmp.set('v.trainingOptions', response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading training picklist values',
                    response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    submitForm : function(cmp) {
        var action = cmp.get('c.registerVolunteer');
        var isSubmitting = cmp.get('v.isSubmitting');
        var volunteerInfo;
    
        if (isSubmitting) {
            return;
        }
        
        if (!this.isFormValid(cmp)) {
            return;
        }
        
        volunteerInfo = {
            'firstName' : cmp.get('v.firstName'),
            'lastName' : cmp.get('v.lastName'),
            'preferredName' : cmp.get('v.preferredName'),
            'pronouns' : cmp.get('v.pronouns'),
            'street' : cmp.get('v.street'),
            'city' : cmp.get('v.city'),
            'state' : cmp.get('v.state'),
            'zip' : cmp.get('v.zip'),
            'country' : cmp.get('v.country'),
            'email' : cmp.get('v.email'),
            'phone1' : cmp.get('v.phone1'),
            'phone2' : cmp.get('v.phone2'),
            'phone3' : cmp.get('v.phone3'),
            'dobMonth' : cmp.get('v.dobMonth'),
            'dobDay' : cmp.get('v.dobDay'),
            'dobYear' : cmp.get('v.dobYear'),
            'homeless' : cmp.get('v.homeless'),
            'hospitalized' : cmp.get('v.hospitalized'),
            'hospitalizationExplanation' : cmp.get('v.hospitalized') === 'true' ? cmp.get('v.hospitalizationExplanation') : '',
            'volunteeringForSchool' : cmp.get('v.volunteeringForSchool'),
            'volunteeringForSchoolLength' : cmp.get('v.volunteeringForSchool') === 'true' ? cmp.get('v.volunteeringForSchoolLength') : '',
            'ecFirstName' : cmp.get('v.ecFirstName'),
            'ecLastName' : cmp.get('v.ecLastName'),
            'ecRelationship' : cmp.get('v.ecRelationship'),
            'ecPhone1' : cmp.get('v.ecPhone1'),
            'ecPhone2' : cmp.get('v.ecPhone2'),
            'ecPhone3' : cmp.get('v.ecPhone3'),
            'reason' : cmp.get('v.reason'),
            'training' : cmp.get('v.training')
        };
        
        action.setParams({'volunteerInfo' : volunteerInfo});
    
        action.setCallback(this, function(response) {
            var state = response.getState();
    
            cmp.set('v.isSubmitting', false);
        
            if ('SUCCESS' === state) {
                cmp.set('v.showForm', false);
                cmp.set('v.didSuccessfullySave', true);
            }
            else if ('ERROR' === state) {
                cmp.set('v.showError', true);
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.errorMsg', errors[0].message);
                    }
                }
                
                console.log(state, errors);
            }
        });
        
        cmp.set('v.isSubmitting', true);
        cmp.set('v.showError', false);
        cmp.set('v.didSuccessfullySave', false);
        
        $A.enqueueAction(action);
    },
    
    isFormValid : function(cmp) {
        // check all fields marked required.
        var requiredValid = cmp.find('required').reduce(
            function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        // now check conditionally required fields.
        var conditionallyValid = cmp.find('conditionallyRequired').reduce(
            function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        return requiredValid && conditionallyValid;
    },
    
    
    
})