public class CommissionCalculatorConstants {
    public static final String ITEMGROUPTILE='Tile';
    public static final String ITEMGROUPANCILLARY='Ancillary';
    public static final String RETROACTIVE='Retroactive';
    public static final String MARGINAL='Marginal';
    public static final Map<Integer,String> MONTHBYNUMBER = new Map<Integer,String>{1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
        7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'};
    public static final Decimal MARGINPERCENTFOROPPWITHNOSPLITS =  100;   
    public static final Decimal MARGINPERCENTFORACCOUNTS =  100;  
    public static final String REPTYPEAD = 'Sales Representative - A&D';
    public static final String REPTYPEDEALER = 'Sales Representative - Dealer';
    public static final String REPTYPECONTRACTOR = 'Sales Representative - Contractor';
    public static final List<String> PROFILENAMES = new List<string>{'SALES REPRESENTATIVE - A&D','SALES REPRESENTATIVE - DEALER','SALES REPRESENTATIVE - CONTRACTOR'};
        public static final List<String> DEALERGROUP = new List<String>{'RESIDENTIAL CONTRACTOR' , 'BUCKET & TROWEL' , 'BUILDER' , 'DEALER' , 'NATIONAL ACCOUNT' , 'OTHER' , 'ARCHITECT' , 'INTERIOR DESIGNER' , 'KITCHEN & BATH' , 'PROPERTY OWNER' , 'RETAIL'};
            public static final List<String> CONTRACTORGROUP = new List<String>{'COMMERCIAL CONTRACTOR'};
                public static final String COMMERCIALCONTRACTOR = 'Commercial Contractor';
    public static final String DEALER = 'Dealer';
    public static final String CONTRACTOR = 'Contractor';
}