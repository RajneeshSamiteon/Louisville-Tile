@RestResource(UrlMapping='/KerridgeOrdersLineUpdate/*')
global class KerridgeOrdersLineUpdateRestAPI {
    @HttpPost
    global static void updateSelectionSheet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        String conId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Kerridge_Order_Line__c result = [SELECT Id,Name,Kerridge_Order_Id__c,Kerridge_Order__c,Quantity__c,
                                         Line_description__c,Line_ship_date__c,Product_Name__c,H_Reference__c,D_Line__c,Format_Status__c
                                         FROM Kerridge_Order_Line__c WHERE id = :conId];
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            List<Kerridge_Order_Line__c> lstKOrderLine = new List<Kerridge_Order_Line__c>();
            lstKOrderLine.clear();
            for(KerridgeOrdersRestAPIPayLoad.KerridgeOrdersLine  data : respWrapper.KerridgeOrdersLine){
                
                result.Name = data.kerridgeOrderLineName;
                result.Kerridge_Order__c =data.kerridgeOrder;
                result.Quantity__c =data.quantity;
                result.Line_description__c = data.LineDescription;
                result.Line_ship_date__c=data.lineShipDate;
                result.Product_Name__c =data.productName;
                result.Unit_Price__c = data.listPrice;
                result.H_Reference__c=data.HReference;
                result.D_Line__c=data.DLine;
                result.Format_Status__c=data.formatStatus;
                lstKOrderLine.add(result);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrderLine.size()>0){
                update lstKOrderLine;
                jsonGen.writeStartArray();
                for(Kerridge_Order_Line__c kOrderLine :lstKOrderLine){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('Kerridge Order Line Name',kOrderLine.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrderLine.Id);
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