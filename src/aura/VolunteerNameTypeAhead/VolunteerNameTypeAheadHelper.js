({
    
    choseVolunteer : function(cmp, event) {
        var volunteers = cmp.get('v.volunteerResults');
        var idx = event.getSource().get('v.value');
        var chosenVolunteer = volunteers[idx];
        
        cmp.set('v.chosenVolunteer', chosenVolunteer);
    
        this.resetVolunteerSearch(cmp);
        
        var eventParams = {
            'selectedObject' : chosenVolunteer,
            'action' : 'SELECTION'
        };
    
        this.fireEvent(cmp, eventParams);
        
        
    },
    
    displayNoVolunteerResults : function(cmp) {
        cmp.set('v.volunteerResults', '');
        cmp.set('v.showVolunteersPicklist', false);
        cmp.set('v.showNoVolunteers', true);
    },
    
    doNameSearch : function(cmp) {
        var nameInput = cmp.get('v.userNameInput');
        nameInput = nameInput ? nameInput.trim() : '';
        
        if (!nameInput.length) {
            cmp.set('v.volunteerResults', []);
            return;
        }
        
        if (nameInput.length < 3) {
            return;
        }
        
        var eventParams = {
            'userInput' : nameInput,
            'action' : 'USER_INPUT'
        };
        
        this.fireEvent(cmp, eventParams);
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
        var volunteerResults = cmp.get('v.volunteerResults');
        var hasVolunteers = (volunteerResults && volunteerResults.length);
    
        if (!hasVolunteers) {
            this.resetChosenVolunteer(cmp);
            this.resetVolunteerSearch(cmp);
        }
        
        cmp.set('v.showVolunteersPicklist', hasVolunteers);
        cmp.set('v.showNoVolunteers', !hasVolunteers);
    },
    
    resetChosenVolunteer : function(cmp) {
        cmp.set('v.chosenVolunteer', '');
        cmp.set('v.userNameInput', '');
    
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