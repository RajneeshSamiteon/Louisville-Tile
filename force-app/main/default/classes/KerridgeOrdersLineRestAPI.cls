@RestResource(UrlMapping='/kerridgeOrdersLine/*')
global class KerridgeOrdersLineRestAPI {
    
    @HttpPost
    global static void creatingKerridgeOrdersLine(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        System.debug('req'+req.requestBody.toString());
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            System.debug('respWrapper'+respWrapper);
            
            List<Kerridge_Order_Line__c> lstKOrderLine = new List<Kerridge_Order_Line__c>();
            lstKOrderLine.clear();
            for(KerridgeOrdersRestAPIPayLoad.kerridgeOrdersLine  data : respWrapper.kerridgeOrdersLine){
                Kerridge_Order_Line__c objKOrLine = new Kerridge_Order_Line__c();
                objKOrLine.Name = data.kerridgeOrderLineName;
                objKOrLine.Kerridge_Order_Id__c = data.KerridgeOrderId;
                objKOrLine.Kerridge_Order__c =data.kerridgeOrder;
                objKOrLine.Quantity__c =data.quantity;
                objKOrLine.Line_description__c = data.LineDescription;
                objKOrLine.Line_ship_date__c=data.lineShipDate;
                objKOrLine.Product_Name__c =data.productName;
                objKOrLine.Unit_Price__c = data.listPrice;
                objKOrLine.H_Reference__c= data.HReference;
                objKOrLine.D_Line__c= data.DLine;
                objKOrLine.Format_Status__c= data.formatStatus;
                lstKOrderLine.add(objKOrLine);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstKOrderLine.size()>0){
                insert lstKOrderLine;
                jsonGen.writeStartArray();
                for(Kerridge_Order_Line__c kOrderLine :lstKOrderLine){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('kerridgeOrderLineName',kOrderLine.Name);
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