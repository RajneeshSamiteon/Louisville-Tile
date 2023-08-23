@RestResource(UrlMapping='/kerridgeQuoteLineUpdate/*')
global class KerridgeQuotesLineUpdateRestAPI {
    @HttpPost
    global static void updateKerridgeQuotesLineUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        String conId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Kerridge_Quote_Line__c result = [SELECT Id,Name,Unit_Price__c,Product_Name__c,Quantity__c,QUOTE__c
                                         FROM Kerridge_Quote_Line__c WHERE  id = :conId];
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            List<Kerridge_Quote_Line__c> lstKOrderLine = new List<Kerridge_Quote_Line__c>();
            lstKOrderLine.clear();
            for(KerridgeOrdersRestAPIPayLoad.kerridgeQuotesLine  data : respWrapper.kerridgeQuotesLine){
                result.Name=data.kerridgeQuoteLineName;
                result.Unit_Price__c=data.listPrice;
                result.Product_Name__c=data.productName;
                result.Quantity__c=data.quantity;
                result.QUOTE__c=data.quote;
                lstKOrderLine.add(result);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrderLine.size()>0){
                update lstKOrderLine;
                jsonGen.writeStartArray();
                for(Kerridge_Quote_Line__c kQuote :lstKOrderLine){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('Kerridge QuoteLine Name',kQuote.Name);
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