unit DataSourceAmcc;

interface

uses
  Customers, Winapi.Windows, Settings, ImportDialogs,
  System.SysUtils, System.Classes, DataSourceIntf, ZAbstractConnection, ZConnection, ZDataset;

type
  TDataAmcc = class(TDataModule, IImportDataSource)
    Connection: TZConnection;
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Setting: TMySQLSetting;
  public
    { Public declarations }
    procedure getCustomerDataset(Query: TZQuery);
    procedure fetchCustomerRecord(Query: TZQuery; var Value: TCustomerRecord);
    function showConnectionSetting(ParentHandle: HWND): Boolean;
  end;

var
  DataAmcc: TDataAmcc;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataAmcc }

procedure TDataAmcc.ConnectionBeforeConnect(Sender: TObject);
begin
  Connection.HostName:=Setting.Hostname;
  Connection.Database:=Setting.Database;
  Connection.User:=Setting.Username;
  Connection.Password:=Setting.Password;
  Connection.Port:=Setting.Port;
  Connection.Protocol:='mysql';
end;

procedure TDataAmcc.DataModuleCreate(Sender: TObject);
begin
  SetDefaultMySQLSetting(Setting);
  Setting.Database:='amcc2';
end;

procedure TDataAmcc.fetchCustomerRecord(Query: TZQuery;
  var Value: TCustomerRecord);
begin
  try
    Assert(Assigned(Query));
    Value.Name:=Query.FieldByName('Name').AsString;
    Value.Balance:=Query.FieldByName('balance').AsCurrency;
    Value.MSISDN:=Query.FieldByName('MSISDN1').AsString;
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

procedure TDataAmcc.getCustomerDataset(Query: TZQuery);
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

function TDataAmcc.showConnectionSetting(ParentHandle: HWND): Boolean;
begin
  Result:=ShowSettingMySQL(ParentHandle, Setting);
end;

end.
