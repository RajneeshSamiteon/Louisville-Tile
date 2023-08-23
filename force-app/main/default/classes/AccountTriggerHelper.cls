public without sharing  class AccountTriggerHelper {
    
    public static void isAfterUpdateHandler(Map<Id,Account> newMapAccountById,Map<Id,Account> oldMapAccountById){
            handleAccountOwnerUpdate(newMapAccountById,oldMapAccountById);
    }
    public static void handleAccountOwnerUpdate(Map<Id,Account> newMapAccountById,Map<Id,Account> oldMapAccountById){
        ProductCleanUp.isAfterUpdateTriggerPojectBidderStop=true;  
        Map<Id,Id> mapOfAccountIdByOpportunityId=new Map<Id,Id>();
        List<Project_Bidders__c> projectBidders=new List<Project_Bidders__c>();
        Set<Id> opportunitySplitIds=new Set<Id> ();
        Set<Id> opportunitySplitOwnerIds=new Set<Id> ();
        Map<Id,Account> accountsById=new Map<Id,Account>();
        Set<Id> accountIds2=new Set<Id>();
        Map<Id,Project_Bidders__c> mapOfProjectBidderById=new Map<Id,Project_Bidders__c>();
        for(Account acc:newMapAccountById.values()){
            if(acc.OwnerId != oldMapAccountById.get(acc.id).OwnerId){
                accountsById.Put(acc.Id,acc);
            }
        }
        System.debug('------accountsById----'+accountsById);
        List<Project_Bidders__c> projectBiddersFalseToBeUpdate=new List<Project_Bidders__c>();
        List<Project_Bidders__c> projectBiddersToBeUpdate=new List<Project_Bidders__c>();
        List<OpportunitySplit> opportunitySplits=new List<OpportunitySplit>();
        Map<Id,Opportunity> mapOfOpportunityIds=new Map<Id,Opportunity>();
        Map<Id,Project_Bidders__c> mapOfProjectBiddersById=new Map<Id,Project_Bidders__c>();
        Id commericalRecordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Commercial_Opportunities','Opportunity');
        set<Id> opportunityownerIds=new set<Id>();
        for(Opportunity opp:OpportunitySelector.getOpportunitiesByAccountIds(accountsById.keySet(),commericalRecordTypeId)){
            mapOfOpportunityIds.put(opp.Id,opp);
        }
        system.debug('------mapOfOpportunityIds---'+mapOfOpportunityIds);
        Map<Id,Project_Bidders__c> mapOfprojectBidderByIds=new Map<Id,Project_Bidders__c>();
        List<OpportunitySplit> opportunitySplitsToBeInserted = new List<OpportunitySplit>();
        projectBidders=ProjectBidderSelector.getProjectBiddersByAccountIds(accountsById.KeySet());
        system.debug('------projectBidders---'+projectBidders);
        for(Project_Bidders__c pb:projectBidders){
            if(mapOfOpportunityIds !=null && mapOfOpportunityIds.containsKey(pb.Opportunity__c)){
                Project_Bidders__c pBidder=new Project_Bidders__c();
                pBidder.Id=pb.Id;
                pBidder.Winning_Bidder__c=false;
                projectBiddersToBeUpdate.add(pBidder);
            }
        }
        if(!projectBiddersToBeUpdate.isEmpty()){
           update projectBiddersToBeUpdate; 
        }
        System.debug('projectBiddersToBeUpdate-----'+projectBiddersToBeUpdate);
        
        for(Project_Bidders__c pb:projectBiddersToBeUpdate){
            Project_Bidders__c pBidder=new Project_Bidders__c();
            pBidder.Id=pb.Id;
            pBidder.Winning_Bidder__c=true;
            projectBiddersFalseToBeUpdate.add(pBidder);
        }
        System.debug('projectBiddersFalseToBeUpdate-----'+projectBiddersFalseToBeUpdate);
        if(!projectBiddersFalseToBeUpdate.isEmpty()){
            Update projectBiddersFalseToBeUpdate;   
         
        }
    }
}