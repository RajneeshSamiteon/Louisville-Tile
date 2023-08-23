public class SelectionSheetTriggerHelper {
    
    public static void isbeforeInsert(List<Selection_Sheet__c> selectionSheet_lineItems){
        getselectionSheetLineItems(selectionSheet_lineItems);
    }
    
    public static void updateSelectionSheetStatus(List<Selection_Sheet__c> selectionSheet_lineItems){
        
        for(Selection_Sheet__c sheet:selectionSheet_lineItems){
            if((sheet.Status__c).trim()=='Inquiry - Planning'){
                sheet.Status__c='Inquiry/Planning';
            }else if((sheet.Status__c).trim()=='On Order'){
                sheet.Status__c='Order';
            }else if((sheet.Status__c).trim()=='Completed'){
                sheet.Status__c='Sold';
            }else if((sheet.Status__c).trim()=='Partial Order'){
                sheet.Status__c='Order';
            }else if((sheet.Status__c).trim()=='Finalized'){
                sheet.Status__c='Inquiry/Planning';
            }else if((sheet.Status__c).trim()=='Waiting on Design Appointment'){
                sheet.Status__c='Inquiry/Planning';
            }else if((sheet.Status__c).trim()=='On Hold'){
                sheet.Status__c='Inquiry/Planning';
            }
            
        }
    }
    
    public static void selectionSheetsAfterInsert(List<Selection_Sheet__c> sheets){
        set<Id> opportunityIds=new set<Id>();
        set<Id> selectionsheetIdByOppLineItem=new set<Id>();
        Map<Id,opportunityLineItem> mapOfProductIdAndopportunityLineItem=new Map<Id,opportunityLineItem>();
        Map<Id,Selection_Sheet__c> mapOfProductIdAndSelectionSheet=new Map<Id,Selection_Sheet__c>();
        Map<Id,set<String>> mapOfOpportunityIdAndSelectionSheetStatus=new Map<Id,set<String>>();
        Map<Id,Opportunity> MapOfselectsheetsAndOpportunity=new Map<Id,Opportunity>();
        Map<Id,List<Selection_Sheet__c>> mapOfOppIdAndSSsize= new Map<Id,List<Selection_Sheet__c>>();
        Id retailOpportunityRecordTypeId = RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');

        Map<Id,List<opportunityLineItem>> mapOfOppIdAndOppLineitems= new Map<Id,List<opportunityLineItem>>();
        Integer selectionsheetSize=0;
        for(Selection_Sheet__c selectionsheet:sheets){
            if(selectionsheet.Status__c !=null && selectionsheet.Opportunity__c != null){
                opportunityIds.add(selectionsheet.Opportunity__c);
            }
        }
        Map<Id,Opportunity> opprtunityById =  new  Map<Id,Opportunity>([SELECT id,Name,RecordTypeId
                                                                        FROM Opportunity WHERE
                                                                        Id IN:opportunityIds]);
        opportunityIds=new set<Id>();
        for(Selection_Sheet__c selectionsheet:sheets){
            if(selectionsheet.Status__c !=null && 
               selectionsheet.Opportunity__c != null &&
               opprtunityById.get(selectionsheet.Opportunity__c).RecordTypeId == retailOpportunityRecordTypeId){                
                   opportunityIds.add(selectionsheet.Opportunity__c);
               }
        }
        List<opportunityLineItem> opLineItems=opportunityLineItemSelector.getOpportunityLineItemByOpportunity(opportunityIds);
       // System.debug('opLineItems-----'+opLineItems.size());
        for(opportunityLineItem opLine:opLineItems){
            selectionsheetIdByOppLineItem.add(opLine.Selection_Sheet__c);
        }
        //System.debug('selectionsheetIdByOppLineItem----'+selectionsheetIdByOppLineItem);
        List<Selection_Sheet__c> selectionSheets=SelectionSheetSelector.getSelectionSheetById(selectionsheetIdByOppLineItem);
        
        for(Selection_Sheet__c sheet:selectionSheets){
            if(mapOfOpportunityIdAndSelectionSheetStatus.containskey(sheet.Opportunity__c)){
                set<String> sheetStatus=mapOfOpportunityIdAndSelectionSheetStatus.get(sheet.Opportunity__c);
                sheetStatus.add(sheet.Status__c);
                mapOfOpportunityIdAndSelectionSheetStatus.put(sheet.Opportunity__c,sheetStatus);
            }else{
                mapOfOpportunityIdAndSelectionSheetStatus.put(sheet.Opportunity__c,new set<String> {sheet.Status__c});
            }
        }
        
        for(Id opId:mapOfOpportunityIdAndSelectionSheetStatus.keyset()){
            
            if( mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size() == 1){
                if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Order')){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='On Order';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                }else if(String.valueOf(mapOfOpportunityIdAndSelectionSheetStatus.get(opId))=='{Sold}'){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='Sold';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                    
                }else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Inquiry/Planning')){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='Inquiry/Planning';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                }
            }
            else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==2 && (mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Order') && mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Sold'))){
                
                Opportunity opp = new Opportunity();
                opp.Id=opId;
                opp.StageName='On Order';
                MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                
            }else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==2 && mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Inquiry/Planning')){
                Opportunity opp = new Opportunity();
                opp.Id=opId;
                opp.StageName='Partial Order';
                MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
            }
            else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==3){
                Opportunity opp = new Opportunity();
                opp.Id=opId;
                opp.StageName='Partial Order';
                MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
            }
            
        }
        
        update MapOfselectsheetsAndOpportunity.values(); 
        
    }  
    
    public static void getselectionSheetLineItems(List<Selection_Sheet__c> selectionSheet_lineItems){
        List<String> selectionSheetLineItemProductName= new List<String>();
        List<Selection_Sheet__c> K_orderItem=new List<Selection_Sheet__c>();
        Map<String,Id> mapOFIdAndProduct=new Map<String,Id>();
        for(Selection_Sheet__c items:selectionSheet_lineItems){
            if(items.Product_name__c!=null){
                selectionSheetLineItemProductName.add(items.Product_name__c); 
            }
        }
        List<Product2> products = ProductSelector.fetchProducts(selectionSheetLineItemProductName);
        for(Product2 prod:products){
            mapOFIdAndProduct.put(prod.Name,prod.id);
        }
        for(Selection_Sheet__c items:selectionSheet_lineItems){
            if(mapOFIdAndProduct.containsKey(items.Product_name__c)){
                items.Product__c= mapOFIdAndProduct.get(items.Product_name__c);
            }       
        }
    }
    
    
    public static void productInsertInOpportunityLineItem(List<Selection_Sheet__c> selectionSheets){
        List<OpportunityLineItem> opportunityLineItemsToBeInsert=new List<OpportunityLineItem>();
        List<PricebookEntry> priceBooks=new List<PricebookEntry>();
        List<Selection_Sheet__c> selectionSheetsforInsert=new List<Selection_Sheet__c>();
        Map<Id,List<Selection_Sheet__c>> MapOfListOfSelectionSheetByProductId=new Map<Id,List<Selection_Sheet__c>>();
        Map<Id,Id> mapOfPricebookIdByOppId=new Map<Id,Id>();
        Map<Id,List<PricebookEntry>> mapOfPricebooksByOppId=new Map<Id,List<PricebookEntry>>();
        Map<Id,Id> mapOfPricebookByOpportunityId=new Map<Id,Id>();
        Map<Id,PricebookEntry> mapOfPricebookEntryByProductId=new Map<Id,PricebookEntry>();
        Id recordTypeId = RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');
        
        Set<Id> productIds=new Set<Id>();
        Set<Id> pricebookIds=new Set<Id>();
        List<PricebookEntry> customPriceBookEntry = new List<PricebookEntry>();
        set<Id> OppIds=new set<Id>();
        for(Selection_Sheet__c sheet:selectionSheets){
            if(sheet.Product__c !=null){
                if(MapOfListOfSelectionSheetByProductId.containskey(sheet.Product__c)){
                    List<Selection_Sheet__c> sheets=MapOfListOfSelectionSheetByProductId.get(sheet.Product__c);
                    sheets.add(sheet);
                }else{
                    MapOfListOfSelectionSheetByProductId.put(sheet.Product__c,new List<Selection_Sheet__c>{sheet});
                }
                
                OppIds.add(sheet.Opportunity__c);
            }
        }
        
        Map<Id,Opportunity> mapOfOpportunityBYId= new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesByIdsAndRecordId(OppIds,recordTypeId));
        //system.debug('mapOfOpportunityBYId-------'+mapOfOpportunityBYId);
        for(Opportunity opp:mapOfOpportunityBYId.values()){
            mapOfPricebookByOpportunityId.put(opp.Id,opp.Pricebook2Id);
            pricebookIds.add(opp.Pricebook2Id);
        }
        List<PricebookEntry> priceBooksForPriceBookEntry=PriceBookEntrySelector.getPriceBooksByProductIdsAndPricebookIds(MapOfListOfSelectionSheetByProductId.keySet(),pricebookIds);
        //System.debug('priceBooksForcheckStatnderPrice----'+priceBooksForPriceBookEntry);
        for(PricebookEntry pBook:priceBooksForPriceBookEntry){
            for(Selection_Sheet__c ssm:MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id)){
                if(mapOfOpportunityBYId.containsKey(ssm.Opportunity__c) &&
                   String.isNotBlank(ssm.Quantity__c) &&
                   decimal.valueof(ssm.Quantity__c)>0 && 
                   mapOfOpportunityBYId.get(ssm.Opportunity__c).Pricebook2Id ==  pBook.Pricebook2.Id){
                       OpportunityLineItem opLineItem=new OpportunityLineItem();
                       opLineItem.OpportunityId=ssm.Opportunity__c;
                       opLineItem.Product2Id=pBook.Product2Id;
                       opLineItem.Quantity= decimal.valueof(ssm.Quantity__c);
                       opLineItem.UnitPrice=pBook.UnitPrice;
                       opLineItem.PricebookEntryId=pBook.Id;
                       opLineItem.Selection_Sheet__c=ssm.Id;
                       opportunityLineItemsToBeInsert.add(opLineItem);
                       Selection_Sheet__c ss=new Selection_Sheet__c();
                       ss.Id=ssm.Id;
                       ss.Product_Added__c=true;
                       selectionSheetsforInsert.add(ss);
                   
                   }  
            }
            
        }
        
        if(!opportunityLineItemsToBeInsert.isEmpty()){
            insert opportunityLineItemsToBeInsert;
        }
        if(!selectionSheetsforInsert.isEmpty()){
            update selectionSheetsforInsert;
        }
    }
    
    public static void productUpdateInOpportunityLineItem(Map<Id,Selection_Sheet__c> selectionSheetbyId,Map<Id,Selection_Sheet__c> oldSelectionSheetById){
        List<OpportunityLineItem> opportunityLineItemsToBeUpdate=new List<OpportunityLineItem>();
        set<String> setOfUniqueKeys=new set<String>();
        Map<Id,PricebookEntry> mapOfPricebookByProductIdct=new Map<Id,PricebookEntry>();
        Set<Id> pricebookIds=new Set<Id>();
        Map<Id,Id> mapOfPricebookByOpportunityId=new Map<Id,Id>();
        Map<Id,list<OpportunityLineItem>> OpportunityLineItemsByProductId=new Map<Id,List<OpportunityLineItem>>();
        Map<Id,Selection_Sheet__c> SelectionSheetByProductIdwithUniqueKey=new Map<Id,Selection_Sheet__c>();
        Map<Id,List<Selection_Sheet__c>> MapOfListOfSelectionSheetByProductId=new Map<Id,list<Selection_Sheet__c>>(); 
        set<Id> OppIds=new set<Id>();
        set<Id> selectionsheetIds=new set<Id>();
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');
        for(Selection_Sheet__c sheet:selectionSheetbyId.values()){
            if(sheet.Product__c !=null && sheet.Quantity__c !=oldSelectionSheetById.get(sheet.id).Quantity__c){
                if(MapOfListOfSelectionSheetByProductId.containskey(sheet.Product__c)){
                    List<Selection_Sheet__c> sheets=MapOfListOfSelectionSheetByProductId.get(sheet.Product__c);
                    sheets.add(sheet);
                }else{
                    MapOfListOfSelectionSheetByProductId.put(sheet.Product__c,new List<Selection_Sheet__c>{sheet});
                }              
                OppIds.add(sheet.Opportunity__c);
                selectionsheetIds.add(sheet.Id);
            }
        }
        
        List<OpportunityLineItem> opportunityLineItemsToBeInsert=new List<OpportunityLineItem>();
        Map<Id,Opportunity> mapOfOpportunityBYId= new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesByIdsAndRecordId(OppIds,recordTypeId));
        for(OpportunityLineItem opLine:opportunityLineItemSelector.getOpportunityLineItemByselectionSheetId(selectionsheetIds)){
            if(OpportunityLineItemsByProductId.containskey(opLine.Product2Id)){
                List<OpportunityLineItem> lineItems=OpportunityLineItemsByProductId.get(opLine.Product2Id);
                lineItems.add(opLine);
            }else{
                OpportunityLineItemsByProductId.put(opLine.Product2Id,new List<OpportunityLineItem>{opLine});
            } 
        } 
        for(Opportunity opp:mapOfOpportunityBYId.values()){
            mapOfPricebookByOpportunityId.put(opp.Id,opp.Pricebook2Id);
            pricebookIds.add(opp.Pricebook2Id);
        }
        List<PricebookEntry> priceBooksForPriceBookEntry=PriceBookEntrySelector.getPriceBooksByProductIdsAndPricebookIds(MapOfListOfSelectionSheetByProductId.keySet(),pricebookIds);      
        for(PricebookEntry pb:priceBooksForPriceBookEntry){
            mapOfPricebookByProductIdct.put(pb.id,pb);
        }
        
        
        map<Id,OpportunityLineItem> mapOfOpportunityLineItemByIdToBeInsert=new map<Id,OpportunityLineItem>();
        for(Id productId:MapOfListOfSelectionSheetByProductId.keySet()){
            for(Selection_Sheet__c sheet:MapOfListOfSelectionSheetByProductId.get(productId)){
                for(OpportunityLineItem lineItem:OpportunityLineItemsByProductId.get(sheet.Product__c)){
                    
                    OpportunityLineItem opLineItem=new OpportunityLineItem();
                    if(lineItem.Selection_Sheet__c==null){
                        opLineItem.Selection_Sheet__c=sheet.id; 
                    }
                    opLineItem.Id=lineItem.id;
                    opLineItem.Quantity = decimal.valueof(sheet.Quantity__c);
                    
                    mapOfOpportunityLineItemByIdToBeInsert.put(opLineItem.Id, opLineItem);
                }    
            }
            
        } 
        
        update mapOfOpportunityLineItemByIdToBeInsert.values();
        
    }
}