({
    doInit : function(component, event, helper) {
            helper.loadVolunteerDetails(cmp);    
    },
    toggleButtonEnabled : function(component, event, helper) {
		var isAgreed = event.getSource().get('v.value');
        component.find("agreeButton").set("v.disabled", !isAgreed);
    }
})