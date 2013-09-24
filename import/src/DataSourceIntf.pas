unit DataSourceIntf;

interface

uses
  System.SysUtils, System.Classes,  Winapi.Windows, ZDataset, Customers;

type
  IImportDataSource = interface
    procedure getCustomerDataset(Query: TZQuery);
    procedure fetchCustomerRecord(Query: TZQuery; var Value: TCustomerRecord);
    function showConnectionSetting(ParentHandle: HWND): Boolean;
  end;

  IImportDataTarget = interface
    function getCustomerByMsisdn(const MSISDN: string; var Data:
      TCustomerRecord):Boolean;
    function setCustomerBalance(Data: TCustomerRecord):Boolean;
    function addNewCustomer(var Data: TCustomerRecord):Boolean;
  end;

implementation

end.
