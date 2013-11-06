unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdException,
  IdExceptionCore, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    edtIP: TEdit;
    Label1: TLabel;
    btnCheck: TButton;
    HTTP: TIdHTTP;
    procedure btnCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnCheckClick(Sender: TObject);
begin
  try
    try
      HTTP.ConnectTimeout:=3000;
      HTTP.ReadTimeout:=3000;
      edtIP.Text:=HTTP.Get('http://checkip.sandiloka.com');
    except
      on E:EIdConnectTimeout do
        MessageBox(Handle, PWideChar('Check IP Gagal karena koneksi internet Anda lambat. '+E.Message), 'Check IP', MB_OK or
          MB_ICONERROR);
      on E:EIdReadTimeout do
        MessageBox(Handle, PWideChar('Check IP Gagal karena koneksi internet Anda lambat. '+E.Message), 'Check IP', MB_OK or
          MB_ICONERROR);
      on E:Exception do
      begin
        MessageBox(Handle, PWideChar('Check IP Gagal. '#13'Penjelasan:'#13#13+E.Message), 'Check IP', MB_OK or
          MB_ICONERROR);
      end;
    end;
  finally

  end;
end;

end.
