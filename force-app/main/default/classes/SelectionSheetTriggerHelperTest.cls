@isTest
public class SelectionSheetTriggerHelperTest {
    @isTest
    public static void getselectionSheetLineItemstest(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
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
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id = Test.getStandardPricebookId(),
                                                isActive=true);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        
        Selection_Sheet__c sheet = new Selection_Sheet__c();
        sheet.Status__c ='Sold';
        sheet.Product_name__c ='BXCDXXX';
        sheet.SS_Line_Number__c ='11';
        sheet.Name ='sheet1';
        sheet.Quantity__c='2';
        sheet.Opportunity__c = opp.Id;
        selectionsheets.add(sheet);
        test.startTest();
        SelectionSheetTriggerHelper.isbeforeInsert(selectionsheets);
        test.stopTest();
        for(Selection_Sheet__c shet:selectionsheets){
            setOfIds.add(shet.id);
        }
        List<Selection_Sheet__c> sheet1=[select ID,Product_not_found__c from Selection_Sheet__c where ID IN:setOfIds];
        for(Selection_Sheet__c selectionsheet:sheet1){
            System.assertEquals(false, selectionsheet.Product_not_found__c);
        }
    }
    
    @isTest
    public static void productInsertInOpportunityLineItemTest(){       
        
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Product2 pro2 = new Product2();
        pro2.Name='BXCDXXX';
        pro2.IsActive=true;
        pro2.Dancik_Item__c='pro2';
        pro2.isActive=true;
        insert pro2;
        System.debug('pro2----'+pro2);
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        opp.Pricebook2Id=Test.getStandardPricebookId();
        insert opp;
        System.debug('opp-----'+opp);
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        insert sheet;
        selectionsheets.add(sheet);
       
        //Selection_Sheet__c selectionsheet=[select id,name,Status__c,Opportunity__c from Selection_Sheet__c where Opportunity__c=:sheet.Opportunity__c];
      
        test.startTest();
        SelectionSheetTriggerHelper.productInsertInOpportunityLineItem(selectionsheets);
         OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,Selection_Sheet__c=sheet.id, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        test.stopTest();
        
        
    }
    
    @isTest
    public static void productUpdateInOpportunityLineItemTest(){ 
        Map<Id,Selection_Sheet__c> selectionSheetbyId = new Map<Id,Selection_Sheet__c>();
        Map<Id,Selection_Sheet__c> selectionSheetbyIdOld = new Map<Id,Selection_Sheet__c>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        sheet.unique_key_selection__c='xxxx';
        insert sheet;
        selectionSheetbyIdOld.put(sheet.id,sheet);
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,Selection_Sheet__c=sheet.id, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        Selection_Sheet__c sheet1=[select Id,Name,Quantity__c,Opportunity__c,Product__c,unique_key_selection__c from Selection_Sheet__c where id=:sheet.Id];
        sheet1.Quantity__c='11';
        update sheet1;
        selectionSheetbyId.put(sheet1.Id,sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.productUpdateInOpportunityLineItem(selectionSheetbyId,selectionSheetbyIdOld);
        test.stopTest();
    }
    
    
    
    
    
    @isTest
    public static void selectionSheetsAfterInsertTest1(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        insert sheet;
        selectionsheets.add(sheet);
        //insert selectionsheets;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,Product2Id=sheet.Product__c,Selection_Sheet__c=sheet.Id, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Sold');
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest2(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Order';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        insert selectionsheets;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,Selection_Sheet__c=selectionsheets[0].Id, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'On Order');
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest3(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Inquiry/Planning';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        insert selectionsheets;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,Selection_Sheet__c=selectionsheets[0].Id, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Inquiry/Planning');
    }
  /*  
    @isTest
    public static void selectionSheetsAfterInsertTest4(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
            pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                     isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Order';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Sold';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        
        selectionsheets.add(sheet1);
       
        test.startTest();
         insert selectionsheets;
        
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Selection_Sheet__c=selectionsheets[0].Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pricebookEntrys[0].id);
            opLineItem.add(OPplineitem2);
                        OpportunityLineItem OPplineitem3 = new OpportunityLineItem (Selection_Sheet__c=selectionsheets[1].Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pricebookEntrys[1].id);
            opLineItem.add(OPplineitem3);
        insert opLineItem;
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
        
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest5(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
            pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                     isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        
        selectionsheets.add(sheet1);
        insert selectionsheets;
        for(PricebookEntry pb:pricebookEntrys){
            Integer i=0;
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Selection_Sheet__c=selectionsheets[i].Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
            opLineItem.add(OPplineitem2);
            i++;
        }
        insert opLineItem;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'On Order');
        test.stopTest();
        
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest6(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
            pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                     isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Inquiry/Planning';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        
        selectionsheets.add(sheet1);
        insert selectionsheets;
      for(PricebookEntry pb:pricebookEntrys){
            Integer i=0;
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Selection_Sheet__c=selectionsheets[i].Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
            opLineItem.add(OPplineitem2);
            i++;
        }
                insert opLineItem;
        test.startTest();
       
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
        
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest7(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        products.add(pro2);
        Product2 pro3 = new Product2(Name='BXCDEF',isActive=true, Dancik_Item__c='test3');
        products.add(pro3);
        insert products;
        
        for(Product2 pro:products){
            PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                    isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        

        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
       // sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        
        selectionsheets.add(sheet1);
        
        Selection_Sheet__c sheet2=new Selection_Sheet__c();
        sheet2.Status__c='Inquiry/Planning';
        sheet2.SS_Line_Number__c='11';
        sheet2.Name='sheet2';
        sheet2.Opportunity__c=opp.Id;
        sheet2.Product__c=pricebookEntrys[2].Product2Id;
        sheet2.Quantity__c='22';
        
        selectionsheets.add(sheet2);
        insert selectionsheets;
        for(PricebookEntry pb:pricebookEntrys){
            Integer i=0;
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Selection_Sheet__c=selectionsheets[i].Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=pb.UnitPrice,PriceBookEntryId=pb.id);
            opLineItem.add(OPplineitem2);
            i++;
        }
                insert opLineItem;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
        
    }
    */
    @isTest
    public static void selectionSheetsAfterInsertTest8(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        products.add(pro2);
        Product2 pro3 = new Product2(Name='BXCDEF',isActive=true, Dancik_Item__c='test3');
        products.add(pro3);
        insert products;
        
        for(Product2 pro:products){
            PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                    isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=products[0].id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=products[0].id;
        sheet1.Quantity__c='22';
        
        selectionsheets.add(sheet1);
        
        Selection_Sheet__c sheet2=new Selection_Sheet__c();
        sheet2.Status__c='Inquiry/Planning';
        sheet2.SS_Line_Number__c='11';
        sheet2.Name='sheet2';
        sheet2.Opportunity__c=opp.Id;
        sheet2.Product__c=products[0].id;
        sheet2.Quantity__c='22';
        
        selectionsheets.add(sheet2);
        insert selectionsheets;
        System.debug('selectionsheets-------'+selectionsheets);
        for(Selection_Sheet__c pb:selectionsheets){
            Integer i=0;
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Selection_Sheet__c=pb.Id,Quantity=2, OpportunityId=opp.Id,UnitPrice=0.02,PriceBookEntryId=pricebookEntrys[0].id);
            opLineItem.add(OPplineitem2);
            i++;
        }
               
        test.startTest();
         insert opLineItem;
        System.debug('opLineItem-----'+opLineItem);
        //insert opLineItem;
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        
        test.stopTest();
    }
    @isTest
    public static void updateSelectionSheetStatus1(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Inquiry - Planning';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    @isTest
    public static void updateSelectionSheetStatus2(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='On Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    
    @isTest
    public static void updateSelectionSheetStatus3(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Completed';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    @isTest
    public static void updateSelectionSheetStatus4(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Partial Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    @isTest
    public static void updateSelectionSheetStatus5(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Finalized';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    @isTest
    public static void updateSelectionSheetStatus6(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Waiting on Design Appointment';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    @isTest
    public static void updateSelectionSheetStatus7(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='On Hold';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        //sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        test.startTest();
        SelectionSheetTriggerHelper.updateSelectionSheetStatus(selectionsheets);
        
        test.stopTest();  
    }
    
    
    
}