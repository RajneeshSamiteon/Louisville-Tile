public class OrgWideEmailAddressSelector {

    public static List<OrgWideEmailAddress> getOrgWideEmailAddress() {
        return [SELECT Id,Address FROM OrgWideEmailAddress WHERE Address =: System.Label.Credit_Form_Email];
    }
    
}