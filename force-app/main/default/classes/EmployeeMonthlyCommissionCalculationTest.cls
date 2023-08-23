@isTest
public class EmployeeMonthlyCommissionCalculationTest {
    
    @testSetup
    public static void creatTestData(){
        List<Commission_Master__c> commissionMasters = new List<Commission_Master__c>();
        for(Integer i=0;i<3;i++){
            Commission_Master__c commissionMaster = new Commission_Master__c();
            commissionMaster.Name = 'Dummy Commission Master';
            if(i==0){
                commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
                commissionMaster.Percent_below_retroactive_EoY_Adj__c = 1;
                commissionMaster.Commission_percent_under_target__c = 1;
                commissionMaster.Target_for_EoY_adjustment__c = 35;
            }else if(i==1){
                commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - Dealer').getRecordTypeId();
                commissionMaster.Commission_percent_under_target__c = 0;
                commissionMaster.Commercial_without_Opportunity__c = 4;
            }else{
                commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - Contractor').getRecordTypeId();
                commissionMaster.Commission_percent_under_target__c = 0;
                commissionMaster.Commercial_without_Opportunity__c = 4;
            }
            commissionMasters.add(commissionMaster); 
        }
        insert commissionMasters;
        Set<Id> commissionMasterIds = new Set<Id>();
        for(Commission_Master__c commissionMaster : commissionMasters){
            commissionMasterIds.add(commissionMaster.Id);
        }
        
        List<Commission_Master__c> commissionMasterlist = [Select Id,Name,recordType.Name from Commission_Master__c where Id IN : commissionMasterIds];
        Map<Id,String> recordTypeNameByCommissionMaster = new  Map<Id,String>();
        for(Commission_Master__c commissionMaster : commissionMasterlist){
            recordTypeNameByCommissionMaster.put(commissionMaster.Id,commissionMaster.recordType.Name);
        }
        List<Commission_Tier__c> commissionTiers = new List<Commission_Tier__c>();
        for(Commission_Master__c commissionMaster : commissionMasters){
            for(Integer i=0; i<5; i++){
                Commission_Tier__c commissionTier = new Commission_Tier__c();
                commissionTier.Commission_Master__c = commissionMaster.Id;
                if(recordTypeNameByCommissionMaster.containsKey(commissionMaster.id)){
                    commissionTier.Profile_Type__c = recordTypeNameByCommissionMaster.get(commissionMaster.id);
                }
                if(commissionTier.Profile_Type__c == 'Sales Representative - A&D'){
                    commissionTier.Tier_Type__c = 'Retroactive';
                    commissionTier.Lower_Amount__c = 400*i;
                    commissionTier.Upper_Amount__c = (400*(i+1));
                } 
                if(commissionTier.Profile_Type__c == 'Sales Representative - Dealer'){
                    if(i<3){
                        commissionTier.Tier_Type__c = 'Dealer';
                        commissionTier.Lower_Amount__c = 400*i;
                        commissionTier.Upper_Amount__c = (400*(i+1));
                    }else{
                        commissionTier.Tier_Type__c = 'Commercial with Opportunities';
                        commissionTier.Lower_Amount__c = (400*(i-3));
                        commissionTier.Upper_Amount__c = (400*(i-2));
                    }  
                }
                if(commissionTier.Profile_Type__c == 'Sales Representative - Contractor'){
                    if(i<3){
                        commissionTier.Tier_Type__c = 'Dealer';
                        commissionTier.Lower_Amount__c = 400*i;
                        commissionTier.Upper_Amount__c = (400*(i+1));
                    }else{
                        commissionTier.Tier_Type__c = 'Commercial with Opportunities';
                        commissionTier.Lower_Amount__c = (400*(i-3));
                        commissionTier.Upper_Amount__c = (400*(i-2));
                    }
                }
                commissionTier.Commission_Percentage__c = 35;
                commissionTiers.add(commissionTier);
            }
        }
        insert commissionTiers;
        
        list<user> Users = new list<user>();
        Map<string ,Id> userPrileToUserRoleId = new Map<string, Id>();
        Map<string ,Id> userPrileToUserProfileId = new Map<string, Id>();
        list<string> ProfileName = CommissionCalculatorConstants.profileNames;
        userPrileToUserProfileId = DataFactory.setIdbyString([SELECT id , Name from profile where Name in :ProfileName] , 'name');
        userPrileToUserRoleId = DataFactory.setIdbyString([SELECT id , Name from UserRole where Name in :ProfileName] , 'name');
        map<string,list<string>> userDetail = new map<string,list<string>>{
            'Akhilesh Singh' => new list<string>{'Akhilesh','Singh','akhi12ileshSingh123@nubys.com', 'Sales Representative - A&D'},
                'Dheeraj Singh' =>new list<string>{'Dheeraj','Singh','dj123Singh123@nubys.com', 'Sales Representative - Dealer'},
                    'Amir Khan' =>new list<string>{'Amir','Khan','amKhan123@nubys.com', 'Sales Representative - Contractor'}
        };
            for(string userName : userDetail.keySet()){
                user userObj = new user();
                userObj.lastName = userDetail.get(userName)[1];
                userObj.Email = userDetail.get(userName)[2];
                userObj.userRoleId = userPrileToUserRoleId.get(userName);
                userObj.ProfileId = userPrileToUserProfileId.get(userDetail.get(userName)[3]);
                System.debug('userDetail.get(userName) : '+(userDetail.get(userName)));
                userObj.Username = userDetail.get(userName)[2]+'test';
                userObj.Alias = userDetail.get(userName)[1]+'0';
                userObj.TimeZoneSidKey ='America/Yakutat';
                userObj.LocaleSidKey  = 'en_US';
                userObj.EmailEncodingKey  = 'ISO-8859-1';
                userObj.LanguageLocaleKey = 'en_US';
                userObj.Dont_calculate_commission__c  = False ;
                Users.add(userObj);
            } 
        insert Users;
        Set<Id> userIds = new Set<Id>();
        for(User user : Users){
            userIds.add(user.Id); 
        }
        
        List<User> userlist = [Select Id,Name,profile.name from user where Id IN : userIds];
        Map<String,String> UserByProfile = new Map<String,String>();
        for(User user : userlist){
            UserByProfile.put(user.profile.name,user.Id); 
        }
        
        List<EoY_Sales_Commission__c> eoySalesCommissions = new List<EoY_Sales_Commission__c>();
        for(Commission_Master__c commMaster : commissionMasters){
            EoY_Sales_Commission__c eoYSalesCommission = new EoY_Sales_Commission__c();
            eoYSalesCommission.Name = 'Dummy EoY Sales Commission';
            if(UserByProfile.containsKey(recordTypeNameByCommissionMaster.get(commMaster.Id))){
                eoYSalesCommission.Employee__c = UserByProfile.get(recordTypeNameByCommissionMaster.get(commMaster.Id));
            }
            eoYSalesCommission.Commission_Master__c = commMaster.Id;
            eoySalesCommissions.add(eoYSalesCommission);
        }
        
        insert eoYSalesCommissions;
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(EoY_Sales_Commission__c eoySalesCommission : eoYSalesCommissions){
            Monthly_Commission__c monthlyCommission = new  Monthly_Commission__c();
            monthlyCommission.Name = 'Dummy Monthly Commission';
            monthlyCommission.EoY_Sales_Commission__c = eoYSalesCommission.Id;
            monthlyCommission.Employee__c = eoySalesCommission.Employee__c;
            monthlyCommission.Cumulative_Total_Margin__c = 51000;
            monthlyCommission.Cumulative_Ancillary_Margin__c = 51000;
            monthlyCommission.Cumulative_Eligible_Margin__c = 51000;
            monthlyCommission.Total_Invoice_Ancillary_Margin__c = 51000;
            monthlyCommission.Total_Invoice_Tile_Margin__c = 51000;
            monthlyCommission.Previous_Total_Margin__c = 51000;
            monthlyCommission.Cumulative_Tile_Margin__c = 51000;
            monthlyCommission.Cumulative_Total_Sale__c = 51000;
            monthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c = 51000;
            monthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c = 51000;
            monthlyCommission.Dealer_Commission__c = 51000;
            monthlyCommission.Cumulative_Eligible_Dealer_Amount__c = 51000;
            monthlyCommission.Commercial_with_Opportunity_Commission__c = 51000;
            monthlyCommission.Commercial_W_O_Opportunity_Commission__c = 51000;
            monthlyCommission.Total_Commission__c = 51000;
            
            monthlyCommission.Tile_Sale__c = 1000;
            monthlyCommission.Ancillary_Sale__c = 2000;
            monthlyCommission.Total_Invoice_Ancillary_Margin__c = 0;
            monthlyCommission.Previous_Ancillary_Margin__c = 0;
            monthlyCommission.Total_Invoice_Tile_Margin__c = 0;
            monthlyCommission.Previous_Tile_Margin__c = 0;
            monthlyCommission.Total_Sale__c = 0; 
            monthlyCommission.Previous_Total_Sale__C = 0;
            monthlyCommission.Eligible_Margin__c = 0; 
            monthlyCommission.Previous_Eligible_Margin__c = 0;
            monthlyCommission.Eligible_Dealer_Amount__c = 0; 
            monthlyCommission.Pre_eligible_Dealer_Amount__c = 0;
            monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c = 0; 
            monthlyCommission.Pre_Eligible_Comm_W_Opp_Amount__c = 0;
            monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c = 0; 
            monthlyCommission.Pre_Eligible_Comm_W_O_Opp_Amount__c = 0;
            monthlyCommission.Non_Eligible_Dealer_Amount__c  = 0; 
            monthlyCommission.Pre_Non_eligible_Dealer_Amount__c = 0;
            monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c = 0; 
            monthlyCommission.Pre_Non_Eligible_Comm_W_Opp_Amount__c = 0;
            monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c = 0;
            monthlyCommission.Pre_Non_Eligible_Comm_W_O_Opp_Amount__c = 0;
            monthlyCommissions.add(monthlyCommission);
        }
        insert monthlyCommissions;
    }
    
    @isTest
    public static void validateStart(){
        test.startTest();
        Database.executeBatch(new EmployeeMonthlyCommissionCalculation('createdDate = today'));
        test.stopTest();
    }
    
}