unit Customers;

interface

type
  TCustomerRecord = packed record
    Name: string;
    Balance: Currency;
    MSISDN: string;
    PIN: string;
    IsImport: Boolean;
    SourceCustomerID: string;
    SourceParentID: string;
    CustomerID: LongInt;
    ParentID: LongInt;
    ParentRebate: Currency;
    TimeRegister: TDateTime;
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

implementation

end.
