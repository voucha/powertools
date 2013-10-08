program ShrinkGUI;

uses
  Vcl.Forms,
  FormMain in 'FormMain.pas' {FrmMain},
  DataVoucha in 'DataVoucha.pas' {DataModuleVoucha: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TDataModuleVoucha, DataModuleVoucha);
  Application.Run;
end.
