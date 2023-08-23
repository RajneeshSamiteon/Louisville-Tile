@isTest
public class CaseTriggerHelperTest {
    
    @testSetup
    public static void createTestData() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'Inside Sales');
            insert r;
            
            User user1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser0001@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                User_Branch__c='Fishers 055',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id
            );
            insert user1;
           
            UserRole b = new UserRole(DeveloperName = 'MyCustomRole1', Name = 'System Administration');
            insert b;
            
            
            user user2 = new User(Alias = 'alias',
                              Email = 'puser000@amamama.com',
                              Username = 'puser0001@amamama.com' + System.currentTimeMillis(),
                              emailencodingkey='UTF-8',
                              LastName = 'last',
                              languagelocalekey='en_US', 
                              localesidkey='en_US',
                              userroleid = b.Id, 
                              ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                              timezonesidkey='America/Los_Angeles', 
                              User_Branch__c='Fishers 055'   );
            insert user2;
            
            case test1=new case();
            test1.Status='New';
            test1.Description='testing';
            test1.Origin='Web';
            test1.Initial_Complaint_Category__c='Other';
            test1.OwnerId=user1.id;
            test1.Initial_Complaint_Details__c='details';
            insert test1;
            
            System.debug('the case : '+test1);
        }
    }
    
    @isTest
    public static void updateBranchTest(){
        Map<Id,Case> oldcaseById= new Map<Id,Case>();
        List<Case> cases= new List<Case>();
        
        //[Select Status,Description,Origin,Initial_Complaint_Category__c,OwnerId,Initial_Complaint_Details__c from Case where ]
        
        case users=[select id,AccountId,OwnerId,Status from case];
         oldcaseById.put(users.id,users);
        
        User user = [select id,Email from user where Email ='puser000@amamama.com'];
        
         users.OwnerId= user.id;
         cases.add(users);
        
        test.startTest();
        CaseTriggerHelper.beforeUpdateHandler(cases,oldcaseById);
        test.stopTest();
        
    }
}