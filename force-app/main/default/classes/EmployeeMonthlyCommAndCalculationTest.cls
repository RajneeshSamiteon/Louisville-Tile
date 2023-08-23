@isTest
public class EmployeeMonthlyCommAndCalculationTest {

    @testSetup
    public static void testSetup(){
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Dummy Commission Master';
        commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
        commissionMaster.Commission_percent_under_target__c = 1;
        insert commissionMaster;
        
        List<Commission_Tier__c> commissionTiers = new List<Commission_Tier__c>();
        for(Integer i=1; i<3; i++) {
            Commission_Tier__c commissionTier = new Commission_Tier__c();
            commissionTier.Commission_Master__c = commissionMaster.Id;
            commissionTier.Profile_Type__c = 'Sales Representative - A&D';
            commissionTier.Tier_Type__c = 'Marginal';  
            commissionTier.Lower_Amount__c = (400*i);
            if(i>1){
                commissionTier.Upper_Amount__c = 6000*i;
                commissionTier.Tier_Type__c = 'Retroactive';  
            }
            else{
                 commissionTier.Upper_Amount__c = 450*i;
            }
            commissionTier.Commission_Percentage__c = 34;
            commissionTiers.add(commissionTier);
        }
        insert commissionTiers;
        
        List<User> users = new List<User>();
        for(Integer i=0;i<2;i++) {
            User user = new User();
            user.LastName = 'Singh'+i;
            user.Alias = 'singh'+i;
            user.Email = 'raj.singh@asdf.com';
            user.Username = 'raj'+i+'.singh@asdf.com';
            user.ProfileId = [SELECT Id FROM Profile WHERE Name =: CommissionCalculatorConstants.REPTYPEAD LIMIT 1].Id;
            user.TimeZoneSidKey = 'GMT';
            user.LanguageLocaleKey = 'en_US';
            user.EmailEncodingKey = 'UTF-8';
            user.LocaleSidKey = 'en_US';
            users.add(user);
        }
        insert users;
        
        List<EoY_Sales_Commission__c> eoySalesCommissions = new List<EoY_Sales_Commission__c>();
        for(Integer i=0;i<2;i++) {
            EoY_Sales_Commission__c eoyCommission = new  EoY_Sales_Commission__c();
            eoyCommission.Name = 'Dummy Eoy Sales Commission';
            eoyCommission.Employee__c = users[i].Id ;
            eoyCommission.Commission_Master__c = commissionMaster.Id;
            eoySalesCommissions.add(eoyCommission);
        }
        insert eoySalesCommissions;
		
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(Integer i=0; i<2; i++) {
            Monthly_Commission__c monthlyCommission = new  Monthly_Commission__c();
            monthlyCommission.Name = 'Dummy Monthly Commission';
            monthlyCommission.EoY_Sales_Commission__c = eoySalesCommissions[i].Id;
            monthlyCommission.Cumulative_Total_Margin__c = 500;
            monthlyCommission.Employee__c = eoySalesCommissions[i].Employee__c;
            monthlyCommission.Cumulative_Ancillary_Margin__c = 500;
            monthlyCommission.Cumulative_Eligible_Margin__c = 500;
            monthlyCommission.Total_Invoice_Ancillary_Margin__c = 500;
            monthlyCommission.Total_Invoice_Tile_Margin__c = 500;
            monthlyCommission.Previous_Total_Margin__c = 500;
            monthlyCommission.Cumulative_Tile_Margin__c = 500;
            monthlyCommission.Cumulative_Total_Sale__c = 500;
            Monthly_Commission__c monthlyCommissionTwo = new  Monthly_Commission__c();
            monthlyCommissionTwo.Name = 'Dummy Monthly Commission';
            monthlyCommissionTwo.EoY_Sales_Commission__c = eoySalesCommissions[i].Id;
            monthlyCommissionTwo.Cumulative_Total_Margin__c = 500;
            monthlyCommissionTwo.Employee__c = eoySalesCommissions[i].Employee__c;
            monthlyCommissionTwo.Cumulative_Ancillary_Margin__c = 500;
            monthlyCommissionTwo.Cumulative_Eligible_Margin__c = 500;
            monthlyCommissionTwo.Total_Invoice_Ancillary_Margin__c = 500;
            monthlyCommissionTwo.Total_Invoice_Tile_Margin__c = 500;
            monthlyCommissionTwo.Previous_Total_Margin__c = 500;
            monthlyCommissionTwo.Cumulative_Tile_Margin__c = 500;
            monthlyCommissionTwo.Cumulative_Total_Sale__c = 500;
            monthlyCommissions.add(monthlyCommission);
             monthlyCommissions.add(monthlyCommissionTwo);
        }
        insert monthlyCommissions;
    }
    
    public static Map<Id,Commission_Master__c> getcommissionMasterById(){
        return new Map<Id,Commission_Master__c>([SELECT Id, Name, RecordTypeId, Minimum_Retroactive_Threshold__c,Commission_percent_under_target__c FROM Commission_Master__c]);
    }
    
    public static Map<Id,List<Commission_Tier__c>> getcommissionTierByCommissionMaster(){
        List<Commission_Tier__c> commissionTiers = [SELECT Id, Commission_Master__c, Lower_Amount__c, Upper_Amount__c,
                                                    Commission_Percentage__c,Max_Commission_Amount__c 
                                                    FROM Commission_Tier__c 
                                                    Where Commission_Master__c != NULL];
        
        Map<Id,List<Commission_Tier__c>> commissionTiersByCommissionMasterId = new Map<Id,List<Commission_Tier__c>>();
        for(Commission_Tier__c commissionTier : commissionTiers){
            Id commissionMasterId = commissionTier.Commission_Master__c;
            if (commissionTiersByCommissionMasterId.containsKey(commissionMasterId)) {
                commissionTiersByCommissionMasterId.get(commissionMasterId).add(commissionTier);
            }
            else {
                commissionTiersByCommissionMasterId.put(commissionMasterId, new List<Commission_Tier__c>{commissionTier});
            }
        }
        return commissionTiersByCommissionMasterId;
    }
    
    @isTest
    public static void validatemonthlyCommissionByUserCalculation() {
        boolean isTrue = true;
        List<Monthly_Commission__c> updatedMonthlyCommissions = [SELECT Id, Name, EoY_Sales_Commission__r.Commission_Master__c,EoY_Sales_Commission__c, Actual_Commission_Earned__c, Ancillary_Margin_Percent__c, Ancillary_Margin__c, Ancillary_Sale__c, Cost__c, Cumulative_Ancillary_Margin__c, Cumulative_Eligible_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Total_Margin__c, Cumulative_Total_Sale__c, Date__c, Eligible_Margin__c, Employee__c, Margin__c, Month__c, Not_Elligible_Margin__c, Paid_Commission__c, Previous_Ancillary_Margin__c, Previous_Eligible_Margin__c, Previous_Tile_Margin__c, Previous_Total_Margin__c, Previous_Total_Sale__c, Price__c, Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, Tile_Sale__c, Total_Commission__c, Total_Invoice_Ancillary_Margin__c, Total_Invoice_Tile_Margin__c, Total_Sale__c, Payable_Commission__c, Total_Margin_Without_Split__c, Total_Sale_After_Split__c, Commercial_W_O_Opportunity_Commission__c, Commercial_with_Opportunity_Commission__c, Commercial_with_Opportunity_Sales__c, Commercial_without_Opportunity_Sales__c, Cum_Eligible_Comm_W_O_Opp_Amount__c, Cum_Eligible_Comm_W_Opp_Amount__c, Cum_Non_Eligible_Comm_W_O_Opp_Amount__c, Cum_Non_Eligible_Comm_W_Opp_Amount__c, Cumulative_Eligible_Dealer_Amount__c, Cumulative_Non_Eligible_Dealer_Amount__c, Dealer_Commission__c, Dealer_Sales__c, Eligible_Comm_w_o_Opportunity_Amount__c, Eligible_Comm_with_Opportunity_Amount__c, Eligible_Dealer_Amount__c, Non_Eligible_Com_with_Opportunity_Amount__c, Non_Eligible_Comm_w_o_Opportunity_Amount__c, Non_Eligible_Dealer_Amount__c, Pre_Eligible_Comm_W_O_Opp_Amount__c, Pre_Eligible_Comm_W_Opp_Amount__c, Pre_Non_Eligible_Comm_W_O_Opp_Amount__c, Pre_Non_Eligible_Comm_W_Opp_Amount__c, Pre_Non_eligible_Dealer_Amount__c, Pre_eligible_Dealer_Amount__c, Total_Commercial_Sales__c FROM Monthly_Commission__c];
        
        for(Monthly_Commission__c updatedMonthlyCommission : updatedMonthlyCommissions) {
            updatedMonthlyCommission.Cumulative_Ancillary_Margin__c = 500;
            updatedMonthlyCommission.Cumulative_Eligible_Margin__c = 500;
            updatedMonthlyCommission.Total_Invoice_Ancillary_Margin__c = 500;
            updatedMonthlyCommission.Total_Invoice_Tile_Margin__c = 500;
            updatedMonthlyCommission.Previous_Total_Margin__c = 500;
            updatedMonthlyCommission.Cumulative_Tile_Margin__c = 500;
            updatedMonthlyCommission.Cumulative_Total_Sale__c = 500;
			updatedMonthlyCommission.Cumulative_Total_Margin__c = (isTrue ? 500 : 5000);
            if(isTrue) {
                isTrue = false;
            }
        }
        update updatedMonthlyCommissions;
        
        Map<Id,List<Monthly_Commission__c>> monthlyCommissionsByUser = new Map<Id,List<Monthly_Commission__c>>();
        for(Monthly_Commission__c updatedMonthlyCommission : updatedMonthlyCommissions) {
            Id employeeId = updatedMonthlyCommission.Employee__c;
            if(monthlyCommissionsByUser.containsKey(employeeId)) {
                monthlyCommissionsByUser.get(employeeId).add(updatedMonthlyCommission);
            }
            else {
                monthlyCommissionsByUser.put(employeeId, new List<Monthly_Commission__c>{updatedMonthlyCommission});
            }
        }
        
        Test.startTest();
        List<Monthly_Commission__c> monthlyCommissions = EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation(monthlyCommissionsByUser, getcommissionMasterById(), getcommissionTierByCommissionMaster());
        Test.stopTest();
        
    }    
}