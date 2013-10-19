unit DataSourceAmcc;

interface

uses
  Customers, Winapi.Windows, Settings, ImportDialogs,
  System.SysUtils, System.Classes, DataSourceIntf, ZAbstractConnection, ZConnection, ZDataset;

type
  TSourceAmcc = class(TDataModule, IImportDataSource)
    Connection: TZConnection;
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Setting: TMySQLSetting;
  public
    { Public declarations }
    function showConnectionSetting(ParentHandle: HWND): Boolean;
    procedure Connect;
    procedure Disconnnect;
    procedure getCustomerDataset(Query: TZQuery);
    procedure fetchCustomerRecord(Query: TZQuery; var Value: TCustomerRecord);
  end;

var
  SourceAmcc: TSourceAmcc;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataAmcc }

procedure TSourceAmcc.Connect;
begin
  Connection.Connect;
end;

procedure TSourceAmcc.ConnectionBeforeConnect(Sender: TObject);
begin
  Connection.HostName:=Setting.Hostname;
  Connection.Database:=Setting.Database;
  Connection.User:=Setting.Username;
  Connection.Password:=Setting.Password;
  Connection.Port:=Setting.Port;
  Connection.Protocol:='mysql';
end;

procedure TSourceAmcc.DataModuleCreate(Sender: TObject);
begin
  SetDefaultMySQLSetting(Setting);
  Setting.Database:='amcc2';
end;

procedure TSourceAmcc.Disconnnect;
begin
  Connection.Disconnect;
end;

procedure TSourceAmcc.fetchCustomerRecord(Query: TZQuery;
  var Value: TCustomerRecord);
begin
  try
    Assert(Assigned(Query));
    InitCustomerRecord(Value);
    Value.Name:=Query.FieldByName('Name').AsString;
    Value.Balance:=Query.FieldByName('balance').AsCurrency;
    if Value.Balance < 0 then
    begin
      Value.Credit:=Abs(Value.Balance);
      Value.Balance:=0;
    end;

    Value.MSISDN:=Query.FieldByName('MSISDN1').AsString;
    Value.MSISDN:=fixMsisdn(Value.MSISDN);
    Value.PIN:=Query.FieldByName('AuthCodeSMS').AsString;
    Value.IsImport:=True;
    Value.SourceCustomerID:=Query.FieldByName('DealerID').AsString;
    Value.SourceParentID:=Query.FieldByName('UplineID').AsString;
    Value.CustomerID:=0;
    Value.ParentID:=0;
    Value.ParentRebate:=Query.FieldByName('Markup').AsCurrency;
    Value.TimeRegister:=Query.FieldByName('RegisteredTime').AsDateTime;
  finally

  end;
end;

procedure TSourceAmcc.getCustomerDataset(Query: TZQuery);
begin
  try
    Assert(Assigned(Query));
    Query.Connection:=Connection;
    Query.SQL.Text:='SELECT a.*, b.balance FROM amccdealer a LEFT JOIN ' +
      'amccdealeraccount b ON b.DealerID = a.DealerID ORDER BY a.DealerID ASC;';
    Query.Open;
  finally

  end;
end;

function TSourceAmcc.showConnectionSetting(ParentHandle: HWND): Boolean;
begin
  Result:=ShowSettingMySQL(ParentHandle, Setting);
end;

end.
