unit FormProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.AppEvnts;

type
  TFrmProgress = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lblCounter: TLabel;
    Label3: TLabel;
    lbTableName: TLabel;
    Label4: TLabel;
    lblData: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    appevents: TApplicationEvents;
    procedure btnCancelClick(Sender: TObject);
    procedure appeventsActivate(Sender: TObject);
  private
    { Private declarations }
    FMaxCounter: Integer;
  public
    { Public declarations }
    procedure SetMaxCounter(const Value: Integer);
    function IsCancelled: Boolean;
  end;

var
  FrmProgress: TFrmProgress;

implementation

{$R *.dfm}

procedure TFrmProgress.appeventsActivate(Sender: TObject);
begin
  if Visible then Show;
end;

procedure TFrmProgress.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

function TFrmProgress.IsCancelled: Boolean;
begin
  Result:=ModalResult = mrCancel;
end;

procedure TFrmProgress.SetMaxCounter(const Value: Integer);
begin
  FMaxCounter:=Value;
end;

end.
