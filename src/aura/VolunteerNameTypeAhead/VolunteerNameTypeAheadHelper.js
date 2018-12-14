({
    
    choseVolunteer : function(cmp, event) {
        let volunteers = cmp.get('v.volunteers');
        let idx = event.getSource().get('v.value');
        let chosenVolunteer = volunteers[idx];
        
        cmp.set('v.chosenVolunteer', chosenVolunteer);
    
        this.resetVolunteerSearch(cmp);
        
        let eventParams = {
            'selectedObject' : chosenVolunteer.id,
            'action' : 'SELECTION'
        };
    
        this.fireEvent(cmp, eventParams);
    },
    
    clearNameInput : function(cmp) {
        cmp.set('v.userNameInput', '');
    },
    
    displayNoVolunteerResults : function(cmp) {
        cmp.set('v.volunteers', '');
        cmp.set('v.showVolunteersPicklist', false);
        cmp.set('v.showNoVolunteers', true);
    },
    
    doNameSearch : function(cmp) {
        let action = cmp.get('c.searchVolunteers');
        let nameInput = cmp.get('v.userNameInput');
        nameInput = nameInput ? nameInput.trim() : '';
    
        if (!nameInput.length) {
            cmp.set('v.volunteers', []);
            return;
        }
    
        if (nameInput.length < 3) {
            return;
        }
        
        action.setParams({
            'nameInput' : nameInput
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if ('SUCCESS' === state) {
                cmp.set('v.volunteers', response.getReturnValue());
                this.handleVolunteerResultsChange(cmp);
            }
            else if ('ERROR' === state) {
                cmp.set('v.volunteers', []);
                console.error('error searching volunteers', response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    
    fireEvent : function(cmp, params) {
        var typeAheadEvent = cmp.getEvent('typeAheadEvent');
    
        typeAheadEvent.setParams(params);
    
        typeAheadEvent.fire();
    },
    
    handleNameSearchChange : function(cmp) {
        var delay = 400;
        var timer = cmp.get('v.timer');
        var that = this;
        
        clearTimeout(timer);
        
        timer = window.setTimeout(
            $A.getCallback(function(){
                that.doNameSearch(cmp);
            }),
            delay
        );
        
        cmp.set('v.timer', timer);
    },
    
    handleVolunteerResultsChange : function(cmp) {
        let volunteers = cmp.get('v.volunteers');
        let hasVolunteers = (volunteers && volunteers.length);
    
        if (!hasVolunteers) {
            this.resetChosenVolunteer(cmp);
            cmp.set('v.showVolunteersPicklist', false);
        }
        
        cmp.set('v.showVolunteersPicklist', hasVolunteers);
        cmp.set('v.showNoVolunteers', !hasVolunteers);
    },
    
    resetChosenVolunteer : function(cmp) {
        cmp.set('v.chosenVolunteer', '');
    
        var eventParams = {
            'selectedObject' : null,
            'action' : 'SELECTION'
        };
    
        this.fireEvent(cmp, eventParams);
    },
    
    resetVolunteerSearch : function(cmp) {
        cmp.set('v.showVolunteersPicklist', false);
        cmp.set('v.showNoVolunteers', false);
    },
    
});