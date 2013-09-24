unit FormSelectDatasource;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts;

type
  TFrmSelectDataSource = class(TForm)
    lstDatabase: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    appevents: TApplicationEvents;
    procedure appeventsActivate(Sender: TObject);
    procedure lstDatabaseDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function getSelectedIndex: Integer;
    procedure setSelectedIndex(const Value: Integer);
  end;

var
  FrmSelectDataSource: TFrmSelectDataSource;

implementation

{$R *.dfm}

procedure TFrmSelectDataSource.appeventsActivate(Sender: TObject);
begin
  Show;
end;

function TFrmSelectDataSource.getSelectedIndex: Integer;
begin
  Result := lstDatabase.ItemIndex;
end;

procedure TFrmSelectDataSource.lstDatabaseDblClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFrmSelectDataSource.setSelectedIndex(const Value: Integer);
begin
  lstDatabase.ItemIndex:=Value;
end;

end.
