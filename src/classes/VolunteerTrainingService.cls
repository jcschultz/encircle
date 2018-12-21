public virtual without sharing class VolunteerTrainingService {
    
    @TestVisible
    private static VolunteerTrainingService instance;
    
    protected VolunteerTrainingService() { }
    
    public static VolunteerTrainingService getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new VolunteerTrainingService();
        return instance;
    }
    
    public virtual List<VolunteerTrainingViewModel> getUpcomingTrainings() {
        VolunteerTrainingMapper mapper = VolunteerTrainingMapper.getInstance();
        return mapper.getUpcomingTrainings();
    }
    
    public virtual List<VolunteerTrainingViewModel> getMyUpcomingTrainings(Id volunteerId) {
        VolunteerTrainingAttendanceMapper mapper = VolunteerTrainingAttendanceMapper.getInstance();
        return mapper.getUpcomingAttendanceByVolunteerId(volunteerId);
    }
    
    public virtual VolunteerTrainingViewModel registerVolunteerForTraining(Id volunteerId, Id trainingId) {
        VolunteerTrainingAttendanceMapper mapper = VolunteerTrainingAttendanceMapper.getInstance();
        
        VolunteerTrainingViewModel vtvm = new VolunteerTrainingViewModel();
        vtvm.trainingId = trainingId;
        vtvm.volunteerId = volunteerId;
        
        List<VolunteerTrainingViewModel> trainings = mapper.saveAttendance(
            new List<VolunteerTrainingViewModel>{vtvm}
        );
        
        return trainings[0];
    }
    
    public virtual void unregisterAttendance(Id attendanceId) {
        VolunteerTrainingAttendanceMapper mapper = VolunteerTrainingAttendanceMapper.getInstance();
        mapper.deleteAttendance(new List<Id>{attendanceId});
    }
    
}