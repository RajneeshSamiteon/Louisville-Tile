@RestResource(UrlMapping='/kerridgeOrders/*')
global class KerridgeOrdersRestAPI {
    
    @HttpPost
    global static void creatingKerridgeOrders(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            System.debug('respWrapper'+respWrapper);
            
            
            List<String> lstOppId = new List<String>();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeOrders  data : respWrapper.kerridgeOrders){
                lstOppId.add(data.SalesforceId);
            }
            Opportunity opp = [select id from Opportunity where Opportunity_ID_for_Kerridge__c IN : lstOppId];
            
            List<Kerridge_Order__c> lstkOrders = new List<Kerridge_Order__c>();
            lstkOrders.clear();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeOrders  data : respWrapper.kerridgeOrders){
                
                Kerridge_Order__c kOrder = new Kerridge_Order__c();
                kOrder.Name=data.orderName;
                kOrder.OpportunityId__c =opp.id;
                kOrder.Kerridge_Account__c=data.kerridgeAccount;
                kOrder.Kerridge_Order__c =data.KerridgeOrder;
                kOrder.Kerridge_Quote__c=data.kerridgeQuote;
                kOrder.status__c=data.status;
                kOrder.Date_Created_In_Kerridge__c= data.dateCreatedInKerridge;
                kOrder.Date_last_modified_in_Kerridge__c=data.DateLastModifiedInKerridge;
                kOrder.Ship_Date__c =data.shipDate;
                kOrder.Order_Start_Date__c=data.orderStartDate;
                kOrder.H_Reference__c = data.HReference;
                kOrder.Selection_Sheet_ID__c = data.SelectionSheetId;
                lstkOrders.add(kOrder);      
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstkOrders.size()>0){
                insert lstkOrders;            
                jsonGen.writeStartArray();
                for(Kerridge_Order__c kOrder :lstkOrders){  
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('order_Name',kOrder.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrder.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                lstkOrders.clear();
            }
            String jsonData = jsonGen.getAsString();
            
            res.responseBody = Blob.valueOf(jsonData);        
        }
        else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty'); 
        }
    }
    
}