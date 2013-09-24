unit ThreadImport;

interface

uses
  Customers, Winapi.Windows, Vcl.Forms,
  System.Classes, System.SysUtils, DataSourceIntf, ZAbstractConnection, ZConnection, ZDataset, VirtualTrees;

type
  TImportThread = class(TThread)
  private
    FDataSource: IImportDataSource;
    FConnection: TZConnection;
    FTreeView: TVirtualStringTree;
    FParentHandle: HWND;
    procedure SetDataSource(const Value: IImportDataSource);
    procedure SetConnection(const Value: TZConnection);
    procedure SetTreeView(const Value: TVirtualStringTree);
    procedure SetParentHandle(const Value: HWND);
    { Private declarations }
  protected
    procedure Execute; override;
  public
    property Connection: TZConnection read FConnection write SetConnection;
    property DataSource: IImportDataSource read FDataSource write SetDataSource;
    property TreeView: TVirtualStringTree read FTreeView write SetTreeView;
    property ParentHandle: HWND read FParentHandle write SetParentHandle;
  end;

implementation

uses
  FormProgress;

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure TImportThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ TImportThread }

procedure TImportThread.Execute;
var
  Query: TZQuery;
  P: PCustomerRecord;
  Node: PVirtualNode;
  F: TFrmProgress;
begin

  Query:=TZQuery.Create(nil);
  try
    if FDataSource.showConnectionSetting(ParentHandle) then
    begin
      FDataSource.getCustomerDataset(Query);
      if Query.RecordCount > 0 then
      begin
        F:=TFrmProgress.Create(Application);

        try
          F.Show;
          F.Repaint;
          //TreeView.BeginUpdate;
          //TreeView.Clear;
          Query.First;
          while (not Query.Eof)
            and (not F.IsCancelled)
          do
          begin
            //Node:=TreeView.AddChild(nil);
            //P:=TreeView.GetNodeData(Node);
            New(P);
            FDataSource.fetchCustomerRecord(Query, P^);
            F.lblData.Caption:=P^.Name;
            F.lblData.Repaint;
            Query.Next;
            Dispose(P);
            F.Refresh;
          end;
          //TreeView.EndUpdate;
          F.Close;
        finally
          FreeAndNil(F);
        end;

      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TImportThread.SetConnection(const Value: TZConnection);
begin
  FConnection := Value;
end;

procedure TImportThread.SetDataSource(const Value: IImportDataSource);
begin
  FDataSource := Value;
end;

procedure TImportThread.SetParentHandle(const Value: HWND);
begin
  FParentHandle := Value;
end;

procedure TImportThread.SetTreeView(const Value: TVirtualStringTree);
begin
  FTreeView := Value;
end;

end.
