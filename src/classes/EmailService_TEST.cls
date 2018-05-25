@isTest
private class EmailService_TEST {
    
    static EmailService.EmailInfo emailInfo;
    
    static {
        emailInfo = new EmailService.EmailInfo();
        emailInfo.uids = '1234';
        emailInfo.startDatetime = Datetime.now();
        emailInfo.endDatetime = Datetime.now().addMinutes(30);
        emailInfo.inviteSummary = 'test email';
        emailInfo.location = 'my house';
        emailInfo.subject = 'test subject';
        emailInfo.orgWideEmailAddressId = null;
        emailInfo.recipientId = UserInfo.getUserId();
        emailInfo.emailBody = 'testing \n testing';
    }
    
    static testMethod void testSendingWithoutAttachment() {
        Test.startTest();
        
        EmailService service = EmailService.getInstance();
        service.buildEmail(emailInfo);
        service.sendEmails();
        
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
    }
    
    static testMethod void testSendingWithAttachment() {
        Test.startTest();
        
        EmailService service = EmailService.getInstance();
        service.buildEmailWithAttachment(emailInfo);
        service.sendEmails();
        
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
    }
    
}