public virtual class EmailService {
    
    @TestVisible
    private static EmailService instance;
    private static List<Messaging.SingleEmailMessage> emailsToSend;

    protected EmailService() { }

    public static EmailService getInstance() {
        if (instance != null) {
            return instance;
        }
        
        instance = new EmailService();
        return instance;
    }
    
    public virtual Messaging.EmailFileAttachment buildInvite(EmailInfo info) {
        String dateFormatString = 'yyyyMMdd\'T\'HHmmss\'Z\'';
        String dtStamp = Datetime.now().formatGmt(dateFormatString);
        String startDateString = info.startDatetime.formatGmt(dateFormatString);
        String duration = 'PT' + String.valueOf(
                (Decimal.valueOf(info.endDatetime.getTime() - info.startDatetime.getTime()) / 60000).round()
            ) + 'M';
        
        String invite = '' +
            'BEGIN:VCALENDAR\n' +
            'VERSION:2.0\n' +
            'PRODID:-//encircle/handcal//NONSGML v1.0//EN\n' +
            'METHOD:PUBLISH\n' +
            'CALSCALE:GREGORIAN\n' +
            'BEGIN:VEVENT\n' +
            'CLASS:\n' +
            'UID:{0}\n' +
            'DTSTAMP:{1}\n' +
            'DTSTART:{2}\n' +
            'DURATION:{3}\n' +
            'SUMMARY:{4}\n' +
            'LOCATION:{5}\n' +
            'STATUS:CONFIRMED\n' +
            'END:VEVENT\n' +
            'END:VCALENDAR';
        
        String inviteFormatted = String.format(
            invite,
            new List<String>{
                info.uids + '@encircle.salesforce.com',
                dtStamp,
                startDateString,
                duration,
                info.inviteSummary,
                info.location
            }
        );
        
        Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
        att.setBody(Blob.valueOf(inviteFormatted));
        att.setContentType('text/calendar');
        att.setFileName('encircleShift.ics');
        att.setInline(false);
        
        return att;
    }
    
    public virtual void buildEmailWithAttachment(EmailInfo info) {
        Messaging.SingleEmailMessage mail = buildSingleEmailMessage(info);
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {
            buildInvite(info)
        });
        
        addEmailToQueue(mail);
    }
    
    public virtual void buildEmail(EmailInfo info) {
        Messaging.SingleEmailMessage mail = buildSingleEmailMessage(info);
        addEmailToQueue(mail);
    }
    
    public virtual void addEmailToQueue(Messaging.SingleEmailMessage email) {
        if (emailsToSend == null) {
            emailsToSend = new List<Messaging.SingleEmailMessage>();
        }
        
        emailsToSend.add(email);
    }
    
    public virtual void sendEmails() {
        if (emailsToSend != null && !emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend, false);
            emailsToSend.clear();
        }
    }
    
    private Messaging.SingleEmailMessage buildSingleEmailMessage(EmailInfo info) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setCharset('UTF-8');
        mail.setSubject(info.subject);
        mail.setPlainTextBody(info.emailBody);
        mail.setHtmlBody(info.emailBody.replace('\n', '<br/>'));
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        mail.setToAddresses(new String[]{info.recipientId});
        
        if (String.isNotBlank(info.orgWideEmailAddressId)) {
            mail.setOrgWideEmailAddressId(info.orgWideEmailAddressId);
        }
        else {
            mail.setSenderDisplayName('Encircle');
        }
        
        return mail;
    }
    
    public class EmailInfo {
        public String uids;
        public Datetime startDatetime;
        public Datetime endDatetime;
        public String inviteSummary;
        public String location;
        public String subject;
        public String orgWideEmailAddressId;
        public String recipientId;
        public String emailBody;
    }
}