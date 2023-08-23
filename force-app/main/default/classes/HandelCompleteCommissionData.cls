public class HandelCompleteCommissionData {
    public static List<Monthly_Commission__c> monthlyCommissionForAnnual(string year){
        List<User> activeUsers = new List<User>([SELECT id, name ,profile.Name from User where dont_calculate_commission__c =false and profile.name in:CommissionCalculatorConstants.PROFILENAMES]);
        List<string> userNameToCalculateCommission = new List<String>();
        List<String> months = new List<String>();
        months.addAll(CommissionCalculatorConstants.MONTHBYNUMBER.values());
        for(User userIns : activeUsers){
            for(string month :months){
                userNameToCalculateCommission.add(userIns.name+'-'+month+'-'+year);
            }
        }
        system.debug('User Name ==>'+JSON.serialize(userNameToCalculateCommission));
        system.debug('Users ==>'+JSON.serialize(activeUsers));
        List<Monthly_Commission__c> monthlyCommissions = new List<Monthly_Commission__c>([SELECT Id ,name ,EoY_Sales_Commission__r.Commission_Master__c,employee__r.profile.name,EoY_Sales_Commission__c, Actual_Commission_Earned__c, Ancillary_Margin_Percent__c, Ancillary_Margin__c, Ancillary_Sale__c, Cost__c, Cumulative_Ancillary_Margin__c, Cumulative_Eligible_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Total_Margin__c, Cumulative_Total_Sale__c, Date__c, Eligible_Margin__c, Month__c, Margin__c, Employee__c, Not_Elligible_Margin__c, Paid_Commission__c, Previous_Ancillary_Margin__c, Previous_Eligible_Margin__c, Previous_Tile_Margin__c, Previous_Total_Margin__c, Previous_Total_Sale__c, Price__c, Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, Tile_Sale__c, Total_Commission__c, Total_Invoice_Ancillary_Margin__c, Total_Invoice_Tile_Margin__c, Total_Sale__c, Payable_Commission__c, Total_Margin_Without_Split__c, Total_Sale_After_Split__c, Commercial_W_O_Opportunity_Commission__c, Commercial_with_Opportunity_Commission__c, Commercial_with_Opportunity_Sales__c, Commercial_without_Opportunity_Sales__c, Cum_Eligible_Comm_W_O_Opp_Amount__c, Cum_Eligible_Comm_W_Opp_Amount__c, Cum_Non_Eligible_Comm_W_O_Opp_Amount__c, Cum_Non_Eligible_Comm_W_Opp_Amount__c, Cumulative_Eligible_Dealer_Amount__c, Cumulative_Non_Eligible_Dealer_Amount__c, Dealer_Commission__c, Dealer_Sales__c, Eligible_Comm_w_o_Opportunity_Amount__c, Eligible_Comm_with_Opportunity_Amount__c, Eligible_Dealer_Amount__c, Non_Eligible_Com_with_Opportunity_Amount__c, Non_Eligible_Comm_w_o_Opportunity_Amount__c, Non_Eligible_Dealer_Amount__c, Pre_Eligible_Comm_W_O_Opp_Amount__c, Pre_Eligible_Comm_W_Opp_Amount__c, Pre_Non_Eligible_Comm_W_O_Opp_Amount__c, Pre_Non_Eligible_Comm_W_Opp_Amount__c, Pre_Non_eligible_Dealer_Amount__c, Pre_eligible_Dealer_Amount__c, Total_Commercial_Sales__c FROM Monthly_Commission__c where name in: userNameToCalculateCommission]);
        system.debug('User monthlyCommissions ==>'+JSON.serialize(monthlyCommissions));
        for(Monthly_commission__c com : monthlyCommissions){
            com.Cumulative_Ancillary_Margin__c =0;
            com.Cumulative_Tile_Margin__c =0;
            com.Cumulative_Total_Sale__c =0;
            com.Previous_Ancillary_Margin__c =0;
            com.Previous_Eligible_Margin__c =0;
            com.Previous_Tile_Margin__c =0;
            com.Previous_Total_Margin__c =0;
            com.Previous_Total_Sale__c =0;
            com.Paid_Commission__c =0;
            com.Total_Commission__c =0;
        }
        system.debug('monthlyCommissions ==>'+JSON.serialize(monthlyCommissions));
        List<string> profilNames = new List<String>();
        Set<id> commissionMasterIds = new Set<Id>();
        Map<string,Map<string,List<monthly_commission__c>>> monthlyCommissionByProfileByMonth = new Map<String,Map<String,List<monthly_commission__c>>>();
        Map<String, List<Monthly_Commission__c>> monthlyCommissionsByProfileName = new Map<String,List<Monthly_Commission__c>>();
        for(monthly_commission__c monthlyCommission : monthlyCommissions){
            if(monthlyCommissionsByProfileName.containsKey(monthlyCommission.employee__r.profile.name)){
                monthlyCommissionsByProfileName.get(monthlyCommission.employee__r.profile.name).add(monthlyCommission);
            }
            else{
                monthlyCommissionsByProfileName.put(monthlyCommission.employee__r.profile.name , new List<Monthly_Commission__c>{monthlyCommission});
                profilNames.add(monthlyCommission.employee__r.profile.name);
                commissionMasterIds.add(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c);
            }
        }
        for(String profilName : profilNames){
            monthlyCommissionByProfileByMonth.put(profilName , arrangeMonthlyCommissionByMonths(monthlyCommissionsByProfileName.get(profilName)));
        }
        List<Monthly_Commission__c> monthlyCommissionsToBeUpdated = new List<Monthly_Commission__c>();
        Map<Id,Commission_Master__c> commissionMasterById = new Map<Id,Commission_Master__c>();
        Map<Id,List<commission_tier__c>> commissionTierByCommissionMaster = new Map<Id,List<commission_tier__c>>();
        commissionMasterById = CommissionMasterSelector.getCommissionMasterById(commissionMasterIds);
        commissionTierByCommissionMaster = DataFactory.getsObjectsByFieldId(CommissionTierSelector.getCommissionTierByCommissionMasters(commissionMasterIds),'Commission_Master__c');
        for(Integer i=1;i<=12;i++){
            integer j=i+1;
            ///////////////////////////////// A&D
            if(monthlyCommissionByProfileByMonth.containsKey(CommissionCalculatorConstants.REPTYPEAD)){
                if(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).containsKey(CommissionCalculatorConstants.MONTHBYNUMBER.get(i))){
                    if(i<12){
                        List<monthly_commission__c> selectedMonthlyCommission = new List<Monthly_Commission__c>();
                        List<monthly_commission__c> updatedMonthlyCommission = new List<Monthly_Commission__c>();
                        selectedMonthlyCommission.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));
                        selectedMonthlyCommission.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(j)));
                        updatedMonthlyCommission.addall(EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation( datafactory.getsObjectsByFieldId(selectedMonthlyCommission,'employee__c')  ,commissionMasterById,commissionTierByCommissionMaster));
                        //monthlyCommissionsToBeUpdated.addall(updatedMonthlyCommission);
                        Map<string , List<monthly_commission__c>> updatedCommissionRecord = arrangeMonthlyCommissionByMonths(updatedMonthlyCommission);
                        monthlyCommissionsToBeUpdated.addall(updatedCommissionRecord.get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));
                        for(string monthName : updatedCommissionRecord.keySet()){
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).get(monthName).clear();
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).get(monthName).addAll(updatedCommissionRecord.get(monthName));
                        }
                        selectedMonthlyCommission.clear();
                    }
                    else if(i==12){
                        monthlyCommissionsToBeUpdated.addall(EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation(datafactory.getsObjectsByFieldId(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEAD).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)),'employee__c'),commissionMasterById , commissionTierByCommissionMaster));
                    }
                    
                }
            }
            else{
                system.debug('No data For '+CommissionCalculatorConstants.REPTYPEAD+' for month of ==>'+CommissionCalculatorConstants.MONTHBYNUMBER.get(i));
            }
            ///////////////////////////////// Dealer
            if(monthlyCommissionByProfileByMonth.containsKey(CommissionCalculatorConstants.REPTYPEDEALER)){
                if(i<12){
                    List<monthly_commission__c> updatedMonthlyCommission = new List<Monthly_Commission__c>();
                    if(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).containsKey(CommissionCalculatorConstants.MONTHBYNUMBER.get(i))){
                        List<monthly_commission__c> selectedMonthlyCommissionDealer = new List<Monthly_Commission__c>();
                        selectedMonthlyCommissionDealer.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));
                        selectedMonthlyCommissionDealer.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(j)));
                        updatedMonthlyCommission.addall(DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps(datafactory.getsObjectsByFieldId(selectedMonthlyCommissionDealer,'employee__c')  ,commissionMasterById,commissionTierByCommissionMaster));
                        //monthlyCommissionsToBeUpdated.addAll(updatedMonthlyCommission);
                        Map<string , List<monthly_commission__c>> updatedCommissionRecord = arrangeMonthlyCommissionByMonths(updatedMonthlyCommission);
                        monthlyCommissionsToBeUpdated.addall(updatedCommissionRecord.get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));                    
                        for(string monthName : updatedCommissionRecord.keySet()){
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).get(monthName).clear();
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).get(monthName).addAll(updatedCommissionRecord.get(monthName));
                        }
                        selectedMonthlyCommissionDealer.clear();
                    }
                }
                else if(i==12){
                    monthlyCommissionsToBeUpdated.addall(EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation(datafactory.getsObjectsByFieldId(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPEDEALER).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)),'employee__c'),commissionMasterById , commissionTierByCommissionMaster));
                }
            }
            else{
                system.debug('No data For '+CommissionCalculatorConstants.REPTYPEDEALER+' for month of ==>'+CommissionCalculatorConstants.MONTHBYNUMBER.get(i));
            }            
            ///////////////////////////////// Contractor
            if(monthlyCommissionByProfileByMonth.containsKey(CommissionCalculatorConstants.REPTYPECONTRACTOR)){
                if(i<12){
                    List<monthly_commission__c> updatedMonthlyCommission = new List<Monthly_Commission__c>();
                    if(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).containsKey(CommissionCalculatorConstants.MONTHBYNUMBER.get(i))){
                        List<monthly_commission__c> selectedMonthlyCommissionContrac = new List<Monthly_Commission__c>();
                        selectedMonthlyCommissionContrac.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));
                        selectedMonthlyCommissionContrac.addall(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(j)));
                        updatedMonthlyCommission.addall(DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps(datafactory.getsObjectsByFieldId(selectedMonthlyCommissionContrac,'employee__c') ,commissionMasterById,commissionTierByCommissionMaster));
                        //monthlyCommissionsToBeUpdated.addAll(updatedMonthlyCommission);
                        Map<string , List<monthly_commission__c>> updatedCommissionRecord = arrangeMonthlyCommissionByMonths(updatedMonthlyCommission);
                        monthlyCommissionsToBeUpdated.addall(updatedCommissionRecord.get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)));       
                        for(string monthName : updatedCommissionRecord.keySet()){
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).get(monthName).clear();
                            monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).get(monthName).addAll(updatedCommissionRecord.get(monthName));
                        }
                        selectedMonthlyCommissionContrac.clear();
                    }
                }
                else if(i==12){
                    monthlyCommissionsToBeUpdated.addall(EmployeeMonthlyCommissionAnDCalculation.monthlyCommissionByUserCalculation(datafactory.getsObjectsByFieldId(monthlyCommissionByProfileByMonth.get(CommissionCalculatorConstants.REPTYPECONTRACTOR).get(CommissionCalculatorConstants.MONTHBYNUMBER.get(i)),'employee__c'),commissionMasterById , commissionTierByCommissionMaster));
                }
            }
            else{
                system.debug('No data For '+CommissionCalculatorConstants.REPTYPECONTRACTOR+' for month of ==>'+CommissionCalculatorConstants.MONTHBYNUMBER.get(i));
            }
        }
        return monthlyCommissionsToBeUpdated;
    }       
    public static Map<string,List<Monthly_Commission__c>> arrangeMonthlyCommissionByMonths(List<Monthly_Commission__c> monthlyCommissions){
        Map<String,List<Monthly_Commission__c>> monthlyCommissionByMonth = new Map<String,List<Monthly_Commission__c>>();
        for(monthly_commission__c monthlyCommission : monthlyCommissions){   
            if(monthlyCommissionByMonth.containsKey(monthlyCommission.name.split('-')[1])){
                monthlyCommissionByMonth.get(monthlyCommission.name.split('-')[1]).add(monthlyCommission);
            }
            else{
                monthlyCommissionByMonth.put(monthlyCommission.name.split('-')[1] , New List<Monthly_Commission__c>{monthlyCommission});
            }
        }
        return monthlyCommissionByMonth;
    }
}