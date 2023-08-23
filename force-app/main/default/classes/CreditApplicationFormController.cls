public without sharing class CreditApplicationFormController {
    
    @AuraEnabled
    public static String sendVerificationCodeEmail(Id contactId){
        String eCode = '--Error--';
        
        try {
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactId});
            if(contacts.isEmpty()){
                throw new AuraHandledException('No Contact Found.');
            }
            if(String.isBlank(contacts[0].Email)){
                throw new AuraHandledException('Email Address not found.');
            }
            
            List<Credit_Application_Form__c> creditApplicationForms = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId}); 
            if(creditApplicationForms[0].Code_Generation_Time__c != null) {
                DateTime previousTime = creditApplicationForms[0].Code_Generation_Time__c;
                Long differenceMillis = Math.abs(DateTime.now().getTime() - previousTime.getTime());
                
                Long customLabelValue = Long.valueOf(System.Label.credit_Form_Code_Expire_Duration);
                if(differenceMillis < customLabelValue){
                    long remainingMillis = customLabelValue - differenceMillis;
                    long remainingMinutes = remainingMillis / 60000;
                    long remainingSeconds = Math.mod(remainingMillis, 60000) / 1000;
                    String remainingTime = String.valueOf(remainingMinutes) + ' min ' + String.valueOf(remainingSeconds) + ' sec left';
                    
                    return eCode + ':' + remainingTime;
                }
            }
            
            String verificationCode = generateVerificationCode();
            sendEmail(contacts[0], verificationCode);
            CreditApplicationCodeController.updateCodeOnCreditApplicationForm(contacts[0].Id, verificationCode);
            
            return verificationCode;
        }
        catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - sendVerificationCodeEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getVerificationCode(Id contactId) {
        List<Credit_Application_Form__c> creditForms = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId});
        if(!creditForms.isEmpty() && String.isNotBlank(creditForms[0].Credit_Application_Code__c)) {
            return creditForms[0].Credit_Application_Code__c;
        }
        throw new AuraHandledException('No Code is found.');
    }
    
    // generates the 6-digit verfication code (numeric)
    @testVisible
    private static String generateVerificationCode() {
        return String.valueOf(Math.round((Math.random() * (900000) + 100000)));
    }
    
    /*
    * Functionality : this method send the email based on salesforce contact email with verfication code
    * Goal : 'verificationCode' will used when user open the Credit Apllication Form
    */
    public static void sendEmail(Contact contact, String verificationCode){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<OrgWideEmailAddress> orgWideEmailAddresses = OrgWideEmailAddressSelector.getOrgWideEmailAddress();
        if (!orgWideEmailAddresses.isEmpty()) {
            mail.setOrgWideEmailAddressId(orgWideEmailAddresses.get(0).Id);
        }
        
        // established list of recipients for the email
        mail.setToAddresses(new List<String>{contact.Email});
        
        // set the subject of OTP email
        mail.setSubject('OTP to open Credit Application');
        
        // extract the user name of the Contact
        String username = String.isBlank(contact.FirstName) ? (contact.LastName) : (contact.FirstName + ' ' + contact.LastName);
            
            // set email content
            String body = 'Hi '+ username + ',';
        body += '<br/><br/>';
        body += 'To ensure security of your Credit Application Form, we need to verify your identity. Enter the following code when prompted by Salesforce.';
        body += '<br/><br/>';
        body += 'Verification Code: <strong>'+verificationCode+'</strong>';
        body += '<br/><br/>';
        body += 'If you did not get verification code then, contact your Salesforce administrator.';
        body += '<br/><br/>';
        body += 'Thanks,<br/>';
        body += 'Credit Department<br/>';
        body += 'Louisville Tile<br/>';
        mail.setHtmlBody(body);
        
        // add the mail to the master list
        mails.add(mail);
        system.debug('\n----mails--'+mails);
        // send all mails which is in the master list
        try {
            Messaging.SendEmailResult[] result = Messaging.sendEmail(mails);
            system.debug('\n----result--'+result);
            if (result[0].success) {
                System.debug('\n--Email was successfully sent.');
            }
            else {
                System.debug('\n--Email transmission error :: '+ result[0].errors[0].message);
            }
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - sendEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    // for Getting isSubmitted field value to lock Credit Form
    @AuraEnabled
    public static boolean getIsSubmittedValue(Id contactId){
        try{
            boolean isSubmitted = false;
            List<Credit_Application_Form__c> creditInstance = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactId});
            
            if(!creditInstance.isEmpty() && (creditInstance[0].Application_Status__c == CreditApplicationContstants.Application_Status_Sent_To_Customer)) {
                creditInstance[0].Application_Status__c = CreditApplicationContstants.Application_Status_Opened_To_Customer;
                update creditInstance[0]; 
            }
            else if(!creditInstance.isEmpty() && 
                    creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_Status_Sent_To_Customer && 
                    creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_Status_Opened_To_Customer && 
                    creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_In_Progress) {
                        isSubmitted = true;
                    }
            return isSubmitted;
        }
        catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - getIsSubmittedValue',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Credit_Application_Form__c> getCreditAppValue(Id contactId){
        try {
            return CreditApplicationFormSelector.getCreditApplicationsData(new Set<Id>{contactId});
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - getIsSubmittedValue',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}