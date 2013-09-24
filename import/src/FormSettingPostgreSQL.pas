unit FormSettingPostgreSQL;

interface

uses
  Settings,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.StdCtrls;

type
  TFrmSettingPostgreSQL = class(TForm)
    grpSetting: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtHostname: TEdit;
    edtDatabase: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    edtPort: TEdit;
    btnTest: TButton;
    btnShowPassword: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    appevents: TApplicationEvents;
    procedure btnShowPasswordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getSetting(var Value: TPostgreSQLSetting);
    procedure setSetting(const Value: TPostgreSQLSetting);
  end;

var
  FrmSettingPostgreSQL: TFrmSettingPostgreSQL;

implementation

{$R *.dfm}

{ TFrmSettingPostgreSQL }

procedure TFrmSettingPostgreSQL.btnShowPasswordClick(Sender: TObject);
begin
  edtPassword.PasswordChar:=#0;
end;

procedure TFrmSettingPostgreSQL.getSetting(var Value: TPostgreSQLSetting);
begin
  Value.Hostname:=edtHostname.Text;
  Value.Database:=edtDatabase.Text;
  Value.Username:=edtUsername.Text;
  Value.Password:=edtPassword.Text;
  Value.Port:=StrToInt(edtPort.Text);
end;

procedure TFrmSettingPostgreSQL.setSetting(const Value: TPostgreSQLSetting);
begin
  edtHostname.Text:=Value.Hostname;
  edtDatabase.Text:=Value.Database;
  edtUsername.Text:=Value.Username;
  edtPassword.Text:=Value.Password;
  edtPort.Text:=IntToStr(Value.Port);
end;

end.
