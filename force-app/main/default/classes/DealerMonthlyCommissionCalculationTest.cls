@isTest
public class DealerMonthlyCommissionCalculationTest {
    
    @testSetup
    public static void testSetup(){
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Dummy Commission Master';
        commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - Dealer').getRecordTypeId();
        commissionMaster.Commission_percent_under_target__c = 0;
        commissionMaster.Commercial_without_Opportunity__c = 4;
        insert commissionMaster;
        
        List<Commission_Tier__c> commissionTiers = new List<Commission_Tier__c>();
        for(Integer i=1; i<6; i++) {
            Commission_Tier__c commissionTier = new Commission_Tier__c();
            commissionTier.Commission_Master__c = commissionMaster.Id;
            commissionTier.Profile_Type__c = 'Sales Representative - Dealer';
            If(i<3){
                commissionTier.Tier_Type__c = 'Dealer';  
            }else{
                commissionTier.Tier_Type__c = 'Commercial with Opportunities';  
            }
            if(i>1){
                commissionTier.Lower_Amount__c = 400*i;
                commissionTier.Upper_Amount__c = (400*(i+1));
            }else{
             commissionTier.Lower_Amount__c  = 0;
             commissionTier.Upper_Amount__c  = 400;
            }
            
            commissionTier.Commission_Percentage__c = 35;
            commissionTiers.add(commissionTier);
        }
        System.debug('commissionTiers ::'+commissionTiers);
        insert commissionTiers;    
        
        list<user> Users = new list<user>();
        map<string ,id> userPrileToUserRoleId = new map<string, id>();
        map<string ,id> userPrileToUserProfileId = new map<string, id>();
        list<string> ProfileName = CommissionCalculatorConstants.profileNames;
        userPrileToUserProfileId = DataFactory.setIdbyString([SELECT id , Name from profile where Name in :ProfileName] , 'name');
        userPrileToUserRoleId = DataFactory.setIdbyString([SELECT id , Name from UserRole where Name in :ProfileName] , 'name');
        map<string,list<string>> userDetail = new map<string,list<string>>{
            'Dheeraj Singh' =>new list<string>{'Dheeraj','Singh','dheer12Singh123@gmail.com', 'Sales Representative - Dealer'}
        };
            for(string userName : userDetail.keySet()){
                user userObj = new user();
                userObj.lastName = userDetail.get(userName)[1];
                userObj.Email = userDetail.get(userName)[2];
                userObj.userRoleId = userPrileToUserRoleId.get(userName);
                userObj.ProfileId = userPrileToUserProfileId.get(userDetail.get(userName)[3]);
                userObj.Username = userDetail.get(userName)[2];
                userObj.Alias = userDetail.get(userName)[1]+'0';
                userObj.TimeZoneSidKey ='America/Yakutat';
                userObj.LocaleSidKey  = 'en_US';
                userObj.EmailEncodingKey  = 'ISO-8859-1';
                userObj.LanguageLocaleKey = 'en_US';
                userObj.Dont_calculate_commission__c  = False ;
                Users.add(userObj);  
            }
        insert users;
        
        List<EoY_Sales_Commission__c> eoySalesCommissions = new List<EoY_Sales_Commission__c>();
        for(User user : users){
            EoY_Sales_Commission__c eoyCommission = new  EoY_Sales_Commission__c();
            eoyCommission.Name = 'Demo Eoy Sales Commission';
            eoyCommission.Employee__c = user.Id ;
            eoyCommission.Commission_Master__c = commissionMaster.Id;
            eoySalesCommissions.add(eoyCommission);
        }
        insert eoySalesCommissions;  
        
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(EoY_Sales_Commission__c eoYSalesCommission : eoYSalesCommissions){
            Monthly_Commission__c monthlyCommission = new  Monthly_Commission__c();
            monthlyCommission.Name = 'Dummy Monthly Commission';
            monthlyCommission.EoY_Sales_Commission__c = eoYSalesCommission.Id;
            monthlyCommission.Cumulative_Total_Margin__c = 2222;
            monthlyCommission.Employee__c = eoYSalesCommission.Employee__c;
            monthlyCommission.Cumulative_Ancillary_Margin__c = 2121;
            monthlyCommission.Cumulative_Eligible_Margin__c = 2323;
            monthlyCommission.Total_Invoice_Ancillary_Margin__c = 2424;
            monthlyCommission.Total_Invoice_Tile_Margin__c = 2525;
            monthlyCommission.Previous_Total_Margin__c = 2626;
            monthlyCommission.Cumulative_Tile_Margin__c = 2727;
            monthlyCommission.Cumulative_Total_Sale__c = 2828;
            monthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c = 51000;
            monthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c = 51000;
            monthlyCommission.Dealer_Commission__c = 51000;
            monthlyCommission.Cumulative_Eligible_Dealer_Amount__c = 51000;
            monthlyCommission.Commercial_with_Opportunity_Commission__c = 51000;
            monthlyCommission.Commercial_W_O_Opportunity_Commission__c = 51000;
            monthlyCommission.Total_Commission__c = 51000;

            monthlyCommissions.add(monthlyCommission);
        }
        insert monthlyCommissions;
        
    }
    
    public static Map<Id,Commission_Master__c> getcommissionMasterById(){
        return new Map<Id,Commission_Master__c>([SELECT Id, Name, RecordTypeId, Commercial_Without_Opportunity__c ,Commission_percent_under_target__c FROM Commission_Master__c]);
    }
    public static Map<Id,List<Commission_Tier__c>> getcommissionTierByCommissionMaster(){
        List<Commission_Tier__c> commissionTiers = [SELECT Id, Commission_Master__c, Lower_Amount__c, Upper_Amount__c,
                                                    Commission_Percentage__c,Max_Commission_Amount__c,Profile_Type__c, 
                                                    minimal_retroactive__c,Tier_Type__c 
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
    public static void monthlyCommissionByUserCalculation() {
        boolean isTrue = true;
        List<Monthly_Commission__c> updatedMonthlyCommissions = [SELECT Id, Name, Employee__c, Cumulative_Total_Margin__c,
                                                                 Total_Invoice_Ancillary_Margin__c,Total_Invoice_Tile_Margin__c,
                                                                 EoY_Sales_Commission__c, EoY_Sales_Commission__r.Commission_Master__c,
                                                                 Cumulative_Ancillary_Margin__c,Cumulative_Eligible_Margin__c,
                                                                 Cumulative_Tile_Margin__c,Cumulative_Total_Sale__c,Previous_Total_Margin__c,
                                                                 Total_Margin_Without_Split__c, Actual_Commission_Earned__c,
                                                                 Eligible_Dealer_Amount__c, Eligible_Comm_with_Opportunity_Amount__c,
                                                                 Eligible_Comm_w_o_Opportunity_Amount__c, Non_Eligible_Dealer_Amount__c,
                                                                 Non_Eligible_Com_with_Opportunity_Amount__c, 
                                                                 Non_Eligible_Comm_w_o_Opportunity_Amount__c, Cumulative_Eligible_Dealer_Amount__c,
                                                                 Cumulative_Non_Eligible_Dealer_Amount__c, Cum_Eligible_Comm_W_Opp_Amount__c,
                                                                 Cum_Non_Eligible_Comm_W_Opp_Amount__c, Cum_Eligible_Comm_W_O_Opp_Amount__c,
                                                                 Cum_Non_Eligible_Comm_W_O_Opp_Amount__c, Pre_eligible_Dealer_Amount__c, 
                                                                 Pre_Non_eligible_Dealer_Amount__c, Pre_Eligible_Comm_W_Opp_Amount__c,
                                                                 Pre_Non_Eligible_Comm_W_Opp_Amount__c, Pre_Eligible_Comm_W_O_Opp_Amount__c,
                                                                 Pre_Non_Eligible_Comm_W_O_Opp_Amount__c, Dealer_Commission__c,
                                                                 Commercial_with_Opportunity_Commission__c, Commercial_W_O_Opportunity_Commission__c
                                                                 FROM Monthly_Commission__c];
        
        for(Monthly_Commission__c updatedMonthlyCommission : updatedMonthlyCommissions) {
            updatedMonthlyCommission.Cumulative_Ancillary_Margin__c = 1111;
            updatedMonthlyCommission.Cumulative_Eligible_Margin__c = 2222;
            updatedMonthlyCommission.Total_Invoice_Ancillary_Margin__c = 3333;
            updatedMonthlyCommission.Total_Invoice_Tile_Margin__c = 4444;
            updatedMonthlyCommission.Previous_Total_Margin__c = 5555;
            updatedMonthlyCommission.Cumulative_Tile_Margin__c = 6666;
            updatedMonthlyCommission.Cumulative_Total_Sale__c = 7777;
            updatedMonthlyCommission.Cumulative_Total_Margin__c = (isTrue ? 6677 : 8888);
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
        List<Monthly_Commission__c> monthlyCommissions = DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps(monthlyCommissionsByUser, getcommissionMasterById(), getcommissionTierByCommissionMaster());
        Test.stopTest();
    }
}