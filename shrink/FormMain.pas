unit FormMain;

interface

uses
  System.DateUtils,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFrmMain = class(TForm)
    Label1: TLabel;
    cbbInterval: TComboBox;
    dtpDate: TDateTimePicker;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    rbNow: TRadioButton;
    rbSchedule: TRadioButton;
    cbbSchedule: TComboBox;
    mmLog: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    procedure initControls;
    procedure cbbIntervalChange(Sender: TObject);
    procedure changeSchedule(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DataModuleStatus(Sender: TObject; const AStatusText: String);
    procedure ThreadFinish(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure EnableControls;
    procedure DisableControls;
    procedure WriteLog(const Value: string); overload;
    procedure WriteLog(Strings: TStrings); overload;
  end;

  TShrinkThread = class(TThread)
  private
    { Private declarations }
    Form: TFrmMain;
  protected
    procedure Execute; override;
    constructor Create(AOwner:TFrmMain); reintroduce;
  end;

var
  FrmMain: TFrmMain;
  Thread: TShrinkThread;

implementation

{$R *.dfm}

uses DataVoucha;

procedure TFrmMain.btnStartClick(Sender: TObject);
begin
  Thread:=TShrinkThread.Create(Self);
  Thread.Start;
end;

procedure TFrmMain.cbbIntervalChange(Sender: TObject);
begin
  case cbbInterval.ItemIndex of
  0: dtpDate.DateTime := IncDay(Now, -7);
  1: dtpDate.DateTime := IncMonth(Now, -1);
  2: dtpDate.DateTime := IncYear(Now, -1);
  end;
  dtpDate.Enabled := cbbInterval.ItemIndex = cbbInterval.Items.Count - 1;
end;

procedure TFrmMain.changeSchedule(Sender: TObject);
begin
  cbbSchedule.Enabled := rbSchedule.Checked;
end;

procedure TFrmMain.DataModuleStatus(Sender: TObject; const AStatusText: String);
begin
  WriteLog(AStatusText);
end;

procedure TFrmMain.DisableControls;
begin
  btnStart.Enabled  := False;
  btnStop.Enabled   := True;
end;

procedure TFrmMain.EnableControls;
begin
  btnStart.Enabled  := True;
  btnStop.Enabled   := False;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  initControls;
end;

procedure TFrmMain.initControls;
begin
  dtpDate.DateTime := IncDay(Now, -7);
  mmLog.Clear;
end;

procedure TFrmMain.ThreadFinish(Sender: TObject);
begin
  Thread:=nil;
end;

procedure TFrmMain.WriteLog(Strings: TStrings);
begin
  mmLog.Lines.BeginUpdate;
  mmLog.Lines.AddStrings(Strings);
  mmLog.Lines.EndUpdate;
  mmLog.Invalidate;
end;

procedure TFrmMain.WriteLog(const Value: string);
begin
  mmLog.Lines.Add(Value);
  mmLog.Invalidate;
end;

{ TShrinkThread }

constructor TShrinkThread.Create(AOwner: TFrmMain);
begin
  inherited Create(True);
  Form:=AOwner;
  FreeOnTerminate:=True;
  OnTerminate:=Form.ThreadFinish;
end;

procedure TShrinkThread.Execute;
var
  DataModule: TDataModuleVoucha;
begin
  DataModule:=TDataModuleVoucha.Create(nil);
  Form.DisableControls;
  try
    try
      Form.mmLog.Clear;
      DataModule.OnStatusText:=Form.DataModuleStatus;
      DataModule.Connect;
      DataModule.shrink(Form.dtpDate.Date);
    except
      on E:Exception do
        Form.WriteLog(Format('%s'#13#10'%s',[E.ClassName, E.Message]));
    end;
  finally
    Form.EnableControls;
    FreeAndNil(DataModule);
  end;
end;

end.
