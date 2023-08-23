@isTest
public class DataFactoryTest {
    @testSetup
    public static void testSetup(){
        Account acc = new Account();
        acc.Name = 'test data';
        insert acc;
    }
    
    @isTest
    public static void testgetFieldIdFromsObjects(){
        Set<Id> ids = new Set<Id>();
        List<Account> acc = [SELECT name FROM Account LIMIT 1];
        DataFactory.getFieldIdFromsObjects(acc,'Id');
        DataFactory.getsObjectsByFieldId(acc,'Id');
        DataFactory.strigToListOfSobject(acc,'Id');
        DataFactory.getSobjectByRecordTypeId(acc,'Id');
        DataFactory.setIdbyString(acc,'Id');
        DataFactory.getSobjectByRecordTypestring(acc,'Id');
    }
    
}