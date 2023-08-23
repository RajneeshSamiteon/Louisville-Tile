public without sharing class MC_UserDetailsController {
    
    @AuraEnabled
    public static CommissionStructure getCommissionStructureByUserId(String userProfileName){
        try{     
            Id recordType = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get(userProfileName).getRecordTypeId();
            Commission_Master__c commissionMaster = CommissionMasterSelector.getCommissionMasterByRecordType(recordType);
            Set<Id> commissionMasterIds = new Set<Id>{commissionMaster.Id};
                return  new CommissionStructure(commissionMaster,
                                                CommissionTierSelector.getCommissionTierByCommissionMasters(commissionMasterIds),
                                                EoYGPBonusTargetSelector.getEoYGPBonusTargetByCommissionMasters(commissionMasterIds),
                                                GPPercentTargetSelector.getGPPercentTargetByCommissionMasters(commissionMasterIds),
                                                EOYMarginTargetSelector.getEoyMarginTargetByCommissionMaster(commissionMasterIds));
            
        }
        catch(Exception err){
            System.debug('Exp===>'+err.getMessage());
            throw new AuraHandledException(err.getMessage() +'Trace'+ err.getStackTraceString());
        }
    }
    
    public class CommissionStructure{
        @AuraEnabled public Commission_Master__c commissionMaster {get;set;}
        @AuraEnabled public List<Commission_Tier__c> commissionTiers {get;set;}
        @AuraEnabled public List<EoY_GP_Target_Bonus__c> eoyBonusTarget {get;set;}
        @AuraEnabled public List<GP_Percent_Target__c> gpPercentTargets {get;set;}
        @AuraEnabled public List<EOY_Margin_Target__c> eoyMarginTargets {get;set;}
        
        public CommissionStructure(Commission_Master__c commissionMaster,
                                   List<Commission_Tier__c> commissionTiers,
                                   List<EoY_GP_Target_Bonus__c> eoyBonusTarget,
                                   List<GP_Percent_Target__c> gpPercentTargets,
                                   List<EOY_Margin_Target__c> eoyMarginTargets){
                                       this.commissionMaster = commissionMaster;
                                       this.commissionTiers = commissionTiers;
                                       this.eoyBonusTarget = eoyBonusTarget;
                                       this.gpPercentTargets = gpPercentTargets;
                                       this.eoyMarginTargets = eoyMarginTargets;
                                   }
    }
}