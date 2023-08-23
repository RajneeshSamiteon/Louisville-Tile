public class OpportunitySumOfAmountHandler {
    public static Map<String,List<AggregateResult>> getSumOfAmountOpportunityByAccountAndStageAndRecordType(Id accountId)
    {
        Map<String,List<AggregateResult>> mapOfAggregateResultsByRollingName=new Map<String,List<AggregateResult>>();
        List<AggregateResult> sumOfAmountsByStageName=new List<AggregateResult>();
        Date todays=Date.today();
        Date forwardRollingDate=todays.addMonths(12);
        Date backwardRollingDate=todays.addMonths(-12);
        if(OpportunitySelector.getSumOfAmountOpportunityByAccountAndStageAndRecordType(new set<Id>{accountId},todays,forwardRollingDate).size() >0){
              sumOfAmountsByStageName= OpportunitySelector.getSumOfAmountOpportunityByAccountAndStageAndRecordType(new set<Id>{accountId},todays,forwardRollingDate); 
        }
        System.debug('forwardRolling------------'+sumOfAmountsByStageName);
        System.debug('backwardRolling-----------'+OpportunitySelector.getSumOfAmountsOpportunityByAccountAndBackwardRolling(new set<Id>{accountId},todays,backwardRollingDate));
       
        
        mapOfAggregateResultsByRollingName.put('forwardRolling',sumOfAmountsByStageName);
        mapOfAggregateResultsByRollingName.put('backwardRolling',OpportunitySelector.getSumOfAmountsOpportunityByAccountAndBackwardRolling(new set<Id>{accountId},todays,backwardRollingDate));
        //System.debug('mapOfAggregateResultsByRollingName------------'+Map<String,List<AggregateResult>>);
        return mapOfAggregateResultsByRollingName;
        
        
    }
}