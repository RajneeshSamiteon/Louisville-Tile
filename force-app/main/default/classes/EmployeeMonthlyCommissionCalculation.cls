/******* 
Batch Class Name :- EmployeeMonthlyCommissionCalculation
Created By :Samiteon Team 
Purpose :- Based on the monthly commission records updated by MarginCalculationByInvoiceDetail, 
This method will caluculate the monthly commission for reps every month.
*******/

public class EmployeeMonthlyCommissionCalculation implements Database.Batchable<sObject>,Schedulable{
    
    /******* 
It will query all the monthly commission pass to the execute method       
*******/ 
    public string queryCondition;
    public EmployeeMonthlyCommissionCalculation(){
        queryCondition = '(createdDate = LAST_Month OR createdDate=THIS_MONTH)  ORDER BY CreatedDate ASC';
    }
    public EmployeeMonthlyCommissionCalculation(string condition){
        queryCondition = condition;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id,name,CreatedDate,EoY_Sales_Commission__r.Commission_Master__c,employee__r.profile.name, Ancillary_Margin_Percent__c, Ancillary_Margin__c, Cost__c, Date__c, Eligible_Margin__c, Margin__c, Month__c, Not_Elligible_Margin__c, Price__c, Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, EoY_Sales_Commission__c, Employee__c, Tile_Sale__c, Ancillary_Sale__c, Total_Invoice_Ancillary_Margin__c, Total_Invoice_Tile_Margin__c, Paid_Commission__c, Total_Commission__c, Previous_Eligible_Margin__c, Previous_Tile_Margin__c, Previous_Ancillary_Margin__c, Previous_Total_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Ancillary_Margin__c, Cumulative_Eligible_Margin__c, Cumulative_Total_Margin__c, Payable_Commission__c, Previous_Total_Sale__c, Cumulative_Total_Sale__c, Total_Sale__c, Total_Margin_Without_Split__c, Actual_Commission_Earned__c, Eligible_Dealer_Amount__c, Eligible_Comm_with_Opportunity_Amount__c, Eligible_Comm_w_o_Opportunity_Amount__c, Non_Eligible_Dealer_Amount__c, Non_Eligible_Com_with_Opportunity_Amount__c, Non_Eligible_Comm_w_o_Opportunity_Amount__c, Cumulative_Eligible_Dealer_Amount__c, Cumulative_Non_Eligible_Dealer_Amount__c, Cum_Eligible_Comm_W_Opp_Amount__c, Cum_Non_Eligible_Comm_W_Opp_Amount__c, Cum_Eligible_Comm_W_O_Opp_Amount__c, Cum_Non_Eligible_Comm_W_O_Opp_Amount__c, Pre_eligible_Dealer_Amount__c, Pre_Non_eligible_Dealer_Amount__c, Pre_Eligible_Comm_W_Opp_Amount__c, Pre_Non_Eligible_Comm_W_Opp_Amount__c, Pre_Eligible_Comm_W_O_Opp_Amount__c, Pre_Non_Eligible_Comm_W_O_Opp_Amount__c, Dealer_Commission__c, Commercial_with_Opportunity_Commission__c, Commercial_W_O_Opportunity_Commission__c FROM Monthly_Commission__c where '+queryCondition;
        return Database.getQueryLocator(query);   
    }
    /*******
It will calculate monthly commission 
*******/
    public void execute(Database.BatchableContext bc, list<Monthly_Commission__c> monthlyCommissions){
        system.debug('Entering:EmployeeMonthlyCommissionCalculation.execute => monthlyCommissions::'+JSON.serializePretty(monthlyCommissions));        
        Set<id> commissionMasterIds = new Set<Id>();
        Map<String,Map<Id,List<Monthly_Commission__c>>> monthlyCommissionsByUserByProfileName = new Map<String,Map<Id,List<Monthly_Commission__c>>>();
        Map<Id,Commission_Master__c> commissionMasterById = new Map<Id,Commission_Master__c>();
        Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster = new Map<Id,List<Commission_Tier__c>>();
        List<Monthly_Commission__c> monthlyCommissionsToBeUpdated = new List<Monthly_Commission__c>();
        
        for(Monthly_Commission__c monthlyCommission : monthlyCommissions){
            commissionMasterIds.add(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c);
            monthlyCommission = MonthlyCommissionService.calculateCumulativeAmount(monthlyCommission);
            if(monthlyCommissionsByUserByProfileName.containsKey(monthlyCommission.employee__r.profile.name)){
                if(monthlyCommissionsByUserByProfileName.get(monthlyCommission.employee__r.profile.name).containskey(monthlyCommission.Employee__c)){
                    monthlyCommissionsByUserByProfileName.get(monthlyCommission.employee__r.profile.name).get(monthlyCommission.Employee__c).add(monthlyCommission);
                }
                else{
                    monthlyCommissionsByUserByProfileName.get(monthlyCommission.employee__r.profile.name).put(monthlyCommission.Employee__c,new List<Monthly_Commission__c>{monthlyCommission});  
                }
            }
            else{
                monthlyCommissionsByUserByProfileName.put(monthlyCommission.employee__r.profile.name,new Map<id,List<Monthly_Commission__c>>{monthlyCommission.Employee__c => new List<Monthly_Commission__c>{monthlyCommission}});
            }
            
        }
        
        commissionMasterById = CommissionMasterSelector.getCommissionMasterById(commissionMasterIds);
        commissionTierByCommissionMaster = DataFactory.getsObjectsByFieldId(CommissionTierSelector.getCommissionTierByCommissionMasters(commissionMasterIds),'Commission_Master__c');
        
        
        for(String profileName : monthlyCommissionsByUserByProfileName.keySet()){
            if(profileName.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPEAD)){
                monthlyCommissionsToBeUpdated.addAll(EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation(monthlyCommissionsByUserByProfileName.get(profileName),commissionMasterById,commissionTierByCommissionMaster));
            }
            else if(profileName.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPEDEALER)){
                monthlyCommissionsToBeUpdated.addAll(DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps(monthlyCommissionsByUserByProfileName.get(profileName),commissionMasterById,commissionTierByCommissionMaster));
            }
            else if(profileName.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPECONTRACTOR)){
                monthlyCommissionsToBeUpdated.addAll(DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps(monthlyCommissionsByUserByProfileName.get(profileName),commissionMasterById,commissionTierByCommissionMaster));   
            }
        }
        
        if(!monthlyCommissionsToBeUpdated.isEmpty()){
            update monthlyCommissionsToBeUpdated; 
            
        }
        system.debug('Exit:EmployeeMonthlyCommissionCalculation.execute => monthlyCommissionsToBeUpdated::'+JSON.serializePretty(monthlyCommissionsToBeUpdated));        
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Finished Execution : EmployeeMonthlyCommissionCalculation');
    }
    
    public void execute(SchedulableContext sc){
        EmployeeMonthlyCommissionCalculation employeeMonthlyCommissionCalculation= new EmployeeMonthlyCommissionCalculation(); 
        database.executeBatch(employeeMonthlyCommissionCalculation);
    }
}