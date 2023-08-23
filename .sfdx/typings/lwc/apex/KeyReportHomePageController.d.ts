declare module "@salesforce/apex/KeyReportHomePageController.getRecorTypes" {
  export default function getRecorTypes(): Promise<any>;
}
declare module "@salesforce/apex/KeyReportHomePageController.getAllReportByLoginUser" {
  export default function getAllReportByLoginUser(param: {reportType: any}): Promise<any>;
}
declare module "@salesforce/apex/KeyReportHomePageController.getAllMasterReports" {
  export default function getAllMasterReports(param: {reportType: any}): Promise<any>;
}
declare module "@salesforce/apex/KeyReportHomePageController.saveKerridgeReports" {
  export default function saveKerridgeReports(param: {unSelectedIds: any, selectedIds: any, reportType: any}): Promise<any>;
}
