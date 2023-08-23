@isTest
public class MarginCalculationByInvoiceNTest {
	@isTest    
    public static void testMarginCalculationByInvoiceDetail(){
        list<user> Users = new list<user>();
        map<string ,id> userPrileToUserRoleId = new map<string, id>();
        map<string ,id> userPrileToUserProfileId = new map<string, id>();
        list<string> ProfileName = CommissionCalculatorConstants.profileNames;
        userPrileToUserProfileId = DataFactory.setIdbyString([SELECT id , Name from profile where Name in :ProfileName] , 'name');
        system.debug('Useretail==>'+userPrileToUserProfileId);
        userPrileToUserRoleId = DataFactory.setIdbyString([SELECT id , Name from UserRole where Name in :ProfileName] , 'name');
        map<string,list<string>> userDetail = new map<string,list<string>>{
            'Akhilesh Singh' => new list<string>{'Akhilesh','Singh','akh2ileshSingh123@gmail.com', 'Sales Representative - A&D'},
            'Dheeraj Singh' =>new list<string>{'Dheeraj','Singh','dheeraj2Singh123@gmail.com', 'Sales Representative - A&D'}
        };
            for(string userName : userDetail.keySet()){
                user userObj = new user();
                userObj.lastName = userDetail.get(userName)[1];
                userObj.Email = userDetail.get(userName)[2];
                userObj.userRoleId = userPrileToUserRoleId.get(userName);
                userObj.ProfileId = userPrileToUserProfileId.get(userDetail.get(userName)[3]); 
                System.debug('userDetail.get(userName) : '+(userDetail.get(userName)));
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
        
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
        List<Account> accounts = new List<Account>();
        for(integer i=0;i<5;i++){
            Account acc1 = new Account();
            acc1.Name = 'Test1'+String.valueOf(i);
            acc1.recordTypeId = accountRecordTypeId;
            accounts.add(acc1);  
            if(i<2){
                acc1.ownerId = users[0].id; // Akhilesh Singh Chauhan user Id
            }
            else if(i==3){
                acc1.ownerId = users[1].id; // Dheeraj testing user Id
            }
        }
        
        insert accounts;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        System.debug('oppRecordTypeIdv  '+oppRecordTypeId);
        List<Opportunity> opportunities = new List<Opportunity>();
        for(integer i=0;i<5;i++){
            Opportunity opp1 = new Opportunity();
            opp1.Name = accounts[i].name+' '+ 'Opp';
            opp1.recordTypeId = oppRecordTypeId;
            opp1.accountId = accounts[i].id;
            opp1.StageName = 'Quoting';
            opp1.CloseDate = Date.today()+23;
            opp1.branch__c = 'Lexington 060';
            opp1.Opportunity_Category__c = 'Education';
            opp1.Project_State__c = 'Alaska';
            opp1.City__c = 'Washington DC';
            if(i==2){
                opp1.ownerId = users[1].id; // Dheeraj testing user Id
            }
            opportunities.add(opp1);
        }
        
        insert opportunities;
        
        ////////////// creating Project Bidder  //////////////////////////////////////// 
        
        list<Project_Bidders__c> pojectBidders = new list<Project_Bidders__c>();
        for(opportunity opp : opportunities){            
            for(integer j=0;j<3;j++){
                Project_Bidders__c projectBiddder = new Project_Bidders__c();
                projectBiddder.opportunity__c =opp.id;
                projectBiddder.account__c =opp.accountId;
                projectBiddder.Bidder_Involvement_Date__c = date.today();
                pojectBidders.add(projectBiddder);
            }
        }
        insert pojectBidders;
        for(Project_Bidders__c proBidder : pojectBidders){
            proBidder.Winning_Bidder__c = true;
        }
        update pojectBidders;
        list<string> invoiceHeader = new List<string>{'590308','610595','591540'};
        list<invoice_detail__C> invoiceDetailData = new list<invoice_detail__C>();
        list<invoice_header__c> invoiceHeaderData = new list<invoice_header__c>();
        List<String> itemGroups = new List<String>{'Ancillary','Tile','Ancillary','Tile','Ancillary','Tile'};
            List<Decimal> itemCosts = new List<Decimal>{10913.04,64853.15,3621,61039.67,2312.18,38513.58};
                List<Decimal> itemPrices = new List<Decimal>{16529.83,103197.22,5539.13,100940.55,3317.63,60488.74};
                    integer counter =0;        
        for(integer i=0;i<3;i++)
        {
            decimal totalCost =0;
            decimal totalprice =0;
            for(integer j=0;j<2;j++){
                invoice_detail__c obj =new invoice_detail__c();
                obj.item_price__c = itemPrices[counter];
                obj.item_cost__c = itemCosts[counter];
                obj.Item_Group__c = itemGroups[counter];
                obj.invoice__c = invoiceHeader[i];
                obj.invoice_Date__C = date.today();
                if(i==0){
                	obj.Account__c = accounts[i].Id;    
                }
                else{
                	obj.Opportunity__c = opportunities[i].Id;    
                }
                
                invoiceDetailData.add(obj);
                totalprice+=obj.item_price__c;
                totalCost+=obj.item_cost__c;
                counter+=1; 
            }
            invoice_header__c header = new invoice_header__c();
            header.invoice__c = invoiceHeader[i];
            header.Account__c = accounts[i].Id;
            header.invoice_Date__C = date.today();
            header.Opportunity__c =opportunities[i].Id; 
            header.total_Cost__c  = totalCost;
            header.total_price__c  = totalprice;
            header.Bill_To_Group__c = 'Dealer';
            invoiceHeaderData.add(header);
        }

            insert invoiceHeaderData;


        map<string,id> invoiceNumeByHeader = new map<string,id>();
        for(invoice_header__c header : invoiceHeaderData){
            invoiceNumeByHeader.put(header.invoice__c , header.id);
        }
        for(invoice_detail__c detail : invoiceDetailData){
            
            detail.invoice_Header__c = invoiceNumeByHeader.get(detail.invoice__c);
        }
        try{
            insert invoiceDetailData;
        }
        catch (DMLException e){
            system.debug('Got Error');
        }
        Id recordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Test';
        commissionMaster.RecordTypeId = recordTypeId;
        commissionMaster.Percent_below_retroactive_EoY_Adj__c = 1;
        commissionMaster.Commission_percent_under_target__c = 1;
        commissionMaster.Target_for_EoY_adjustment__c = 35;
        insert commissionMaster;
        Map<string, Target_for_EoY_adjustment__mdt > targetEoYAdjustmentByProfile = new Map<string, Target_for_EoY_adjustment__mdt>();
        Map<string, Commission_under_target__mdt > commissionUnderTargetByProfile = new Map<string, Commission_under_target__mdt>();
        Map<string, Percentage_Less_then_retroactive_EOY_adj__mdt  > percentageLessThenRetroactiveByProfile = new Map<string, Percentage_Less_then_retroactive_EOY_adj__mdt>();
        // Target for EoY adjustment metadata.
        for(Target_for_EoY_adjustment__mdt targetEoy :TargetForEoYAdjustmentMetadataSelector.getEoYAdjustmentTarget()){
            
            targetEoYAdjustmentByProfile.put(targetEoy.Profile_Type__c , targetEoy);
        }
        // Commission under target metadata.
        for(Commission_under_target__mdt commissionUnderTarget :CommissionUnderTargerMetadataSelector.getCommissionPercentUnderTarget()){
            
            commissionUnderTargetByProfile.put(commissionUnderTarget.Profile_Type__c , commissionUnderTarget);
        }
        // Percentage less than retroactive EoY adjustment metadata.
        for(Percentage_Less_then_retroactive_EOY_adj__mdt percentageLessRectroActive :PercentUnderRetEoYAdjMetaDataSelector.getTargetUnderEOYAdjustment()){
            
            percentageLessThenRetroactiveByProfile.put(percentageLessRectroActive.Profile_Type__c , percentageLessRectroActive);
        }
        List<Commission_Tier__c> commissionTierList = new List<Commission_Tier__c>();
        List<GP_percent_target__c> gpPercentTargetList = new List<GP_percent_target__c>();
        List<EoY_GP_Target_Bonus__c> EoyPercenttargetList = new List<EoY_GP_Target_Bonus__c>();
        for(Tier_Levels__mdt tierLevel : TierLevelSelector.getTierLevel()){
            Commission_Tier__c tierLevelInstance = new Commission_Tier__c();
            tierLevelInstance.lower_Amount__c = tierLevel.lower_limit__c;
            tierLevelInstance.upper_Amount__c = tierLevel.upper_limit__c;
            tierLevelInstance.Profile_Type__c = tierLevel.Profile_Type__c;
            tierLevelInstance.tier_type__c = tierLevel.tier_type__c;
            tierLevelInstance.commission_percentage__c= tierLevel.commission_percentage__c;
            tierLevelInstance.commission_master__c= commissionMaster.id;
            commissionTierList.add(tierLevelInstance);            
        }
        insert commissionTierList;
        
        for(GP_Percentage_target__mdt GpPercent : GPPercentTargetMetadataSelector.getGpPercentTargetMetadata()){
            GP_percent_target__c GpPercentInstance = new GP_percent_target__c();
            GpPercentInstance.type__c = GpPercent.product_type__c;
            GpPercentInstance.Target_Percent__c = GpPercent.commission_percentage__c;
            GpPercentInstance.Profile_Type__c = GpPercent.Profile_Type__c;
            GpPercentInstance.commission_master__c= commissionMaster.id;
            gpPercentTargetList.add(GpPercentInstance);            
        }
        insert gpPercentTargetList;
        
        for(EOY_Bonus__mdt EoYBonus : EoYBonusSelector.getEoyBonusMetadata()){
            EoY_GP_Target_Bonus__c EoyPercentTargetInstance = new EoY_GP_Target_Bonus__c();
            EoyPercentTargetInstance.amount__c = EoYBonus.amount__c;
            EoyPercentTargetInstance.Bonus__c = EoYBonus.Bonus__c;
            EoyPercentTargetInstance.commission_master__c= commissionMaster.id;
            EoyPercenttargetList.add(EoyPercentTargetInstance);            
        }
        insert EoyPercenttargetList;
        
        List<EoY_Sales_Commission__c> eoYSalesCommissions = new List<EoY_Sales_Commission__c>();
        for(User user : Users){
            EoY_Sales_Commission__c eoYSalesCommission = new EoY_Sales_Commission__c();
            eoYSalesCommission.Employee__c = user.Id;
            eoYSalesCommission.Name	= user.name+'-'+date.today().year();
            eoYSalesCommission.Commission_Master__c = commissionMaster.Id;
            eoYSalesCommission.Bonus__c = 4000;
            eoYSalesCommission.Eligible_Margin__c =530000;  
            eoYSalesCommissions.add(eoYSalesCommission);   
        }
        insert eoYSalesCommissions;
        
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(EoY_Sales_Commission__c eoYSalesCommission : eoYSalesCommissions){
            for(integer i=0; i<12; i++){
                Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
                monthlyCommission.Name = user.Name+'-'+CommissionCalculatorConstants.MONTHBYNUMBER.get(date.today().month())+'-'+date.today().year(); 
                monthlyCommission.Employee__c = eoYSalesCommission.Employee__c;
                monthlyCommission.EoY_Sales_Commission__c =  eoYSalesCommission.Id;
                monthlyCommissions.add(monthlyCommission);   
            }    
        }
        insert monthlyCommissions;
        Test.startTest();
        MarginCalculationByInvoiceDetailHelper marginCalculationByInvoiceDetail = new MarginCalculationByInvoiceDetailHelper();  
        marginCalculationByInvoiceDetail.commissionCalculator(invoiceDetailData);
        Test.stopTest();
    } 
}