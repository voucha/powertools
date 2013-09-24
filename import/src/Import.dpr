program Import;

uses
  Vcl.Forms,
  FormMain in 'FormMain.pas' {FrmMain},
  FormSelectDatasource in 'FormSelectDatasource.pas' {FrmSelectDataSource},
  FormSettingMySQL in 'FormSettingMySQL.pas' {FrmSettingMySQL},
  FormProgress in 'FormProgress.pas' {FrmProgress},
  Customers in 'Customers.pas',
  DataSourceAmcc in 'DataSourceAmcc.pas' {DataAmcc: TDataModule},
  ImportDialogs in 'ImportDialogs.pas',
  Settings in 'Settings.pas',
  DataSourceIntf in 'DataSourceIntf.pas',
  ThreadImport in 'ThreadImport.pas',
  FormSettingPostgreSQL in 'FormSettingPostgreSQL.pas' {FrmSettingPostgreSQL},
  DataTargetVoucha4 in 'DataTargetVoucha4.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TDataAmcc, DataAmcc);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
