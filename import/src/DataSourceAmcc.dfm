object DataAmcc: TDataAmcc
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 258
  Width = 453
  object Connection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = ''
    BeforeConnect = ConnectionBeforeConnect
    HostName = ''
    Port = 0
    Database = 'amcc2'
    User = ''
    Password = ''
    Protocol = 'mysql-5'
    Left = 28
    Top = 32
  end
end
