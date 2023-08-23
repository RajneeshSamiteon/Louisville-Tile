@RestResource(UrlMapping='/KerridgeQuoteUpdate/*')
global class KerridgeQuoteUpdateRestAPI {
    @HttpPost
    global static void updateKerridgeQuoteUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        String conId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Kerridge_Quote__c result = [SELECT Id,Name,Date_created_in_CQM__c,Date_last_modified_in_CQM__c,Kerridge_Quote__c,
                                    Sequence_to_show_multiple_quotes__c,Opportunity_Id__c,Expiration_date__c,Key_Id__c
                                    FROM Kerridge_Quote__c WHERE id = :conId];
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            List<Kerridge_Quote__c> lstKOrderLine = new List<Kerridge_Quote__c>();
            lstKOrderLine.clear();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeQuote  data : respWrapper.KerridgeQuote){
                result.Name=data.kerridgeQuoteName;
                result.Date_created_in_CQM__c=data.dateCreatedInCqm;
                result.Date_last_modified_in_CQM__c=data.dateLastModifiedInCqm;  
                result.Kerridge_Quote__c=data.kerridgeQuoteNumber;
                result.Sequence_to_show_multiple_quotes__c=data.sequenceToShowMultipleQuotes;
                result.Expiration_date__c= data.expirationDate;
                result.Key_Id__c = data.KeyId;
                lstKOrderLine.add(result);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrderLine.size()>0){
                update lstKOrderLine;
                jsonGen.writeStartArray();
                for(Kerridge_Quote__c kQuote :lstKOrderLine){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('Kerridge Quote Name',kQuote.Name);
                    jsonGen.writeStringField('Salesforce_Id',kQuote.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                lstKOrderLine.clear();
            } 
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            res.responseBody = Blob.valueOf(jsonData); 
        }else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty');
        }
        
    }
    
}