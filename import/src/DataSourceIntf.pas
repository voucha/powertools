unit DataSourceIntf;

interface

uses
  System.SysUtils, System.Classes,  Winapi.Windows, ZDataset, Customers;

type
  IImportDataSource = interface
    function  showConnectionSetting(ParentHandle: HWND): Boolean;
    procedure Connect;
    procedure Disconnnect;
    procedure getCustomerDataset(Query: TZQuery);
    procedure fetchCustomerRecord(Query: TZQuery; var Value: TCustomerRecord);
  end;

  IImportDataTarget = interface
    function  showConnectionSetting(ParentHandle: HWND): Boolean;
    procedure Connect;
    procedure Disconnnect;
    procedure emptyTable;

    function addCustomer(var Data:TCustomerRecord):Boolean;
    function addMsisdn(Data:TCustomerRecord):Boolean;

    function setCustomerBalance(Data: TCustomerRecord):Boolean;
    function getCustomerByMsisdn(const MSISDN: string; var Data:
      TCustomerRecord):Boolean;
    function generateMetaPath(var Data:TCustomerRecord):Boolean;
  end;

implementation

end.
