({
    
    doInit : function(component, event, helper) {
        helper.getInitialData(component);
    },
    
    handleCityFilterChange : function(cmp, event, helper) {
        helper.selectCity(cmp, cmp.find('cityFilter').get('v.value'));
    },
    
    loadNextMonth : function(component, event, helper) {
        helper.loadNextMonth(component);
    },
    
    
})