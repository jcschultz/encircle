public class VolunteerTrainingCompletedController {
    //query Volunteer Training Attendence records that haven't completed training
    @AuraEnabled
    public static List<Volunteer_Training_Attendance__c> getTrainingAttendances(Id training) {
        return [
            SELECT Id, Completed_Training__c, Volunteer__c, Volunteer__r.Name, Volunteer__r.Statement_of_Confidentiality__c
                FROM Volunteer_Training_Attendance__c 
            	WHERE Volunteer_Training__c = :training AND Completed_Training__c = false
            	ORDER BY Volunteer__r.Name
        ];
    }
    
	//update attendance records with completed training, 
	//email contacts that haven't returned the confidentiality statement
    @AuraEnabled
    public static void updateAttendences(List<Volunteer_Training_Attendance__c> attendences) {
        update attendences;
        
        Set<Id> attendedContacts = new Set<Id>();
        for (Volunteer_Training_Attendance__c attendence : attendences) {
            attendedContacts.add(attendence.Volunteer__c);
        }
        Map<Id, Contact> emailRecipients = new Map<Id, Contact>([
            SELECT Id, Email
            FROM Contact 
            WHERE 
            	Id IN :attendedContacts AND 
            	Statement_of_Confidentiality__c = false AND 
            	HasOptedOutOfEmail = false AND
               	Email != null 
        ]);        
        EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'Volunteer_Ethics_Agreement' LIMIT 1];

        if (!emailRecipients.isEmpty() && template != null) {
            Messaging.MassEmailMessage message = createEmailMessage(new List<Id>(emailRecipients.keySet()), template.id);
            Messaging.SendEmail(New Messaging.MassEmailMessage[]{message});
        }
    }

	//creates email message
    private static Messaging.MassEmailMessage createEmailMessage(List<Id> contacts, Id template) {
		Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage(); 
		mail.setTargetObjectIds(contacts);
        mail.setTemplateId(template);
        mail.setUseSignature(false);
        mail.setReplyTo('donotreply@encircletogether.org');
        mail.setSenderDisplayName('Encircle');
        return mail;        
    }

}