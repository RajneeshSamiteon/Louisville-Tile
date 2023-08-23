declare module "@salesforce/apex/DealerProfileController.getMetaDataRecords" {
  export default function getMetaDataRecords(): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getOpportunityPipeLine" {
  export default function getOpportunityPipeLine(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.fetchOnLoadConfigration" {
  export default function fetchOnLoadConfigration(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.fetchOnLoadConfigrationbyAccountId" {
  export default function fetchOnLoadConfigrationbyAccountId(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getAccountsById" {
  export default function getAccountsById(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getAllDealerProfiles" {
  export default function getAllDealerProfiles(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getAllBuilderProfiles" {
  export default function getAllBuilderProfiles(param: {accountId: any, category: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getRecordsbyAccountAndCategory" {
  export default function getRecordsbyAccountAndCategory(param: {accountId: any, category: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getDealerProfileRecord" {
  export default function getDealerProfileRecord(param: {selectedYear: any, accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getDealerProfileRecordforLastFourCategories" {
  export default function getDealerProfileRecordforLastFourCategories(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.saveDisplayItems" {
  export default function saveDisplayItems(param: {displayItemJSON: any, accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getDisplayItem" {
  export default function getDisplayItem(param: {objType: any, currentYear: any, accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.saveBuilderRecord" {
  export default function saveBuilderRecord(param: {builderRecordsJSON: any, builderFlooringsJSON: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.getRecordByYear" {
  export default function getRecordByYear(param: {selectedYear: any, recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/DealerProfileController.saveDealerProfileRecord" {
  export default function saveDealerProfileRecord(param: {dealerProfileJSON: any, accountId: any}): Promise<any>;
}
