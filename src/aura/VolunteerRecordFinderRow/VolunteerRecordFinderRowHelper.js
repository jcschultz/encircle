({
    
    selectVolunteer : function(cmp) {
        var contact = cmp.get('v.contact');
        var evt = cmp.getEvent('volunteerRecordFinderEvent');
        
        evt.setParams({
            'eventType' : 'VOLUNTEER_SELECTED',
            'volunteerId' : contact.id
        });
        
        evt.fire();
    },
    
});