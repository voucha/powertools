unit FormMain;

interface

uses
  Customers, Settings, DataSourceIntf,
  ZDataset,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  VirtualTrees, System.Actions, Vcl.ActnList, Vcl.StdActns, Vcl.ListActns, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ImgList;

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
    lbProgressTitle: TLabel;
    Label2: TLabel;
    lblCounter: TLabel;
    Label4: TLabel;
    lblData: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    ActExport: TAction;
    mnExport: TMenuItem;
    imgImport: TImage;
    ActSearchFind: TSearchFind;
    ActSearchFindNext: TSearchFindNext;
    Search1: TMenuItem;
    mnFind: TMenuItem;
    mnFindNext: TMenuItem;
    imgCustomer: TImageList;
    pnlList: TPanel;
    pnlInfo: TPanel;
    Label1: TLabel;
    lblNama: TLabel;
    mmoLog: TMemo;
    Label3: TLabel;
    lblTotalSubAgent: TLabel;
    procedure ListCustomerGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure ListCustomerGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
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
    procedure ListCustomerSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure ListCustomerLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure ListCustomerGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ActExportExecute(Sender: TObject);
    procedure ListCustomerFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
  public
    { Public declarations }
    FTotalNodeCount: Integer;
    procedure ShowProgress;
    procedure HideProgress;
    procedure ResetProgress;
    function getParentNode(Data:TCustomerRecord):PVirtualNode;
    procedure ClearLog;
    procedure WriteLog(const Value:string);
  end;

  TImportThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

  TExportThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  FrmMain: TFrmMain;
  FormatSettings: TFormatSettings;
  Thread: TThread;
  DataSource: IImportDataSource;
  DataTarget: IImportDataTarget;

implementation

uses
  ImportDialogs, DataSourceAmcc, DataTargetVoucha4;

{$R *.dfm}

procedure TFrmMain.ActExportExecute(Sender: TObject);
var
  Settings: TPostgreSQLSetting;
begin
  if Assigned(Thread) then Exit;
  if ListCustomer.ChildCount[nil] > 0 then
  begin
    DataTarget:=TargetVoucha4;
    Thread:=TExportThread.Create(True);
    Thread.FreeOnTerminate:=True;
    Thread.OnTerminate:=ThreadTerminate;
    Thread.Start;
    ActExport.Enabled:=False;
  end
  else begin
    MessageBox(Handle, 'Apanya yang mau diexport? Import data dulu lah!'#13#13'Klik menu Data->Import',
      'Export', MB_OK or MB_ICONERROR);
  end;
end;

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
  if Assigned(Thread) then Exit;

  if ImportDialogs.ShowSelectDatasource(Handle, SelectedIndex) then
  begin
    DataSource:=SourceAmcc;
    Thread:=TImportThread.Create(True);
    Thread.FreeOnTerminate:=True;
    Thread.OnTerminate:=ThreadTerminate;
    Thread.Start;
    ActImport.Enabled:=False;
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

procedure TFrmMain.ClearLog;
begin
  mmoLog.Clear;
  mmoLog.Invalidate;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  pnlProgress.SendToBack;
  pnlProgress.Align:=alClient;
end;

function TFrmMain.getParentNode(Data: TCustomerRecord): PVirtualNode;
var
  Node,ParentNode: PVirtualNode;
  P: PCustomerRecord;
begin
  ParentNode:=nil;
  try
    Node:=ListCustomer.GetFirst;
    while Node <> nil do
    begin
      P:=ListCustomer.GetNodeData(Node);
      if P^.SourceCustomerID = Data.SourceParentID then
      begin
        ParentNode:=Node;
        Break;
      end;
      Node:=ListCustomer.GetNext(Node);
    end;
  finally
    Result:=ParentNode;
  end;
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

procedure TFrmMain.ListCustomerFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  P: PCustomerRecord;
begin
  P:=Sender.GetNodeData(Node);
  lblNama.Caption:=P^.Name;
  lblTotalSubAgent.Caption:=Format('%d',[Sender.ChildCount[Node]]);
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
  P^.SourceCustomerID:='';
  P^.SourceParentID:='';
  P^.ParentRebate:=0;
end;

procedure TFrmMain.ListCustomerGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    ImageIndex:=0;
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
  2: CellText:=Format('%.0m', [P^.Credit], FormatSettings);
  3: CellText:=P^.MSISDN;
  4: CellText:=P^.PIN;
  5: CellText:=Format('%.0m', [P^.ParentRebate], FormatSettings);
  end;
end;

procedure TFrmMain.ListCustomerLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  P: PCustomerRecord;
begin
  P:=Sender.GetNodeData(Node);
  Stream.ReadData(P, SIZE_OF_CUSTOMER_RECORD);
end;

procedure TFrmMain.ListCustomerSaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  P: PCustomerRecord;
begin
  P:=Sender.GetNodeData(Node);
  Stream.WriteData(P, SIZE_OF_CUSTOMER_RECORD);
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
  DataSource:=nil;
  Thread:=nil;
  ActImport.Enabled:=True;
  ActExport.Enabled:=True;
end;

procedure TFrmMain.WriteLog(const Value: string);
begin
  mmoLog.Lines.Add(Value);
  mmoLog.Invalidate;
end;

{ TImportThread }

procedure TImportThread.Execute;
var
  Query: TZQuery;
  Node, ParentNode: PVirtualNode;
  P:PCustomerRecord;
  Data: TCustomerRecord;
  MaxCounter, Counter: Integer;
  Percent: Real;
begin
  Counter:=0;
  Query:=TZQuery.Create(nil);
  try
    try
      Assert(Assigned(DataSource));
      Assert(Assigned(FrmMain));
      if DataSource.showConnectionSetting(FrmMain.Handle) then
      begin
        FrmMain.ClearLog;
        FrmMain.ResetProgress;
        FrmMain.ShowProgress;
        DataSource.Connect;
        DataSource.getCustomerDataset(Query);
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
            DataSource.fetchCustomerRecord(Query, Data);
            ParentNode:=FrmMain.getParentNode(Data);
            Node:=FrmMain.ListCustomer.AddChild(ParentNode);
            P:=FrmMain.ListCustomer.GetNodeData(Node);
            DataSource.fetchCustomerRecord(Query, P^);
            P^.MetaLevel:=FrmMain.ListCustomer.GetNodeLevel(Node)+1;
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
          DataSource.Disconnnect;
          FrmMain.ListCustomer.EndUpdate;
        end
        else begin
          MessageBox(FrmMain.Handle,
            'Koneksi berhasil namun data tidak ada.',
            'Import',
            MB_OK or MB_ICONINFORMATION);
        end;
      end;
    except
      on E:Exception do
      begin
        MessageBox(FrmMain.Handle,
          PWideChar(E.Message),
          'Import',
          MB_ICONERROR or MB_OK);
      end;
    end;
  finally
    FrmMain.FTotalNodeCount:=Counter;
    FrmMain.StatusBar.Panels[0].Text:=Format('%d record',[Counter]);
    FrmMain.StatusBar.Invalidate;
    FrmMain.HideProgress;
    FreeAndNil(Query);
  end;
end;

{ TExportThread }

procedure TExportThread.Execute;
var
  I: Integer;
  Node, ParentNode: PVirtualNode;
  P, PParent:PCustomerRecord;
  Data: TCustomerRecord;
  MaxCounter, Counter: Integer;
  Percent: Real;
begin
  try
    try
      Assert(Assigned(DataTarget));
      Assert(Assigned(FrmMain));
      if DataTarget.showConnectionSetting(FrmMain.Handle) then
      begin
        DataTarget.Connect;
        DataTarget.emptyTable;
        FrmMain.ClearLog;
        FrmMain.ResetProgress;
        FrmMain.ShowProgress;
        Node:=FrmMain.ListCustomer.GetFirst(True);
        Counter:=1;
        MaxCounter:=FrmMain.FTotalNodeCount;
        FrmMain.ProgressBar.Max:=MaxCounter;
        while Node <> nil do
        begin
          P:=FrmMain.ListCustomer.GetNodeData(Node);
          ParentNode:=Node.Parent;
          PParent:=FrmMain.ListCustomer.GetNodeData(ParentNode);
          if (PParent <> nil) then
          begin
            P^.ParentID:=PParent.CustomerID;
          end;

          P^.Username:=Format('%.8d',[Counter]);
          if Trim(P^.Name) = '' then
            P^.Name:='Anonymous';

          try
            DataTarget.addCustomer(P^);
            if Trim(P^.MSISDN) <> '' then
              DataTarget.addMsisdn(P^);
          except
            on E:Exception do
            begin
              FrmMain.WriteLog(E.Message);
            end;
          end;

          Percent:=(Counter/MaxCounter)*100;
          FrmMain.lblCounter.Caption:=Format('%d / %d (%.0f%s)',[Counter,
            MaxCounter, Percent, '%']);
          FrmMain.lblData.Caption:=P^.Name;
          FrmMain.lblCounter.Repaint;
          FrmMain.lblData.Repaint;
          FrmMain.ProgressBar.StepIt;

          Node:=FrmMain.ListCustomer.GetNext(Node);
          Inc(Counter);
        end;
        DataTarget.Disconnnect;
        MessageBox(FrmMain.Handle,
          'Proses export ke Voucha4 sudah selesai. '#13'Silakan periksa hasilnya di Voucha4 Admin.',
          'Export',
          MB_ICONINFORMATION or MB_OK);
      end;
    except
      on E:Exception do
      begin
        MessageBox(FrmMain.Handle,
          PWideChar(E.Message),
          'Import',
          MB_ICONERROR or MB_OK);
      end;
    end;
  finally
    FrmMain.StatusBar.Invalidate;
    FrmMain.HideProgress;
  end;
end;

initialization
  FormatSettings:=TFormatSettings.Create;
  FormatSettings.CurrencyString:='';
  FormatSettings.ThousandSeparator:='.';
  FormatSettings.DecimalSeparator:=',';

end.
