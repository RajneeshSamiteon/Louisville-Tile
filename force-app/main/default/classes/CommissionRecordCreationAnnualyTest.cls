@isTest
public class CommissionRecordCreationAnnualyTest {
    @testSetup
    public static void createData(){
        List<RecordType> commissionMasterRecordtype = new List<RecordType>([Select Id,Name from RecordType Where SobjectType='Commission_Master__c']);
        List<commission_master__c> commissionMasters =  new List<commission_master__c>();
        List<String> PROFILENAMES = new List<string>{'SALES REPRESENTATIVE - A&D','SALES REPRESENTATIVE - DEALER','SALES REPRESENTATIVE - CONTRACTOR'};
            integer j=0;
        for(RecordType recordTypeForProfile : commissionMasterRecordtype){
            commission_master__c commissionmasterInstance = new commission_master__c();
            commissionmasterInstance.recordTypeId = recordTypeForProfile.id;
            commissionmasterInstance.Commission_percent_under_target__c =0;
            commissionmasterInstance.Target_for_EoY_adjustment__c =0;
            commissionmasterInstance.Percent_below_retroactive_EoY_Adj__c =0;
            commissionmasterInstance.Commercial_without_Opportunity__c =0;
            commissionmasterInstance.name = '2022-'+PROFILENAMES[j]+'-Commission Master';
            commissionMasters.add(commissionmasterInstance);   
            j+=1;
        }
        system.debug('Master'+JSON.serialize(commissionMasters));
        insert commissionMasters;
        List<User> users = new List<User>();
        for(Integer i=0;i<3;i++) {
            User user = new User();
            user.LastName = 'Singh'+i;
            user.Alias = 'singh'+i;
            user.Email = 'raj.singh@asdf.com';
            user.Username = 'raj'+i+'.singh@asdf.com';
            user.ProfileId = [SELECT Id FROM Profile WHERE Name =: PROFILENAMES[i] LIMIT 1].Id;
            user.TimeZoneSidKey = 'GMT';
            user.LanguageLocaleKey = 'en_US';
            user.EmailEncodingKey = 'UTF-8';
            user.LocaleSidKey = 'en_US';
            users.add(user);
        }
        insert users;
    }
    @isTest
    public static void startTest(){
        test.startTest();
        CommissionRecordCreationAnnualy.createRecord(new Map<string,integer>{'2023' =>12});
        test.stopTest();
    }
}