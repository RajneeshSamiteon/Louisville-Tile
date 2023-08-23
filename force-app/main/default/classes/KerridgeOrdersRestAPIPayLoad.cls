public class KerridgeOrdersRestAPIPayLoad {
    public List<KerridgeOrders> kerridgeOrders;
    
    public class KerridgeOrders {
        public String orderName;
        public String SalesforceId;
        public String KerridgeOrder;
        public String kerridgeQuote;
        public String kerridgeAccount;
        public String status;
        public integer HReference;
        public String SelectionSheetId;
        public datetime dateCreatedInKerridge;
        public date orderStartDate;
        public date shipDate;
        public datetime DateLastModifiedInKerridge;
    }
    
    public List<KerridgeOrdersLine> kerridgeOrdersLine;
    
    public class KerridgeOrdersLine {
        public String kerridgeOrderLineName;
        public String KerridgeOrderId;
        public integer HReference;
        public integer DLine;
        public String LineitemID;
        public String quantity;
        public String LineDescription;
        public String productName;
        public String kerridgeOrder;
        public Double listPrice;
        public Date lineShipDate;
        public boolean formatStatus;
    }
    
    public List<KerridgeQuote> kerridgeQuote;
    
    public class KerridgeQuote {
        public String SalesforceId;
        public String kerridgeQuoteName;
        public datetime dateCreatedInCqm;
        public datetime dateLastModifiedInCqm;
        public String kerridgeQuoteNumber;
        public String sequenceToShowMultipleQuotes;
        public datetime expirationDate;
        public Integer KeyId;
    }
    
    public List<KerridgeQuotesLine> kerridgeQuotesLine;

	public class KerridgeQuotesLine {
		public String kerridgeQuoteLineName;
		public String lineItemDescription;
		public Double listPrice;
		public String productName;
		public String quantity;
		public String quote;
        public String QuoteId;//Intege
	}

    public List<SelectionSheet> selectionSheet;

	public class SelectionSheet {
		public String name;
        public String SalesforceId;
		public String selectId;
		public date dateLastModifiedInSSM;
		public date dateCreatedInSSM;
		public String uom;
		public String status;
		public String quantity;
		public String productName;
		public String ssLineNumber;
		public String ssmCustId;
	}

    public static KerridgeOrdersRestAPIPayLoad parse(String json) {
        return (KerridgeOrdersRestAPIPayLoad) System.JSON.deserialize(json, KerridgeOrdersRestAPIPayLoad.class);
    }
}