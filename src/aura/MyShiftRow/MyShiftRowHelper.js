({
    
    removeShift : function(cmp) {
        var shift = cmp.get('v.shift');
        var evt = cmp.getEvent('myShiftRowEvent');
        
        evt.setParams({
            'hourId' : shift.id,
            'action' : 'DELETE'
        });
        
        evt.fire();
    },
    
});