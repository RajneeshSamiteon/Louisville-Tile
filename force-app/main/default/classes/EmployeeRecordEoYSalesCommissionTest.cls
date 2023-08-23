@isTest
private class EmployeeRecordEoYSalesCommissionTest {
    
    @testSetup
    public static void createTestData() {
        List<String> profileName = CommissionCalculatorConstants.profileNames;
        Map<String, Id> userProfileToUserRoleId = DataFactory.setIdbyString([SELECT id, Name FROM UserRole WHERE Name IN : profileName], 'name');
        Map<String, Id> userProfileToUserProfileId = DataFactory.setIdbyString([SELECT id, Name FROM profile WHERE Name IN : profileName], 'name');

        Map<String, List<String>> userDetail = new Map<String, List<String>>{
            'Aditya Kumar' => new List<String>{'Aditya','Kumar','kumarAditya123@gmail.com', 'Sales Representative - A&D'}
        };
        
        List<User> users = new List<User>();
        if(!userProfileToUserRoleId.isempty() && !userProfileToUserProfileId.isempty())
        {
            for(String userName : userDetail.keySet()) {
                User user = new User();
                user.LastName = userDetail.get(userName)[1];
                user.Email = userDetail.get(userName)[2];
                user.userRoleId = userProfileToUserRoleId.get(userName);
                user.ProfileId = userProfileToUserProfileId.get(userDetail.get(userName)[3]);
                user.Username = userDetail.get(userName)[2];
                user.Alias = userDetail.get(userName)[1]+'0';
                user.TimeZoneSidKey = 'America/Yakutat';
                user.LocaleSidKey = 'en_US';
                user.EmailEncodingKey  = 'ISO-8859-1';
                user.LanguageLocaleKey = 'en_US';
                user.Dont_calculate_commission__c = false;
                
                users.add(user);
            }
            insert users;
        }
        Id recordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Test';
        commissionMaster.RecordTypeId = recordTypeId;
        commissionMaster.Percent_below_retroactive_EoY_Adj__c = 1;
        commissionMaster.Commission_percent_under_target__c = 1;
        commissionMaster.Target_for_EoY_adjustment__c = 35;
        insert commissionMaster;
    }
    
    @isTest
    private static void validateStart(){
        test.startTest();
        Database.executeBatch(new EmployeeRecordEoYSalesCommission());
        test.stopTest();
    }
    
    @isTest static void testEmployeeRecordEoYSalesCommission(){
        test.startTest();
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Merge Job', sch, new EmployeeRecordEoYSalesCommission());
        test.stopTest();
    }
    
}