@isTest
public class ContactTriggerHelperTest {
@isTest
    public  static void updateBranchtest(){
        Map<Id,Contact> oldContactById= new Map<Id,Contact>(); 
        List<Contact> contacts= new List<Contact>();
        Branch__c branch= new Branch__c();
        branch.Name='Fishers 055';
        insert branch;
        Account acc= new Account();
        acc.Name='test';
        acc.Primary_Branch__c=branch.id;
        acc.Account_Category__c='Architect';
        acc.Account_Tier__c='A - Preserve';
        insert acc;
        Account acc1= new Account();
        acc1.Name='test';
        acc.Primary_Branch__c=branch.id;
        acc1.Account_Category__c='Architect';
        acc1.Account_Tier__c='A - Preserve';
        insert acc1;
        Contact con=new Contact();
        con.LastName='TestCon';
        con.AccountId=acc.id;
        con.Roles__c='Architect';
        insert con;
        oldContactById.put(con.id,con);
        Contact cont=[select id,AccountId from Contact where Id=:con.id];
        cont.AccountId=acc1.id;
        contacts.add(cont);
        update contacts;
        test.startTest();
        ContactTriggerHelper.beforeUpdateHandler(contacts,oldContactById);
        test.stopTest();
    }
}