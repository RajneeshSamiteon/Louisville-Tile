@RestResource(UrlMapping='/kerridgeQuote/*')
global class KerridgeQuoteRestAPI {
    
    @HttpPost
    global static void creatingKerridgeQuote(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        System.debug('req'+req.requestBody.toString());
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            
            List<Kerridge_Quote__c> lstKOrderQuote = new List<Kerridge_Quote__c>();
            lstKOrderQuote.clear();
            List<String> lstId = new List<String>();

            List<String> lstOppId = new List<String>();
            for(KerridgeOrdersRestAPIPayLoad.kerridgeQuote  data : respWrapper.kerridgeQuote){
                lstOppId.add(data.SalesforceId);
            }
            Opportunity opp = [select id from Opportunity where Opportunity_ID_for_Kerridge__c IN : lstOppId];
            
            for(KerridgeOrdersRestAPIPayLoad.kerridgeQuote  data : respWrapper.kerridgeQuote){
                Kerridge_Quote__c objKOrQuote = new Kerridge_Quote__c();
                objKOrQuote.Opportunity_Id__c = opp.Id;
                objKOrQuote.Name = data.kerridgeQuoteName;
                objKOrQuote.Date_created_in_CQM__c=data.dateCreatedInCqm;
                objKOrQuote.Date_last_modified_in_CQM__c=data.dateLastModifiedInCqm;
                objKOrQuote.Kerridge_Quote__c=data.kerridgeQuoteNumber;
                objKOrQuote.Sequence_to_show_multiple_quotes__c=data.sequenceToShowMultipleQuotes;
                objKOrQuote.Expiration_date__c= data.expirationDate;
              	objKOrQuote.Key_Id__c = data.KeyId;
                
                lstKOrderQuote.add(objKOrQuote);
            }
            JSONGenerator jsonGen = JSON.createGenerator(true);
            if(lstKOrderQuote.size()>0){
                insert lstKOrderQuote;
                jsonGen.writeStartArray();
                for(Kerridge_Quote__c kOrderQuote :lstKOrderQuote){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('kerridgeQuote',kOrderQuote.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrderQuote.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                lstKOrderQuote.clear();
            }       
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            
            res.responseBody = Blob.valueOf(jsonData);
        }else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty');
        }
    }
}