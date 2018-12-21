@IsTest
private class VolunteerTrainingAttendanceMapper_TEST {
    
    private static Contact con;
    private static Volunteer_Training__c training;
    
    static {
        training = new Volunteer_Training__c(
            Description__c = 'testing',
            Location__c = 'my location',
            StartDateTime__c = Datetime.now().addDays(1),
            EndDateTime__c = Datetime.now().addDays(1).addMinutes(30)
        );
        insert training;
        
        con = new Contact(
            LastName = 'testcontact'
        );
        insert con;
    }
    
    @IsTest
    private static void testRoundTrip() {
        VolunteerTrainingAttendanceMapper mapper = VolunteerTrainingAttendanceMapper.getInstance();
        
        VolunteerTrainingViewModel vtvm = new VolunteerTrainingViewModel();
        vtvm.volunteerId = con.Id;
        vtvm.trainingId = training.Id;
        
        mapper.saveAttendance(new List<VolunteerTrainingViewModel>{vtvm});
        
        List<Volunteer_Training_Attendance__c> atts = [SELECT Id FROM Volunteer_Training_Attendance__c];
        System.assertEquals(1, atts.size());
        
        List<VolunteerTrainingViewModel> upcoming = mapper.getUpcomingAttendanceByVolunteerId(con.Id);
        System.assertEquals(1, upcoming.size());
        
        List<VolunteerTrainingViewModel> byId = mapper.getAttendanceByIds(new List<Id>{upcoming[0].id});
        System.assertEquals(1, byId.size());
        System.assertEquals(training.Id, byId[0].trainingId);
        
        mapper.deleteAttendance(new List<Id>{byId[0].id});
    
        List<Volunteer_Training_Attendance__c> afterDelete = new List<Volunteer_Training_Attendance__c>([
            SELECT Id FROM Volunteer_Training_Attendance__c
        ]);
        System.assert(afterDelete.isEmpty());
    }
    
}