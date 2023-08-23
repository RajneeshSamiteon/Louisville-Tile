@isTest
public class KeyReportSelectorTest {
 
    @isTest
    static void getkeyReportsByIdTest(){
     Set<Id> keyReportIds = new Map<Id, Key_Report__c>([select id from Key_Report__c]).keySet();
        List<Key_Report_Assignment__c> keyReport2=KeyReportSelector.getKeyReportAssignmentByReportTypeAndLoginUser('Test');
        List<Key_Report__c> keyReport3=KeyReportSelector.getAllMasterRecordByType('Test');
		List<Key_Report_Assignment__c> keyReport4=KeyReportSelector.getKeyReportsAssignmentsByKeyReportidsAndTypeAndLoginUser(keyReportIds,'Test');
        List<Key_Report__c> keyReport5=KeyReportSelector.getAllMasterRecordByName(new Set<String>{'Test'});
    }
}