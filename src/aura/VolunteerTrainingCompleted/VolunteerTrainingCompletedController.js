({
    getAttendences : function(component, event, helper) {
        helper.onLoad(component, event);
    },
    save: function(component, event, helper) {
        var updatedRecords = component.get("v.volunteerAttendances");
        helper.updateSelected(component, event, updatedRecords);
    },

    checkboxSelect: function(component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        // get the selectedCount attrbute value(default is 0) for add/less numbers. 
        var getSelectedNumber = component.get("v.selectedCount");
        // check, if selected checkbox value is true then increment getSelectedNumber with 1 
        // else Decrement the getSelectedNumber with 1     
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        // set the actual value on selectedCount attribute to show on header part. 
        component.set("v.selectedCount", getSelectedNumber);
    },
    selectAll: function(component, event, helper) {
        //get the header checkbox value  
        var isSelected = event.getSource().get("v.value");
        // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
        // return the List of all checkboxs element 
        var getAllId = component.find("boxPack");
        // If the local ID is unique[in single record case], find() returns the component instead of an array
        if(! Array.isArray(getAllId)){
            component.find("boxPack").set("v.value", isSelected);
            component.set("v.selectedCount", isSelected ? 1 : 0);
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", isSelected);
            }
            component.set("v.selectedCount", isSelected ? getAllId.length : 0);
        }
    }
})