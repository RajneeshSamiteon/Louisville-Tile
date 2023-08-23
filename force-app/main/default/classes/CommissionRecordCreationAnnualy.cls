public class CommissionRecordCreationAnnualy {
    public static void createRecord(Map<String,integer> yearsByRecordCount){
        Map<string,Map<string,Commission_Master__c>> commissionMasterByProfileNameByYear = new Map<string,Map<string,Commission_Master__c>>();
        system.debug('CommissionMaster==>'+JSON.serialize([SELECT id , name ,recordtype.name from Commission_Master__c]));
        for(Commission_Master__c commissionMaster : [SELECT id , name ,recordtype.name from Commission_Master__c]){
            string commissionMasterYear = commissionMaster.Name.split('-')[0];
            system.debug('year and data==>'+commissionMasterYear);
            if(commissionMasterByProfileNameByYear.containsKey(commissionMaster.recordtype.name)){
                if(commissionMasterByProfileNameByYear.get(commissionMaster.recordtype.name).containsKey(commissionMasterYear) == false){
                    commissionMasterByProfileNameByYear.get(commissionMaster.recordtype.name).put(commissionMasterYear , commissionMaster);
                }
            }
            else{
                commissionMasterByProfileNameByYear.put(commissionMaster.recordtype.name , new Map<string,Commission_Master__c>{commissionMasterYear => commissionMaster});
            }
        }
        system.debug('commissionMasterByProfileNameByYear'+JSON.serialize(commissionMasterByProfileNameByYear));
        list<eoy_sales_commission__c> eoySalesCommissions = new List<eoy_sales_commission__c>();
        for(user userIns : [SELECT id , Name , profile.name,profileId ,dont_calculate_commission__c from User where Profile.Name in : CommissionCalculatorConstants.PROFILENAMES and dont_calculate_commission__c = False]){
            for(string year : yearsByRecordCount.keySet()){
                eoy_sales_commission__c eoySalesCommission = new eoy_sales_commission__c();
                eoySalesCommission.name = userIns.name+'-'+year;
                eoySalesCommission.Commission_On_Non_Eligible_Amount__c = 0;
                eoySalesCommission.Commercial_Margin_Percent__c = 0;
                eoySalesCommission.Dealer_Margin_Percent__c = 0;
                eoySalesCommission.Non_Eligible_Comm_w_o_Opportunity_Margin__c = 0;
                eoySalesCommission.Eligible_Comm_w_o_Opportunity_Margin__c = 0;
                eoySalesCommission.Non_Eligible_Com_with_Opportunity_Margin__c = 0;
                eoySalesCommission.Eligible_Comm_with_Opportunity_Margin__c = 0;
                eoySalesCommission.Non_Eligible_Dealer_Margin__c = 0;
                eoySalesCommission.Eligible_Dealer_Margin__c = 0;
                eoySalesCommission.Non_Eligible_Margin__c = 0;
                eoySalesCommission.Total_Sale__c = 0;
                system.debug('NAme==>'+userIns.profile.name);
                if(commissionMasterByProfileNameByYear.containsKey(userIns.profile.name)){
                    if(commissionMasterByProfileNameByYear.get(userIns.profile.name).containsKey(year))
                    {
                        system.debug('inLoop==>'+commissionMasterByProfileNameByYear.get(userIns.profile.name).get(year).recordType.Name);
                        system.debug('NAme==>'+userIns.name);
                        eoySalesCommission.employee__c = userIns.id;
                        eoySalesCommission.Commission_Master__c = commissionMasterByProfileNameByYear.get(userIns.profile.name).get(year).id;
                        system.debug('CommissionMaster==>'+eoySalesCommission.Commission_Master__c);
                    }
                }
                eoySalesCommission.Total_Margin__c = 0;
                eoySalesCommission.Total_Commission__c = 0;
                eoySalesCommission.Paid_Commission__c = 0;
                eoySalesCommission.Over_All_Margin_percent__c = 0;
                eoySalesCommission.EoY_adjustment__c = 0;
                eoySalesCommission.Eligible_Margin__c = 0;
                eoySalesCommission.Bonus__c = 0;
                eoySalesCommissions.add(eoySalesCommission);
            }            
        }
        system.debug('eoySalesCommissions==>'+JSON.serialize(eoySalesCommissions));
        insert eoySalesCommissions;
        List<string> months = CommissionCalculatorConstants.MONTHBYNUMBER.values();
        system.debug('months==>'+months);
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>();
        for(eoy_sales_commission__c eoyCommission : eoySalesCommissions){
            for (string year : yearsByRecordCount.keySet()){
                for(integer i=0;i<yearsByRecordCount.get(year);i++){
                    Monthly_Commission__c obj = new Monthly_Commission__c();
                    obj.name = eoyCommission.name.split('-')[0]+'-'+months[i]+'-'+year;
                    obj.eoy_sales_commission__c = eoyCommission.id;
                    obj.Employee__c = eoyCommission.Employee__c;
                    obj.Actual_Commission_Earned__c=0;
                    obj.Ancillary_Margin_Percent__c=0;
                    obj.Ancillary_Margin__c=0;
                    obj.Ancillary_Sale__c=0;
                    obj.Cost__c=0;
                    obj.Cumulative_Ancillary_Margin__c=0;
                    obj.Cumulative_Eligible_Margin__c=0;
                    obj.Cumulative_Tile_Margin__c=0;
                    obj.Cumulative_Total_Margin__c=0;
                    obj.Cumulative_Total_Sale__c=0;
                    obj.Eligible_Margin__c=0;
                    obj.Margin__c=0;
                    obj.Not_Elligible_Margin__c=0;
                    obj.Paid_Commission__c=0;
                    obj.Previous_Ancillary_Margin__c=0;
                    obj.Previous_Eligible_Margin__c=0;
                    obj.Previous_Tile_Margin__c=0;
                    obj.Previous_Total_Margin__c=0;
                    obj.Previous_Total_Sale__c=0;
                    obj.Price__c=0;
                    obj.Target_Met__c=false;
                    obj.Tile_Margin_Percent__c=0;
                    obj.Tile_Margin__c=0;
                    obj.Tile_Sale__c=0;
                    obj.Total_Commission__c=0;
                    obj.Total_Invoice_Ancillary_Margin__c=0;
                    obj.Total_Invoice_Tile_Margin__c=0;
                    obj.Total_Sale__c=0;
                    monthlyCommissions.add(obj);
                }
            }
        }
        system.debug('monthlyCommissions'+JSON.serialize(monthlyCommissions));
        //system.debug('DATAFactory==>'+JSON.serialize(DataFactory.getsObjectsByFieldId(monthlyCommissions , 'Employee__c')));
        insert monthlyCommissions;
    }
}