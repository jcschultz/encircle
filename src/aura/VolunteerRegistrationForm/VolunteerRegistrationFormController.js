({
    
    closeModal : function(component, event, helper) {
        helper.closeModal(component);
    },
    
    doInit : function(component, event, helper) {
        helper.loadPicklistValues(component);
    },
    
    submitForm : function(component, event, helper) {
        helper.submitForm(component);
    },
})