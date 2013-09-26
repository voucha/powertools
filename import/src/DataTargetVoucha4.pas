unit DataTargetVoucha4;

interface

uses
  Customers,
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZSqlProcessor;

type
  TDataModule1 = class(TDataModule)
    Connection: TZConnection;
    ZQuery: TZQuery;
    ZSql: TZSQLProcessor;
  private
    { Private declarations }
  public
    { Public declarations }
    function findCustomerIdByMsisdn(const Value: string): Integer;
    function addCustomer(var Data:TCustomerRecord):Boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TDataModule1.addCustomer(var Data: TCustomerRecord): Boolean;
var
  P: TZSQLProcessor;
begin
  try
    P:=TZSQLProcessor.Create(nil);
    P.Connection:=Connection;

  finally
    FreeAndNil(P);
  end;
end;

function TDataModule1.findCustomerIdByMsisdn(const Value: string): Integer;
var
  CustomerID: Integer;
  Query: TZQuery;
begin
  CustomerID:=0;
  try
    Query:=TZQuery.Create(nil);
    Query.Connection:=Connection;
    Query.SQL.Text:='SELECT customerid FROM customermsisdn WHERE msisdn=' +
      ':msisdn;';
    Query.FieldByName('msisdn').AsString:=Value;
    Query.Open;
    if Query.RecordCount > 0 then
    begin
      Query.First;
      CustomerID:=Query.FieldByName('customerid').AsInteger;
    end;
    Query.Close;
  finally
    FreeAndNil(Query);
  end;
end;

end.
