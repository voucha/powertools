unit FormMain;

interface

uses
  Customers, Settings, DataSourceIntf,
  ZDataset,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  VirtualTrees, System.Actions, Vcl.ActnList, Vcl.StdActns, Vcl.ListActns, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TFrmMain = class(TForm)
    MainMenu: TMainMenu;
    mnData: TMenuItem;
    mnImportDatabase: TMenuItem;
    ListCustomer: TVirtualStringTree;
    StatusBar: TStatusBar;
    mnEdit: TMenuItem;
    ActionList: TActionList;
    ActFileOpen: TFileOpen;
    ActFileSaveAs: TFileSaveAs;
    ActFileExit: TFileExit;
    mnOpen: TMenuItem;
    mnSaveAs: TMenuItem;
    ActEditCut: TEditCut;
    ActEditCopy: TEditCopy;
    ActEditPaste: TEditPaste;
    ActEditSelectAll: TEditSelectAll;
    ActEditUndo: TEditUndo;
    ActEditDelete: TEditDelete;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Delete1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    Undo1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    ActImport: TAction;
    pnlProgress: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lblCounter: TLabel;
    Label4: TLabel;
    lblData: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    actExport: TAction;
    mnExport: TMenuItem;
    imgImport: TImage;
    ActSearchFind: TSearchFind;
    ActSearchFindNext: TSearchFindNext;
    Search1: TMenuItem;
    mnFind: TMenuItem;
    mnFindNext: TMenuItem;
    procedure ListCustomerGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure ListCustomerGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ListCustomerInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListCustomerBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure ActImportExecute(Sender: TObject);
    procedure ListCustomerFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure FormCreate(Sender: TObject);
    procedure ThreadTerminate(Sender: TObject);
    procedure ActFileSaveAsAccept(Sender: TObject);
    procedure ActFileOpenAccept(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ActSearchFindAccept(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowProgress;
    procedure HideProgress;
    procedure ResetProgress;
  end;

  TImportThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  FrmMain: TFrmMain;
  FormatSettings: TFormatSettings;
  Thread: TImportThread;
  DataModule: IImportDataSource;

implementation

uses
  ImportDialogs, DataSourceAmcc;

{$R *.dfm}

procedure TFrmMain.ActFileOpenAccept(Sender: TObject);
begin
  ListCustomer.LoadFromFile(ActFileOpen.Dialog.FileName);
end;

procedure TFrmMain.ActFileSaveAsAccept(Sender: TObject);
begin
  ListCustomer.SaveToFile(ActFileSaveAs.Dialog.FileName);
end;

procedure TFrmMain.ActImportExecute(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  if ShowSelectDatasource(Handle, SelectedIndex) then
  begin
    DataModule:=DataAmcc;
    Thread:=TImportThread.Create(True);
    Thread.FreeOnTerminate:=True;
    Thread.OnTerminate:=ThreadTerminate;
    Thread.Start;
  end;
end;

procedure TFrmMain.ActSearchFindAccept(Sender: TObject);
begin
//
end;

procedure TFrmMain.btnCancelClick(Sender: TObject);
begin
  if MessageBox(Handle,
    'Yakin mau dibatalkan?',
    'Konfirmasi',
    MB_YESNO or MB_ICONWARNING) = IDYES then
  begin
    if Assigned(Thread) then
      Thread.Terminate;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  pnlProgress.SendToBack;
  pnlProgress.Align:=alClient;
end;

procedure TFrmMain.HideProgress;
begin
  pnlProgress.SendToBack;
  ListCustomer.BringToFront;
  ListCustomer.Repaint;
end;

procedure TFrmMain.ListCustomerBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Odd(Node.Index) then
    TargetCanvas.Brush.Color:=$00F5E8D6
  else
    TargetCanvas.Brush.Color:=clWhite;
  TargetCanvas.FillRect(CellRect);
end;

procedure TFrmMain.ListCustomerFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  P: PCustomerRecord;
begin
  P:=Sender.GetNodeData(Node);
  P^.Name:='';
  P^.Balance:=0;
  P^.MSISDN:='';
  P^.PIN:='';
end;

procedure TFrmMain.ListCustomerGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize:=SIZE_OF_CUSTOMER_RECORD;
end;

procedure TFrmMain.ListCustomerGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  P: PCustomerRecord;
begin
  P:=Sender.GetNodeData(Node);
  case Column of
  0: CellText:=P^.Name;
  1: CellText:=Format('%.0m', [P^.Balance], FormatSettings);
  2: CellText:=P^.MSISDN;
  3: CellText:=P^.PIN;
  end;
end;

procedure TFrmMain.ListCustomerInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType:=ctCheckBox;
  Node.CheckState:=csCheckedNormal;
end;

procedure TFrmMain.ResetProgress;
begin
  lblCounter.Caption:='';
  lblData.Caption:='';
  ProgressBar.Position:=0;
  ProgressBar.Max:=0;
end;

procedure TFrmMain.ShowProgress;
begin
  ListCustomer.SendToBack;
  pnlProgress.BringToFront;
  pnlProgress.Repaint;
end;

procedure TFrmMain.ThreadTerminate(Sender: TObject);
begin
  FrmMain.HideProgress;
  DataModule:=nil;
  Thread:=nil;
end;

{ TImportThread }

procedure TImportThread.Execute;
var
  Query: TZQuery;
  Node: PVirtualNode;
  P:PCustomerRecord;
  MaxCounter, Counter: Integer;
  Percent: Real;
begin
  Query:=TZQuery.Create(nil);
  try
    Assert(Assigned(DataModule));
    Assert(Assigned(FrmMain));
    if DataModule.showConnectionSetting(FrmMain.Handle) then
    begin
      FrmMain.ResetProgress;
      FrmMain.ShowProgress;
      DataModule.getCustomerDataset(Query);
      if Query.RecordCount > 0 then
      begin
        MaxCounter:=Query.RecordCount;
        FrmMain.ProgressBar.Max:=Query.RecordCount;
        FrmMain.ListCustomer.BeginUpdate;
        FrmMain.ListCustomer.Clear;
        Counter:=1;
        Query.First;
        while not (Query.Eof or Terminated) do
        begin
          Percent:=(Counter/MaxCounter)*100;
          Node:=FrmMain.ListCustomer.AddChild(nil);
          P:=FrmMain.ListCustomer.GetNodeData(Node);
          DataModule.fetchCustomerRecord(Query, P^);
          FrmMain.lblCounter.Caption:=Format('%d / %d (%.0f%s)',[Counter,
            MaxCounter, Percent, '%']);
          FrmMain.lblData.Caption:=P^.Name;
          FrmMain.lblCounter.Repaint;
          FrmMain.lblData.Repaint;
          FrmMain.ProgressBar.StepIt;
          Query.Next;
          Inc(Counter);
        end;
        Query.Close;
        FrmMain.ListCustomer.EndUpdate;
      end;
    end;
  finally
    FrmMain.HideProgress;
    FreeAndNil(Query);
  end;
end;

initialization
  FormatSettings:=TFormatSettings.Create;
  FormatSettings.CurrencyString:='';
  FormatSettings.ThousandSeparator:='.';
  FormatSettings.DecimalSeparator:=',';

end.