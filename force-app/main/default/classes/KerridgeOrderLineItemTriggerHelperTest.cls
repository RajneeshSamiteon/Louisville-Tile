@istest
public class KerridgeOrderLineItemTriggerHelperTest {
@istest
    public static void getkerridgeOrderLineItemsTest(){
        List<Kerridge_Order_Line__c> k_OrderLineitems=new List<Kerridge_Order_Line__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        set<id> setOfIds=new set<id>();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Product2 pro2 = new Product2();
        pro2.Name='BXCDXXX';
        pro2.IsActive=true;
        pro2.Dancik_Item__c='pro2';
        insert pro2;
        System.debug('pro2----'+pro2);
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        for(Integer i=0;i<6;i++){
            Kerridge_Order_Line__c sheet = new Kerridge_Order_Line__c();
            sheet.Product_name__c ='BXCDXXX';
            sheet.Kerridge_Order__c='demo';
            sheet.Name ='sheet1';
            k_OrderLineitems.add(sheet);
        }
        insert k_OrderLineitems;
        for(Kerridge_Order_Line__c shet:k_OrderLineitems){
            setOfIds.add(shet.id);
        }
        test.startTest();
        KerridgeOrderLineItemTriggerHelper.isbeforeInsert(k_OrderLineitems);
        test.stopTest();
        List<Kerridge_Order_Line__c> sheet=[select ID,Product_not_found__c,Kerridge_Order__c from Kerridge_Order_Line__c where ID IN:setOfIds];
        for(Kerridge_Order_Line__c selectionsheet:sheet){
            System.assertEquals(false, selectionsheet.Product_not_found__c);
        }
    }
    
    
}