public class OpportunitySplitSelector {
    public static List<OpportunitySplit> getOpportunitySplitByOpportunity(set<Id> ids){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId,SplitOwner.Profile.Name FROM OpportunitySplit WHERE OpportunityId IN: ids];
    }
    public static List<OpportunitySplit> getOpportunitySplitByOpportunityWithCalculateCommissionEnable(set<Id> ids){
        return [SELECT Id,SplitPercentage,Opportunity.Owner.Dont_calculate_commission__c,SplitOwnerId,OpportunityId,Opportunity.OwnerId,
                SplitOwner.Profile.Name FROM OpportunitySplit WHERE OpportunityId IN: ids and Opportunity.Owner.Dont_calculate_commission__c =: false];
    }
    public static List<OpportunitySplit> getOpportunitySplitByOpportunityTeamIds(Set<Id> ids){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,OpportunityTeam_Id__c FROM OpportunitySplit WHERE OpportunityTeam_Id__c IN: ids];
    }
    
    public static List<OpportunitySplit> getOpportunitySplitByOpportunity2(set<Id> opportunityIds,Set<Id> opportunityownerIds){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId FROM OpportunitySplit WHERE OpportunityId IN: opportunityIds And SplitOwnerId NOT IN:opportunityownerIds];
    }
    public static List<OpportunitySplit> getOpportunitySplitByUserId(set<Id> ids,set<Id> oppIds){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId FROM OpportunitySplit WHERE OpportunityId IN:oppIds AND SplitOwnerId IN: ids];
    }
}