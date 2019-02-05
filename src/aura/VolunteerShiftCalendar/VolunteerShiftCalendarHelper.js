({
    
    
    
    getInitialData : function(component) {
        var action = component.get('c.getInitialData');
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                this.parseCalendarData(component, response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading initial data', response.getError());
            }
        });
    
        $A.enqueueAction(action);
    },
    
    loadNextMonth : function(component) {
        var action = component.get('c.getCalendarData');
    
        action.setParams({
            'startDateString' : component.get('v.nextStartDate'),
            'endDateString' : component.get('v.nextEndDate')
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if ('SUCCESS' === state) {
                this.parseCalendarData(component, response.getReturnValue());
            }
            else if ('ERROR' === state) {
                console.error('error loading more data', response.getError());
            }
        });
        
        component.set('v.showSpinner', true);
    
        $A.enqueueAction(action);
    },
    
    parseCalendarData : function(component, newData) {
        var calendarDays = component.get('v.calendarDays');
        var jobClasses = component.get('v.jobClasses');
        var jobCount = component.get('v.jobCount');
        var lastMonth = '';
        var cities = component.get('v.cities');
        var selectedCity = component.get('v.selectedCity');
        
        if (!calendarDays) {
            calendarDays = [];
        }
        
        if (!jobClasses) {
            jobClasses = {};
        }
        
        if (!cities) {
            cities = [];
        }
        
        for (var i = 0; i < newData.days.length; i++) {
            if (newData.days[i].rowType === 'day' && newData.days[i].shifts.length) {
                for (var j = 0; j < newData.days[i].shifts.length; j++) {
                    var jobId = newData.days[i].shifts[j].jobId;
                    
                    if (!jobClasses[jobId]) {
                        jobCount++;
                        jobClasses[jobId] = 'job' + jobCount;
                    }
    
                    newData.days[i].shifts[j].jobClass = jobClasses[jobId];
                }
            }
        }
        
        for (var i = 0; i < newData.cities.length; i++) {
            if (cities.indexOf(newData.cities[i]) < 0) {
                cities.push(newData.cities[i]);
            }
        }
        cities.sort();
        
        if (!selectedCity) {
            selectedCity = cities[0];
        }
        
        component.set('v.calendarDays', calendarDays.concat(newData.days));
        component.set('v.nextStartDate', newData.nextStartDate);
        component.set('v.nextEndDate', newData.nextEndDate);
        component.set('v.showSpinner', false);
        component.set('v.jobClasses', jobClasses);
        component.set('v.jobCount', jobCount);
        component.set('v.cities', newData.cities);
        component.set('v.selectedCity', selectedCity);
    },
    
    selectCity : function(cmp, city) {
        cmp.set('v.selectedCity', city);
    }
    
    
})