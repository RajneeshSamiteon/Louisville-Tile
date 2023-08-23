@isTest
public class EoYSalesCommissionHandlerTest {
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
        Map<String,Commission_Master__c> commissionMasterByProfile = new Map<String,Commission_Master__c>();
        for(Commission_Master__c commissionMaster : commissionMasters){
            commissionMasterIds.add(commissionMaster.Id);
        }
        
        List<Commission_Master__c> commissionMasterlist = [Select Id,Name,recordType.Name from Commission_Master__c where Id IN : commissionMasterIds];
        System.debug('commissionMasterlist ::'+commissionMasterlist);
        Map<Id,String> recordTypeNameByCommissionMaster = new  Map<Id,String>();
        for(Commission_Master__c commissionMaster : commissionMasterlist){
            recordTypeNameByCommissionMaster.put(commissionMaster.Id,commissionMaster.recordType.Name);
            commissionMasterByProfile.put(commissionMaster.recordType.Name, commissionMaster);
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
        System.debug('commissionTiers ::>>'+JSON.serializePretty(commissionTiers));
        
        List<GP_percent_target__c> gpPercentTargetList = new List<GP_percent_target__c>();
        for(GP_Percentage_target__mdt GpPercent : GPPercentTargetMetadataSelector.getGpPercentTargetMetadata()){
            GP_percent_target__c gpPercentInstance = new GP_percent_target__c();
            gpPercentInstance.type__c = GpPercent.product_type__c;
            gpPercentInstance.Target_Percent__c = GpPercent.commission_percentage__c;
            gpPercentInstance.Profile_Type__c = GpPercent.Profile_Type__c;
            gpPercentInstance.commission_master__c= commissionMasterByProfile.get(GpPercent.Profile_Type__c).id;
            gpPercentTargetList.add(gpPercentInstance);            
        }
        insert gpPercentTargetList;
        
        Map<Id,List<GP_percent_target__c>> gpPercentTargetByCommissionMaster = new Map<Id,List<GP_percent_target__c>>();
        for(GP_percent_target__c gpPercent : gpPercentTargetList){
            if(gpPercentTargetByCommissionMaster.containsKey(gpPercent.Commission_Master__c)) {
                gpPercentTargetByCommissionMaster.get(gpPercent.Commission_Master__c).add(gpPercent);
            }
            else {
                gpPercentTargetByCommissionMaster.put(gpPercent.Commission_Master__c, new List<GP_percent_target__c>{gpPercent});
            }   
        }
        
        
        List<EoY_GP_Target_Bonus__c> EoyPercenttargetList = new List<EoY_GP_Target_Bonus__c>();
        for(EOY_Bonus__mdt EoYBonus : EoYBonusSelector.getEoyBonusMetadata()){
            EoY_GP_Target_Bonus__c EoyPercentTargetInstance = new EoY_GP_Target_Bonus__c();
            if(commissionMasterByProfile.containsKey(EoYBonus.Profile_Type__c)){
                EoyPercentTargetInstance.amount__c = EoYBonus.amount__c;
                EoyPercentTargetInstance.Bonus__c = EoYBonus.Bonus__c;
                EoyPercentTargetInstance.Profile_Type__c = EoYBonus.Profile_Type__c; 
                EoyPercentTargetInstance.commission_master__c= commissionMasterByProfile.get(EoYBonus.Profile_Type__c).id;
                EoyPercenttargetList.add(EoyPercentTargetInstance);            
            }
        }
        insert EoyPercenttargetList;
        List<EOY_Margin_Target__c> eoYMarginTargetList = new List<EOY_Margin_Target__c>();
        for(EoY_Gp_Percent_Target__mdt eoYGpPercentTarget : EoYGpPercentTargetMetadataSelector.getEoYGpPerrcentTarget()){
            EOY_Margin_Target__c eoYMarginTargetInstance = new EOY_Margin_Target__c();
            if(commissionMasterByProfile.containsKey(eoYGpPercentTarget.Profile_Type__c)){
                eoYMarginTargetInstance.Profile_Type__c = eoYGpPercentTarget.Profile_Type__c;
                eoYMarginTargetInstance.Target__c = eoYGpPercentTarget.Target__c;
                eoYMarginTargetInstance.Type__c =  eoYGpPercentTarget.Type__c;
                eoYMarginTargetInstance.Commission_Master__c = commissionMasterByProfile.get(eoYGpPercentTarget.Profile_Type__c).id;
                eoYMarginTargetList.add(eoYMarginTargetInstance); 
            }
        }
        insert eoYMarginTargetList;
        
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
            eoYSalesCommission.Commission_Master__c = commMaster.Id;
            if(UserByProfile.containsKey(recordTypeNameByCommissionMaster.get(commMaster.Id))){
                eoYSalesCommission.Employee__c = UserByProfile.get(recordTypeNameByCommissionMaster.get(commMaster.Id));
            }
            eoYSalesCommission.Bonus__c = 5000;
            eoYSalesCommission.Commercial_Margin_Percent__c = 27;
            eoySalesCommissions.add(eoYSalesCommission);
        }
        insert eoYSalesCommissions;
        System.debug('eoYSalesCommissions ::'+eoYSalesCommissions);
        System.debug('eoYSalesCommissions ::>>>'+JSON.serializePretty(eoYSalesCommissions));
        Map<Id,EoY_Sales_Commission__c> eoySalesCommissionById = new Map<Id,EoY_Sales_Commission__c>();
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(EoY_Sales_Commission__c eoySalesCommission : eoYSalesCommissions){
            eoySalesCommissionById.put(eoySalesCommission.id,eoySalesCommission);
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
            monthlyCommissions.add(monthlyCommission);
        }
        insert monthlyCommissions;
        Set<Id> monthlyCommissionIds = new Set<Id>();
        for(Monthly_Commission__c monthlyCom : monthlyCommissions){
            dateTime dt = DateTime.newInstance(2022, 12, 30, 23, 0, 59);
            test.setCreatedDate(monthlyCom.id, dt);
            monthlyCommissionIds.add(monthlyCom.Id);
        }
    }  
   
    @isTest
    public static void validateEoYSalesCommissionHandler(){
                List<Commission_Master__c> commissionMasterlist = [Select Id,Name,Percent_below_retroactive_EoY_Adj__c,Target_for_EoY_adjustment__c,
                                                           Commission_percent_under_target__c,Minimum_Retroactive_Threshold__c,Commercial_without_Opportunity__c from Commission_Master__c];
        Map<Id,Commission_Master__c> commissionMasterById = new Map<Id,Commission_Master__c>();
        for(Commission_Master__c commissionMaster : commissionMasterlist){
            commissionMasterById.put(commissionMaster.Id,commissionMaster);
        }

        Map<Id,EoY_Sales_Commission__c> eoYSalesCommissionByIdForAnd = new Map<Id,EoY_Sales_Commission__c>();
        Map<Id,EoY_Sales_Commission__c> eoYSalesCommissionByIdForDealerContractor = new Map<Id,EoY_Sales_Commission__c>();
        List<EoY_Sales_Commission__c> eoYSalesCommissions = [Select Id,Name,Bonus__c,Commercial_Margin_Percent__c,Commercial_Sales__c,Commission_Master__c,
                                                             Commission_On_Non_Eligible_Amount__c,Dealer_Margin_Percent__c,Dealer_Sales__c,Eligible_Comm_w_o_Opportunity_Margin__c,
                                                             Eligible_Comm_with_Opportunity_Margin__c,Eligible_Dealer_Margin__c,Eligible_Margin__c,Employee__c,EoY_adjustment__c,
                                                             Non_Eligible_Com_with_Opportunity_Margin__c, Non_Eligible_Comm_w_o_Opportunity_Margin__c,Non_Eligible_Dealer_Margin__c,Non_Eligible_Margin__c,
                                                             Over_All_Margin_percent__c,Paid_Commission__c,Total_Commission__c,Total_Margin__c,Total_Margin_without_Split__c,Total_Sale__c from EoY_Sales_Commission__c];
        System.debug('eoYSalesCommissions ::>>>>'+JSON.serializePretty(eoYSalesCommissions));
        for(EoY_Sales_Commission__c eoySalesCommission : eoYSalesCommissions){
            string year  = String.valueOf(date.today().year());
            if(commissionMasterById.containsKey(eoySalesCommission.commission_master__c)){
                string DealerName = year+'-Sales Representative - Dealer-Commission Master';
                string AnDName = year+'-Sales Representative - A&D-Commission Master';
                string ContractorName = year+'-Sales Representative - Contractor-Commission Master';
                if(commissionMasterById.get(eoySalesCommission.commission_master__c).Name == DealerName ||  commissionMasterById.get(eoySalesCommission.commission_master__c).Name == ContractorName){
                    eoYSalesCommissionByIdForDealerContractor.put(eoySalesCommission.Id, eoySalesCommission);
                }
                else if(commissionMasterById.get(eoySalesCommission.commission_master__c).Name == AnDName){
                    eoYSalesCommissionByIdForAnd.put(eoySalesCommission.Id, eoySalesCommission);
                }
            }
        }
        List<Commission_Tier__c> commissionTiers = [Select Id,Name,lower_Amount__c,upper_Amount__c,
                                                    Profile_Type__c,tier_type__c,commission_percentage__c,
                                                    commission_master__c from Commission_Tier__c];
        Map<Id,List<Commission_Tier__c>> commissionTiersByCommissionMaster = new Map<Id,List<Commission_Tier__c>>();
        for(Commission_Tier__c commissionTier : commissionTiers){
            if(commissionTiersByCommissionMaster.containsKey(commissionTier.Commission_Master__c)) {
                commissionTiersByCommissionMaster.get(commissionTier.Commission_Master__c).add(commissionTier);
            }
            else {
                commissionTiersByCommissionMaster.put(commissionTier.Commission_Master__c, new List<Commission_Tier__c>{commissionTier});
            }   
        }        
        Map<Id,Monthly_Commission__c> monthlyCommissionByEOYSales = new Map<Id,Monthly_Commission__c>();
        List<Monthly_Commission__c> monthlyCommissionlist = [SELECT Id, Name, Employee__c, Cumulative_Total_Margin__c,
                                                             Total_Invoice_Ancillary_Margin__c,Total_Commission__c,Total_Invoice_Tile_Margin__c,
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
        
        for(Monthly_Commission__c monthCom : monthlyCommissionlist){
            monthlyCommissionByEOYSales.put(monthCom.EoY_Sales_Commission__c, monthCom); 
        } 
        
        List<GP_percent_target__c> gpPercentTargets = [Select Id,Name,type__c,Target_Percent__c,Profile_Type__c,commission_master__c from GP_percent_target__c];
        Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster = new Map<Id,Map<String,Decimal>>();
        for(GP_percent_target__c gpPercent : gpPercentTargets){
            if(targetByTypeByCommissionMaster.containsKey(gpPercent.Commission_Master__c)){
                targetByTypeByCommissionMaster.get(gpPercent.Commission_Master__c).put(gpPercent.Type__c,gpPercent.Target_Percent__c);
            }
            else{
                targetByTypeByCommissionMaster.put(gpPercent.Commission_Master__c,new Map<String,Decimal>{gpPercent.Type__c => gpPercent.Target_Percent__c});
            }  
        } 
        Map<Id,List<EoY_GP_Target_Bonus__c>> eoYGpTargetBonusByCommissionMaster = new   Map<Id,List<EoY_GP_Target_Bonus__c>>();  
        List<EoY_GP_Target_Bonus__c> eoYGpTargetBonuslist = [SELECT Id, Name, Amount__c, Bonus__c, Commission_Master__c,
                                                             Profile_Type__c FROM EoY_GP_Target_Bonus__c ];  
        
        for(EoY_GP_Target_Bonus__c eoYGpTargetBonus : eoYGpTargetBonuslist){
            if(eoYGpTargetBonusByCommissionMaster.containsKey(eoYGpTargetBonus.Commission_Master__c)) {
                eoYGpTargetBonusByCommissionMaster.get(eoYGpTargetBonus.Commission_Master__c).add(eoYGpTargetBonus);
            }
            else {
                eoYGpTargetBonusByCommissionMaster.put(eoYGpTargetBonus.Commission_Master__c, new List<EoY_GP_Target_Bonus__c>{eoYGpTargetBonus});
            }  
        } 
         List<EOY_Margin_Target__c> eoYMarginTargets = [Select Id,Name,Profile_Type__c,Target__c,Type__c,Commission_Master__c from EOY_Margin_Target__c];
        Map<Id,Map<String,Decimal>> eoyMarginTargetByTypeByCommissionMaster = new Map<Id,Map<String,Decimal>>();
        for(EOY_Margin_Target__c eoYMarginTarget : eoYMarginTargets){
            if(eoyMarginTargetByTypeByCommissionMaster.containsKey(eoYMarginTarget.Commission_Master__c)){
                eoyMarginTargetByTypeByCommissionMaster.get(eoYMarginTarget.Commission_Master__c).put(eoYMarginTarget.Type__c,eoYMarginTarget.Target__c);
            }
            else{
                eoyMarginTargetByTypeByCommissionMaster.put(eoYMarginTarget.Commission_Master__c,new Map<String,Decimal>{eoYMarginTarget.Type__c => eoYMarginTarget.Target__c});
            }  
        }
        system.debug('monthlyCommissionByEOYSales'+JSON.serialize(monthlyCommissionByEOYSales));
        //system.debug('eoYSalesCommissionById'+JSON.serialize(eoYSalesCommissionById));
        system.debug('commissionMasterById'+JSON.serialize(commissionMasterById));
        system.debug('commissionTiersByCommissionMaster'+JSON.serialize(commissionTiersByCommissionMaster));
        system.debug('targetByTypeByCommissionMaster'+JSON.serialize(targetByTypeByCommissionMaster));
        system.debug('eoYGpTargetBonusByCommissionMaster'+JSON.serialize(eoYGpTargetBonusByCommissionMaster));
        system.debug('eoyMarginTargetByTypeByCommissionMaster'+JSON.serialize(eoyMarginTargetByTypeByCommissionMaster));
        Test.startTest();
        List<EOY_sales_commission__c> eoySalesCommissionsfirst = EOYSalesCommissionHandler.eOYSalesRepAnD(monthlyCommissionByEOYSales,eoYSalesCommissionByIdForAnd,commissionMasterById,commissionTiersByCommissionMaster,targetByTypeByCommissionMaster,eoYGpTargetBonusByCommissionMaster);
        system.debug('eoySalesCommissionsfirst==>'+JSON.serialize(eoySalesCommissionsfirst));
        system.debug('commissionTiersByCommissionMaster==>'+JSON.serialize(commissionTiersByCommissionMaster));
        List<EOY_sales_commission__c> eoySalesCommissionssecound = EOYSalesCommissionHandler.eOYSalesRepDealerAndContractor(monthlyCommissionByEOYSales, eoYSalesCommissionByIdForDealerContractor, commissionMasterById, commissionTiersByCommissionMaster, targetByTypeByCommissionMaster, eoYGpTargetBonusByCommissionMaster, eoyMarginTargetByTypeByCommissionMaster);
        Test.stopTest();
    }
}