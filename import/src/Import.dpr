program Import;

uses
  Vcl.Forms,
  FormMain in 'FormMain.pas' {FrmMain},
  FormSelectDatasource in 'FormSelectDatasource.pas' {FrmSelectDataSource},
  FormSettingMySQL in 'FormSettingMySQL.pas' {FrmSettingMySQL},
  FormProgress in 'FormProgress.pas' {FrmProgress},
  Customers in 'Customers.pas',
  DataSourceAmcc in 'DataSourceAmcc.pas' {SourceAmcc: TDataModule},
  ImportDialogs in 'ImportDialogs.pas',
  Settings in 'Settings.pas',
  DataSourceIntf in 'DataSourceIntf.pas',
  FormSettingPostgreSQL in 'FormSettingPostgreSQL.pas' {FrmSettingPostgreSQL},
  DataTargetVoucha4 in 'DataTargetVoucha4.pas' {TargetVoucha4: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TSourceAmcc, SourceAmcc);
  Application.CreateForm(TTargetVoucha4, TargetVoucha4);
  Application.Run;
end.
