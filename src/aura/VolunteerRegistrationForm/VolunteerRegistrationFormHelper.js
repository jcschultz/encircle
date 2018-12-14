({
    
    
    loadPicklistValues : function(cmp) {
        this.loadPronouns(cmp);
    },
    
    loadPronouns : function(cmp) {
        var action = cmp.get('c.getPronouns');
    
        action.setCallback(this, function(response) {
            let state = response.getState();
        
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
    
    submitForm : function(cmp) {
        let action = cmp.get('c.registerVolunteer');
        let isSubmitting = cmp.get('v.isSubmitting');
        let volunteerInfo;
    
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
            'training' : (cmp.get('v.hospitalized') !== 'true' && cmp.get('v.homeless') !== 'true') ? cmp.get('v.training') : ''
        };
        
        action.setParams({'volunteerInfo' : volunteerInfo});
    
        action.setCallback(this, function(response) {
            let state = response.getState();
    
            cmp.set('v.isSubmitting', false);
        
            if ('SUCCESS' === state) {
                window.sessionStorage.setItem('volunteerId', response.getReturnValue().id);
                
                this.goToProfile();
            }
            else if ('ERROR' === state) {
                cmp.set('v.showSpinner', false);
                cmp.set('v.showError', true);
                let errors = response.getError();
                
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
        cmp.set('v.showSpinner', true);
        
        $A.enqueueAction(action);
    },
    
    goToProfile : function() {
        let navEvent = $A.get('e.force:navigateToURL');
    
        navEvent.setParams({
            'url' : '/volunteers/s/my-volunteer-profile'
        });
    
        navEvent.fire();
    },
    
    isFormValid : function(cmp) {
        let isOldEnough = true;
        
        // check all fields marked required.
        let requiredValid = cmp.find('required').reduce(
            function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        // now check conditionally required fields.
        let conditionallyValid = cmp.find('conditionallyRequired').reduce(
            function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        if (requiredValid) {
            let over18 = this.validateAge(cmp);
            
            if (over18 < 18) {
                cmp.set('v.showError', true);
                cmp.set('v.errorMsg', 'You must be 18 or older to volunteer.');
                isOldEnough = false;
            }
            
        }
        
        return requiredValid && conditionallyValid && isOldEnough;
    },
    
    validateAge : function(cmp) {
        let birthDate = new Date(
            parseInt(cmp.get('v.dobYear'), 10),
            parseInt(cmp.get('v.dobMonth'), 10),
            parseInt(cmp.get('v.dobDay'), 10)
        ).getTime();
        
        let today = Date.now();
        
        let diff = (today - birthDate) / 1000 / (60 * 60 * 24);
        
        return Math.abs(Math.round(diff/365.25));
    },
    
    
    
})