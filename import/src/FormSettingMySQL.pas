unit FormSettingMySQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts, Settings;

type
  TFrmSettingMySQL = class(TForm)
    grpSetting: TGroupBox;
    edtHostname: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtDatabase: TEdit;
    Label3: TLabel;
    edtUsername: TEdit;
    Label4: TLabel;
    edtPassword: TEdit;
    Label5: TLabel;
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
    procedure getSetting(var Value: TMySQLSetting);
    procedure setSetting(const Value: TMySQLSetting);
  end;

var
  FrmSettingMySQL: TFrmSettingMySQL;

implementation

{$R *.dfm}

procedure TFrmSettingMySQL.btnShowPasswordClick(Sender: TObject);
begin
  edtPassword.PasswordChar:=#0;
end;

procedure TFrmSettingMySQL.getSetting(var Value: TMySQLSetting);
begin
  Value.Hostname:=edtHostname.Text;
  Value.Database:=edtDatabase.Text;
  Value.Username:=edtUsername.Text;
  Value.Password:=edtPassword.Text;
  Value.Port:=StrToInt(edtPort.Text);
end;

procedure TFrmSettingMySQL.setSetting(const Value: TMySQLSetting);
begin
  edtHostname.Text:=Value.Hostname;
  edtDatabase.Text:=Value.Database;
  edtUsername.Text:=Value.Username;
  edtPassword.Text:=Value.Password;
  edtPort.Text:=IntToStr(Value.Port);
end;

end.
