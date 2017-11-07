({
    submitForm : function(component) {
        console.log('firstName', component.get('v.firstName'));
        console.log('lastName', component.get('v.lastName'));
        console.log('preferredName', component.get('v.preferredName'));
        console.log('pronouns', component.get('v.pronouns'));
        console.log('address1', component.get('v.address1'));
        console.log('address2', component.get('v.address2'));
        console.log('city', component.get('v.city'));
        console.log('state', component.get('v.state'));
        console.log('zip', component.get('v.zip'));
        console.log('country', component.get('v.country'));
        console.log('email', component.get('v.email'));
        console.log('phone1', component.get('v.phone1'));
        console.log('phone2', component.get('v.phone2'));
        console.log('phone3', component.get('v.phone3'));
        console.log('dobMonth', component.get('v.dobMonth'));
        console.log('dobDay', component.get('v.dobDay'));
        console.log('dobYear', component.get('v.dobYear'));
        console.log('ecFirstName', component.get('v.ecFirstName'));
        console.log('ecLastName', component.get('v.ecLastName'));
        console.log('ecRelationship', component.get('v.ecRelationship'));
        console.log('ecPhone1', component.get('v.ecPhone1'));
        console.log('ecPhone2', component.get('v.ecPhone2'));
        console.log('ecPhone3', component.get('v.ecPhone3'));
        console.log('reason', component.get('v.reason'));
        console.log('training', component.get('v.training'));
        
        if (!this.isFormValid(component)) {
            console.log('form not valid');
            return;
        }
        
        console.log('form IS valid!');
    },
    
    isFormValid : function(component) {
        var allValid = component.find('required').reduce(
            function(validSoFar, inputCmp) {
                return validSoFar && inputCmp.get('v.validity').valid;
            },
            true
        );
        
        return allValid;
    }
    
})