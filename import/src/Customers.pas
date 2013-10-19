unit Customers;

interface

uses
  System.SysUtils, System.StrUtils;

type
  TCustomerRecord = packed record
    Name: string;
    Balance: Currency;
    Credit: Currency;
    MSISDN: string;
    PIN: string;
    IsImport: Boolean;
    SourceCustomerID: string;
    SourceParentID: string;
    CustomerID: LongInt;
    Username: string;
    ParentID: LongInt;
    ParentRebate: Currency;
    TimeRegister: TDateTime;
    MetaPath: string;
    MetaLevel: Integer;
    ImportStatus: Byte;
  end;
  PCustomerRecord = ^TCustomerRecord;

const
  SIZE_OF_CUSTOMER_RECORD = SizeOf(TCustomerRecord);

  IMPORT_STATUS_UNKNOWN = 0;
  IMPORT_STATUS_OK      = 1;
  IMPORT_STATUS_FAIL    = 2;
  IMPORT_STATUS_SKIP    = 3;
  IMPORT_STATUS_UPDATE  = 4;

procedure InitCustomerRecord(var Data:TCustomerRecord);
function fixMsisdn(const Value: string): string;

implementation

procedure InitCustomerRecord(var Data:TCustomerRecord);
begin
  Data.Name:='';
  Data.Balance:=0;
  Data.Credit:=0;
  Data.MSISDN:='';
  Data.PIN:='';
  Data.IsImport:=False;
  Data.SourceCustomerID:='';
  Data.SourceParentID:='';
  Data.CustomerID:=0;
  Data.ParentID:=0;
  Data.ParentRebate:=0;
  Data.TimeRegister:=0;
  Data.MetaPath:='';
  Data.MetaLevel:=1;
  Data.ImportStatus:=IMPORT_STATUS_UNKNOWN;
end;

function fixMsisdn(const Value: string): string;
var
  MSISDN: string;
begin
  MSISDN:=Value;
  MSISDN:=StringReplace(MSISDN, '+','',[rfReplaceAll]);
  MSISDN:=StringReplace(MSISDN, '*','',[rfReplaceAll]);
  if LeftStr(MSISDN, 2) = '62' then
  begin
    Delete(MSISDN, 1, 2);
    MSISDN:='0'+MSISDN;
  end;
  Result:=MSISDN;
end;

end.
