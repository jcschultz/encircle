({
    loadVolunteerDetails : function(cmp) {
        const volunteerId = cmp.get('v.volunteerId');
        
        if (!volunteerId) {
            cmp.set('v.volunteer', '');
            return;
        }
        
        
        const action = cmp.get('c.loadVolunteerViewModel');
        
        action.setParams({
            'volunteerId' : volunteerId
        });
        
        action.setCallback(this, function(response){
            const state = response.getState();
            
            if ('SUCCESS' === state) {
                cmp.set('v.volunteer', response.getReturnValue());
            }
            
        });
        
        $A.enqueueAction(action);
    }
})