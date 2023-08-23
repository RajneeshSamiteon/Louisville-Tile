public class DataFactory {
    public static Set<Id> getFieldIdFromsObjects(List<sObject> objects, String fieldApiName){
        Set<id> ids = new Set<Id>();
        for( sObject sObj : objects ){
            Ids.add((Id)sObj.get(fieldApiName));
        }
        return Ids;
    }
    
    public static Map<Id,List<sObject>> getsObjectsByFieldId(List<sObject> objects, String fieldApiName){
        Map<Id,List<sObject>> sOjectsById = new  Map<Id,List<sObject>>();
          for( sObject sObj : objects ){
              if(sOjectsById.containsKey((Id)sObj.get(fieldApiName))){
                  sOjectsById.get((Id)sObj.get(fieldApiName)).add(sObj);
              }
              else{
                  sOjectsById.put((Id)sObj.get(fieldApiName),new List<sObject>{sObj});
              }
        }
        return sOjectsById;
    }
    
     public static Map<Id,List<sObject>> strigToListOfSobject(List<sObject> objects, String fieldApiName){
        Map<Id,List<sObject>> sOjectsById = new  Map<Id,List<sObject>>();
          for( sObject sObj : objects ){
              if(sOjectsById.containsKey((string)sObj.get(fieldApiName))){
                  sOjectsById.get((string)sObj.get(fieldApiName)).add(sObj);
              }
              else{
                  sOjectsById.put((string)sObj.get(fieldApiName),new List<sObject>{sObj});
              }
        }
        return sOjectsById;
    }
    
    public static Map<Id,sObject> getSobjectByRecordTypeId(List<sObject> objects, String fieldApiName){
        
        Map<Id,sObject> sOjectsById = new Map<Id,sObject>();
        for( sObject sObj : objects ){
				sOjectsById.put((id)sObj.get(fieldApiName), sObj);                
        }
        return sOjectsById;
    } 
     public static Map<String,Id> setIdbyString(List<sObject> objects, String fieldApiName){
        
        Map<String,Id> sOjectsById = new Map<String,Id>();
        for( sObject sObj : objects ){
				sOjectsById.put((string)sObj.get(fieldApiName), (id)sObj.get('id'));                
        }
        return sOjectsById;
    } 
    
    public static Map<string,sObject> getSobjectByRecordTypestring(List<sObject> objects, String fieldApiName){
        
        Map<string,sObject> sOjectsBystring = new Map<string,sObject>();
        for( sObject sObj : objects ){
				sOjectsBystring.put((string)sObj.get(fieldApiName), sObj);                
        }
        return sOjectsBystring;
    } 
}