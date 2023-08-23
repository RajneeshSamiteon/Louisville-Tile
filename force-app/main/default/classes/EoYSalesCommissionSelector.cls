public class EoYSalesCommissionSelector {
    public static List<EoY_Sales_Commission__c> EoysalesCommissionsByUser(set<id> userIds){
        return [SELECT Id, OwnerId, Bonus__c, Eligible_Margin__c, EoY_adjustment__c, Over_All_Margin_percent__c, Paid_Commission__c, CreatedDate, Total_Commission__c, Total_Margin__c, Employee__c, Commission_Master__c, Name FROM EoY_Sales_Commission__c where Employee__c in: userIds and CreatedDate = THIS_YEAR];
    }
    public static Map<Id,EoY_Sales_Commission__c> GetEoysalesCommissions(set<id> salesCommissionId){
        Map<Id,EoY_Sales_Commission__c> eoySales = new Map<Id,EoY_Sales_Commission__c>([SELECT Id, OwnerId, Bonus__c, Eligible_Margin__c, 
                                                                                        EoY_adjustment__c, Over_All_Margin_percent__c, 
                                                                                        Paid_Commission__c, CreatedDate, Total_Commission__c, 
                                                                                        Total_Margin__c,Total_Margin_Without_Split__c, Employee__c, Commission_Master__c,Commission_Master__r.recordtype.name, Name 
                                                                                        FROM EoY_Sales_Commission__c where id in: salesCommissionId 
                                                                                       ]);
        return eoySales;
    }
    
    public static Map<Id,Eoy_Sales_Commission__c> getEoySalesCommissionById(Set<Id> eoySalesCommissions){
        return new Map<Id,EoY_Sales_Commission__c>([SELECT Bonus__c, Commission_Master__c, Eligible_Margin__c, Employee__c, 
                                                    EoY_adjustment__c, Non_Eligible_Margin__c, Over_All_Margin_percent__c, 
                                                    Paid_Commission__c, Total_Commission__c, Total_Margin__c, Total_Sale__c, 
                                                    Total_Margin_without_Split__c, Id, Employee__r.profile.name, Name, Dealer_Sales__c, Commercial_Sales__c 
                                                    FROM EoY_Sales_Commission__c
                                                    WHERE Id IN : eoySalesCommissions]);
        
    }
    
    public static list<EoY_Sales_Commission__c> getEoysalesCommissionsByUserId(Id userId){
        return [SELECT Id, OwnerId, Bonus__c, Eligible_Margin__c,EoY_adjustment__c, Over_All_Margin_percent__c, 
                Paid_Commission__c, CreatedDate, Total_Commission__c, 
                Total_Margin__c, Employee__c, Commission_Master__c,Commission_Master__r.recordtype.name, Name 
                FROM EoY_Sales_Commission__c WHERE  employee__c =: userId ORDER BY CreatedDate DESC ];
    }
}