({
 onLoad: function(component, event) {
  console.log('onLoad call');
  //call apex class method
  var action = component.get('c.getTrainingAttendances');
  action.setParams({
    "training": component.get("v.recordId")
  });
  action.setCallback(this, function(response) {
   //store state of response
   var state = response.getState();
   if (state === "SUCCESS") {
    //set response value in ListOfContact attribute on component.
    component.set('v.volunteerAttendances', response.getReturnValue());
    // set deafult count and select all checkbox value to false on load 
    component.set("v.selectedCount", 0);
    component.find("selectAll").set("v.value", false);
   }
  });
  $A.enqueueAction(action);
 },
 
  updateSelected: function(component, event, volunteerAttendances) {
      //call apex method, pass the selected records
      var action = component.get('c.updateAttendences');
      action.setParams({
          "attendences": volunteerAttendances
      });
      action.setCallback(this, function(response) {
          if (response.getState() === "SUCCESS") {
              if (response.getReturnValue() != null) {
                  alert('The following error has occurred: ' + response.getReturnValue());
              }
              //refresh the List view
              //this.onLoad(component, event);
          }
      });
      $A.enqueueAction(action);
      $A.get("e.force:closeQuickAction").fire();
  }
})