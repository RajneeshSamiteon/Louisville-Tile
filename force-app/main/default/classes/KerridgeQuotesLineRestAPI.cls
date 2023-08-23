@RestResource(UrlMapping='/kerridgeQuoteLine/*')
global class KerridgeQuotesLineRestAPI {
    
    @HttpPost
    global static void creatingKerridgeQuotesLine(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        System.debug('req'+req.requestBody.toString());
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            
            system.debug('respWrapper'+respWrapper);
            List<Kerridge_Quote_Line__c> lstKOrderQuoteLine = new List<Kerridge_Quote_Line__c>();
            lstKOrderQuoteLine.clear();
            List<String> lstId = new List<String>();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeQuotesLine  data : respWrapper.KerridgeQuotesLine){
                Kerridge_Quote_Line__c objKOrQuoteLine = new Kerridge_Quote_Line__c();
                objKOrQuoteLine.Name = data.kerridgeQuoteLineName;
                objKOrQuoteLine.Unit_Price__c=data.listPrice;
                objKOrQuoteLine.Product_Name__c=data.productName;
                objKOrQuoteLine.Quantity__c=data.quantity;
                objKOrQuoteLine.QUOTE__c=data.quote;
                lstKOrderQuoteLine.add(objKOrQuoteLine);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrderQuoteLine.size()>0){
                insert lstKOrderQuoteLine;
                jsonGen.writeStartArray();
                for(Kerridge_Quote_Line__c kOrderQuoteLine :lstKOrderQuoteLine){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('kerridgeQuoteLine',kOrderQuoteLine.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrderQuoteLine.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                lstKOrderQuoteLine.clear();
            }
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            
            res.responseBody = Blob.valueOf(jsonData);
        }else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty');
        }
    }
}