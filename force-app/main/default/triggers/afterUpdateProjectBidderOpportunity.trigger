trigger afterUpdateProjectBidderOpportunity on Project_Bidders__c (after insert, after update) {

	Set<ID> myIds = new Set<ID>();
    for(Integer x = 0; x < Trigger.new.size(); x++){	
		if(Trigger.isUpdate)
			if(Trigger.new[x].Winning_Bidder__c && (Trigger.new[x].Winning_Bidder__c != Trigger.old[x].Winning_Bidder__c))		
				myIds.add(Trigger.new[x].Id);	
		else
			if(Trigger.new[x].Winning_Bidder__c)		
				myIds.add(Trigger.new[x].Id);					
	}
	Map<ID,Project_Bidders__c> mapTrigger = new Map<ID,Project_Bidders__c>([Select p.Winning_Bidder__c, p.Primary_Contact__c, p.Opportunity__c, p.Name, p.Id, p.Description__c, p.Bidder_Involvement_Date__c, p.Account__c, p.Account__r.OwnerId, p.Account__r.Primary_Branch__r.Name From Project_Bidders__c p where p.Id in:myIds]);
	Map<ID,Opportunity> mapOpptyUpdates = new Map<ID,Opportunity>();
    for(Project_Bidders__c pb : mapTrigger.values()){		
		mapOpptyUpdates.put(pb.Opportunity__c,new Opportunity(
			Id = pb.Opportunity__c,
			AccountId = pb.Account__c,
			StageName = 'Post Bidding',
			OwnerId = pb.Account__r.OwnerId,
			Branch__c = pb.Account__r.Primary_Branch__r.Name
			)
    	);
    }
	update mapOpptyUpdates.values();
}