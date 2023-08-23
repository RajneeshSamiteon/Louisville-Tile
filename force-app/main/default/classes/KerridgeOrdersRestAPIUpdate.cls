@RestResource(UrlMapping='/kerridgeOrdersUpdate/*')
global class KerridgeOrdersRestAPIUpdate {
    @HttpPost
    global static void UpdatingKerridgeOrders(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String strReq = req.requestBody.toString();
        System.debug('req'+req.requestBody.toString());
        
        String[] address     = strReq.split(':');        
        
        String conId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('conId'+conId);
        Kerridge_Order__c lstResult = [SELECT Id,Name,Kerridge_Account__c,Kerridge_Order__c,Kerridge_Quote__c,status__c,Date_Created_In_Kerridge__c,Date_last_modified_in_Kerridge__c,
                                       Ship_Date__c,Order_Start_Date__c,H_Reference__c,Selection_Sheet_ID__c FROM Kerridge_Order__c WHERE Id = :conId];
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            List<Kerridge_Order__c> lstKOrders = new List<Kerridge_Order__c>();
            lstKOrders.clear();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeOrders  data : respWrapper.KerridgeOrders){
                lstResult.Name=data.orderName;
                //lstResult.OpportunityId__c= data.SalesforceId;
                lstResult.Kerridge_Account__c=data.kerridgeAccount;
                lstResult.Kerridge_Order__c =data.KerridgeOrder;
                lstResult.Kerridge_Quote__c=data.kerridgeQuote;
                lstResult.status__c=data.status;
                lstResult.Date_Created_In_Kerridge__c= data.dateCreatedInKerridge;
                lstResult.Date_last_modified_in_Kerridge__c=data.DateLastModifiedInKerridge;
                lstResult.Ship_Date__c =data.shipDate;
                lstResult.Order_Start_Date__c=data.orderStartDate;
                lstResult.H_Reference__c=data.HReference;
                lstResult.Selection_Sheet_ID__c=data.SelectionSheetId;
                
                lstKOrders.add(lstResult);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrders.size()>0){
                update lstKOrders;
                //  jsonGen.writeStartObject();
                //  jsonGen.writeFieldName('kerridgeOrderLine');
                jsonGen.writeStartArray();
                for(Kerridge_Order__c kOrder :lstKOrders){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('kerridge Order Name',kOrder.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrder.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                // jsonGen.writeEndObject();
                lstKOrders.clear();
                
            } 
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            res.responseBody = Blob.valueOf(jsonData); 
        }else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty');
        }
        
    }
}