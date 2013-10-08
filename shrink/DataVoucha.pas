unit DataVoucha;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection,
  ZSqlProcessor;

type
  TOnStatusText = procedure (Sender: TObject; const AStatusText: String) of object;
  TDataModuleVoucha = class(TDataModule)
    Connection: TZConnection;
    Proc: TZSQLProcessor;
    procedure ProcBeforeExecute(Processor: TZSQLProcessor;
      StatementIndex: Integer);
    procedure ProcAfterExecute(Processor: TZSQLProcessor;
      StatementIndex: Integer);
    procedure ProcError(Processor: TZSQLProcessor; StatementIndex: Integer;
      E: Exception; var ErrorHandleAction: TZErrorHandleAction);
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure ConnectionAfterConnect(Sender: TObject);
    procedure ConnectionAfterDisconnect(Sender: TObject);
  private
    FOnStatusText: TOnStatusText;
    procedure SetOnStatusText(const Value: TOnStatusText);
    { Private declarations }
  public
    { Public declarations }
    procedure Connect;
    procedure Disconnect;
    procedure DoStatusText(const Value: String);
    procedure shrink(const Value: TDate);
    property OnStatusText: TOnStatusText read FOnStatusText write SetOnStatusText;
  end;

var
  DataModuleVoucha: TDataModuleVoucha;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModuleVoucha }

procedure TDataModuleVoucha.Connect;
begin
  Connection.Connect;
end;

procedure TDataModuleVoucha.ConnectionAfterConnect(Sender: TObject);
begin
  DoStatusText('Connected');
end;

procedure TDataModuleVoucha.ConnectionAfterDisconnect(Sender: TObject);
begin
  DoStatusText('Disconnected');
end;

procedure TDataModuleVoucha.ConnectionBeforeConnect(Sender: TObject);
begin
  DoStatusText('Connecting...');
end;

procedure TDataModuleVoucha.Disconnect;
begin
  Connection.Disconnect;
end;

procedure TDataModuleVoucha.DoStatusText(const Value: String);
begin
  if Assigned(FOnStatusText) then
    FOnStatusText(Self, Value);
end;

procedure TDataModuleVoucha.ProcAfterExecute(Processor: TZSQLProcessor;
  StatementIndex: Integer);
begin
  DoStatusText('Done');
end;

procedure TDataModuleVoucha.ProcBeforeExecute(Processor: TZSQLProcessor;
  StatementIndex: Integer);
var
  Str: String;
begin
  Str:=Processor.Statements[StatementIndex];
  DoStatusText(Format('[%d] Execute: ',[StatementIndex, Str]));
end;

procedure TDataModuleVoucha.ProcError(Processor: TZSQLProcessor;
  StatementIndex: Integer; E: Exception;
  var ErrorHandleAction: TZErrorHandleAction);
var
  Str: String;
begin
  ErrorHandleAction:=eaSkip;
  Str:=Processor.Statements[StatementIndex];
  DoStatusText('Error: '+Format('',[E.ClassName, E.Message]));
end;

procedure TDataModuleVoucha.SetOnStatusText(const Value: TOnStatusText);
begin
  FOnStatusText := Value;
end;

procedure TDataModuleVoucha.shrink(const Value: TDate);
begin
  try
    Proc.Params.Clear;
    Proc.Script.Clear;
    Proc.Script.Add('DELETE FROM histinbox WHERE "timestamp" < :value;');
    Proc.Script.Add('DELETE FROM histinbox WHERE "timestamp" < :value;');
    Proc.Script.Add('DELETE FROM topup WHERE timestart < :value;');
    Proc.Script.Add('DELETE FROM ppobtopuplog WHERE "timestamp" < :value;');
    Proc.Script.Add('DELETE FROM ppobtopup WHERE timestart < :value;');
    Proc.Script.Add('DELETE FROM ppobtopuplog WHERE "timestamp" < :value;');
    Proc.Script.Add('DELETE FROM devicetransaction WHERE "timestamp" < :value;');
    Proc.ParamByName('value').AsDate:=Value;
    Proc.Execute;
  finally

  end;
end;

end.
