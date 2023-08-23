@isTest
public class LouisvilleConfigurationSelectorTest {
    
    @isTest
    static void getRecordsByCategoryTest(){
        test.startTest();
        List<LouisvilleConfiguration__mdt> Configurationmdt=LouisvilleConfigurationSelector.getRecordsByCategory(new Set<String>{'Dealer Profile'});
        test.stopTest();  
    }
    @isTest
    static void getValuesFromdeveloperNameTest(){
        test.startTest();
        List<LouisvilleConfiguration__mdt> Configurationmdt=LouisvilleConfigurationSelector.getValuesFromdeveloperName(new Set<String>{'Dealer Profile'});
        test.stopTest();  
    }
}