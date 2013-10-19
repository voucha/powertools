unit DataTargetVoucha4;

interface

uses
  Customers, Settings, DataSourceIntf, ImportDialogs, Winapi.Windows,
  System.StrUtils,
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZSqlProcessor;

type
  TTargetVoucha4 = class(TDataModule, IImportDataTarget)
    Connection: TZConnection;
    ZQuery: TZQuery;
    ZSql: TZSQLProcessor;
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Setting: TPostgreSQLSetting;
  public
    { Public declarations }

    {IImportDataTarget}
    function  showConnectionSetting(ParentHandle: HWND): Boolean;
    procedure Connect;
    procedure Disconnnect;

    procedure emptyTable;

    function addCustomer(var Data:TCustomerRecord):Boolean;
    function addMsisdn(Data:TCustomerRecord):Boolean;

    function setCustomerBalance(Data: TCustomerRecord):Boolean;
    function getCustomerByID(const ID: LongInt;
      var Data:TCustomerRecord):Boolean;
    function getCustomerByMsisdn(const MSISDN: string;
      var Data:TCustomerRecord):Boolean;
    function generateUsername(Data: TCustomerRecord):string;
    function generateRandomPassword:string;
    function generateMetaPath(var Data:TCustomerRecord):Boolean;
    function updateMetaPath(Data:TCustomerRecord):Boolean;
  end;

var
  TargetVoucha4: TTargetVoucha4;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TTargetVoucha4 }

function TTargetVoucha4.addCustomer(var Data: TCustomerRecord): Boolean;
var
  Query: TZQuery;
  Success: Boolean;
begin
  Success:=False;
  try
    Query:=TZQuery.Create(nil);
    Query.Connection:=Connection;
    Query.SQL.Text:='INSERT INTO customer ("name", username, "password", ' +
      'balance, credit, parentid, parentrebate, metapath, metalevel) VALUES (:name, ' +
      ':username, md5(:password), :balance, :credit,:parentid, :parentrebate, :metapath, ' +
      ':metalevel) RETURNING customerid;';
    Query.ParamByName('name').AsString:=Data.Name;
    Query.ParamByName('username').AsString:=Data.Username;
    Query.ParamByName('password').AsString:=Data.PIN;
    Query.ParamByName('balance').AsCurrency:=Data.Balance;
    Query.ParamByName('credit').AsCurrency:=Data.Credit;
    Query.ParamByName('parentid').AsInteger:=Data.ParentID;
    Query.ParamByName('parentrebate').AsCurrency:=Data.ParentRebate;
    Query.ParamByName('metapath').AsString:=Data.MetaPath;
    Query.ParamByName('metalevel').AsInteger:=Data.MetaLevel;
    Query.Open;
    if Query.RecordCount > 0 then
    begin
      Data.CustomerID:=Query.FieldByName('customerid').AsInteger;
      generateMetaPath(Data);
      updateMetaPath(Data);
      Success:=True;
    end;
    Query.Close;
  finally
    FreeAndNil(Query);
    Result:=Success;
  end;
end;

function TTargetVoucha4.addMsisdn(Data: TCustomerRecord): Boolean;
var
  P:TZSQLProcessor;
  Success:Boolean;
  MSISDN: string;
begin
  Success:=False;
  Assert(Data.CustomerID <> 0, 'addMsisdn: Nilai customerid tidak valid!');
  MSISDN:=fixMsisdn(Data.MSISDN);
  if Trim(MSISDN) = '' then Exit;
  try
    P:=TZSQLProcessor.Create(nil);
    P.Connection:=Connection;
    P.Script.Text:='INSERT INTO sender (sendertype, senderid, "password", ' +
      'customerid, status, isdefault) VALUES (1, :msisdn, md5(:password), :customerid, 1, 1);';
    P.ParamByName('msisdn').AsString:=Data.MSISDN;
    P.ParamByName('password').AsString:=Data.PIN;
    P.ParamByName('customerid').AsInteger:=Data.CustomerID;
    P.Execute;
    Success:=True;
  finally
    FreeAndNil(P);
    Result:=Success;
  end;
end;

procedure TTargetVoucha4.Connect;
begin
  Connection.Connect;
end;

procedure TTargetVoucha4.ConnectionBeforeConnect(Sender: TObject);
begin
  Connection.HostName:=Setting.Hostname;
  Connection.Database:=Setting.Database;
  Connection.User:=Setting.Username;
  Connection.Password:=Setting.Password;
  Connection.Port:=Setting.Port;
  Connection.Protocol:='postgresql';
end;

procedure TTargetVoucha4.DataModuleCreate(Sender: TObject);
begin
  SetDefaultPostgreSQLSetting(Setting);
  Setting.Database:='voucha4';
  Setting.Username:='voucha4';
end;

procedure TTargetVoucha4.Disconnnect;
begin
  Connection.Disconnect;
end;

procedure TTargetVoucha4.emptyTable;
var
  P:TZSQLProcessor;
begin
  try
    P:=TZSQLProcessor.Create(nil);
    P.Connection:=Connection;
    P.Script.Text:='DELETE FROM customer;';
    P.Script.Add('DELETE FROM sender;');
    P.Script.Add('SELECT setval(''customer_customerid_seq'', 1, false);');
    P.Execute;
  finally
    FreeAndNil(P);
  end;
end;

function TTargetVoucha4.generateMetaPath(var Data: TCustomerRecord): Boolean;
var
  Parent: TCustomerRecord;
begin
  if Data.ParentID = 0 then
  begin
    Data.MetaPath:=Format('-%d',[Data.CustomerID]);
    Data.MetaLevel:=1;
    Result:=True;
  end
  else
  begin
    if getCustomerByID(Data.ParentID, Parent) then
    begin
      Data.MetaPath:=Format('%s-%d',[Parent.MetaPath, Data.CustomerID]);
      Data.MetaLevel:=Parent.MetaLevel+1;
      Result:=True;
    end
    else Result:=False;
  end;
end;

function TTargetVoucha4.generateRandomPassword: string;
begin
  Result:=Format('%d',[Random(10000)]);
end;

function TTargetVoucha4.generateUsername(Data: TCustomerRecord): string;
var
  Username: string;
begin
  Username:=LowerCase(Data.Name);
  Username:=StringReplace(Username, ' ', '', [rfReplaceAll]);
  Username:=StringReplace(Username, '/', '', [rfReplaceAll]);
  Username:=LeftStr(Username, 8)+RightStr(Data.MSISDN, 4);
  Result:=Username;
end;

function TTargetVoucha4.getCustomerByID(const ID: Integer;
  var Data: TCustomerRecord): Boolean;
var
  Exists: Boolean;
  Query: TZQuery;
begin
  Exists:=False;
  InitCustomerRecord(Data);
  try
    Query:=TZQuery.Create(nil);
    Query.Connection:=Connection;
    Query.SQL.Text:='SELECT * FROM customer WHERE customerid=:customerid;';
    Query.ParamByName('customerid').AsInteger:=ID;
    Query.Open;
    if Query.RecordCount > 0 then
    begin
      Exists:=True;
      Query.First;
      Data.Name:=Query.FieldByName('name').AsString;
      Data.Balance:=Query.FieldByName('balance').AsCurrency;
      Data.CustomerID:=Query.FieldByName('customerid').AsInteger;
      Data.ParentID:=Query.FieldByName('parentid').AsInteger;
      Data.ParentRebate:=Query.FieldByName('parentrebate').AsCurrency;
      Data.TimeRegister:=Query.FieldByName('dateregistered').AsDateTime;
      Data.MetaPath:=Query.FieldByName('metapath').AsString;
      Data.MetaLevel:=Query.FieldByName('metalevel').AsInteger;
    end;
    Query.Close;
  finally
    FreeAndNil(Query);
    Result:=Exists;
  end;
end;

function TTargetVoucha4.getCustomerByMsisdn(const MSISDN: string;
  var Data: TCustomerRecord): Boolean;
var
  CustomerID: Integer;
  Query: TZQuery;
begin
  CustomerID:=0;
  InitCustomerRecord(Data);
  try
    Query:=TZQuery.Create(nil);
    Query.Connection:=Connection;
    Query.SQL.Text:='SELECT customerid FROM customermsisdn WHERE msisdn=' +
      ':msisdn;';
    Query.ParamByName('msisdn').AsString:=MSISDN;
    Query.Open;
    if Query.RecordCount > 0 then
    begin
      Query.First;
      CustomerID:=Query.FieldByName('customerid').AsInteger;
    end;
    Query.Close;
  finally
    FreeAndNil(Query);
    Data.CustomerID:=CustomerID;
  end;
end;

function TTargetVoucha4.setCustomerBalance(Data: TCustomerRecord): Boolean;
begin

end;

function TTargetVoucha4.showConnectionSetting(ParentHandle: HWND): Boolean;
begin
  Result:=ImportDialogs.ShowSettingPostgreSQL(ParentHandle, Setting);
end;

function TTargetVoucha4.updateMetaPath(Data: TCustomerRecord): Boolean;
var
  P:TZSQLProcessor;
begin
  try
    P:=TZSQLProcessor.Create(nil);
    P.Connection:=Connection;
    P.Script.Text:='UPDATE customer SET metapath=:metapath, metalevel=' +
      ':metalevel WHERE customerid=:customerid;';
    P.ParamByName('metapath').AsString:=Data.MetaPath;
    P.ParamByName('metalevel').AsInteger:=Data.MetaLevel;
    P.ParamByName('customerid').AsInteger:=Data.CustomerID;
    P.Execute;
    Result:=True;
  finally
    FreeAndNil(P);
  end;
end;

end.
