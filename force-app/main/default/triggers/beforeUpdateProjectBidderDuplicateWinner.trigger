trigger beforeUpdateProjectBidderDuplicateWinner on Project_Bidders__c (after insert, after update) {
	Set<ID> myIds = new Set<ID>();
	List<Project_Bidders__c> myLoop = new List<Project_Bidders__c>();
	Set<ID> skipIds = new Set<ID>();
	for(Integer x = 0; x<Trigger.new.size(); x++){
			if(Trigger.new[x].Winning_Bidder__c == true && Trigger.IsInsert){
				system.debug('adding');
				myIds.add(Trigger.new[x].Opportunity__c);
				myLoop.add(Trigger.new[x]);
			}else{
				if(Trigger.IsUpdate)
					if(Trigger.new[x].Winning_Bidder__c!=Trigger.old[x].Winning_Bidder__c){
						//PO has changed, let's validate it
						myIds.add(Trigger.new[x].Opportunity__c);
						myLoop.add(Trigger.new[x]);				
					}
			}
	}
	system.debug(myIds);
	Map<ID,List<Project_Bidders__c>> myExistingIds = new Map<ID,List<Project_Bidders__c>>();
	for(Project_Bidders__c y : [Select Id, Opportunity__c, Winning_Bidder__c from Project_Bidders__c where Winning_Bidder__c=true and Opportunity__c in: myIds]){
		List<Project_Bidders__c> temp = myExistingIds.get(y.Opportunity__c);
		if(temp!=null){
			temp.add(y);
		}else{
			temp = new List<Project_Bidders__c>();   
			temp.add(y);
		}                                       
		myExistingIds.put(y.Opportunity__c,temp);
	}	
	//loop back thru affected trigger rows
	for(Integer x = 0; x<myLoop.size(); x++){
		//if the PO number was queried from existing opportunities
		if(myExistingIds.get(myLoop[x].Opportunity__c)!=null && 
			//and the AccountId of that found PO is same as trigger row we are on...
			myExistingIds.get(myLoop[x].Opportunity__c).size()>1){
			myLoop[x].addError('Save failed: Duplicate Winning Bidder record found for this Opportunity.');
		}
	}
}