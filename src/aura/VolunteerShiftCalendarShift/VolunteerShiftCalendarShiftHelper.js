({
    
    fireToggleEvent : function(component) {
        var shift = component.get('v.shift');
        var evt = component.getEvent('shiftToggleEvent');
        
        evt.setParams({
            'dateOfMonth' : component.get('v.dateOfMonth'),
            'dayOfWeek' : component.get('v.dayOfWeek'),
            'monthAbbreviation' : component.get('v.monthAbbreviation'),
            'shiftId' : shift.shiftId,
            'jobName' : shift.jobName,
            'startTime' : shift.startTime,
            'selected' : shift.selected,
            'duration' : shift.duration
        });
        
        evt.fire();
    },
    
    handleJobClick : function(component) {
        var shift = component.get('v.shift');
        var shiftEventInfo;
        
        if (shift.volunteersStillNeeded < 1) {
            return;
        }
        
        shift.selected = !shift.selected;
        component.set('v.shift', shift);
    
        this.fireToggleEvent(component);
    },
    
})