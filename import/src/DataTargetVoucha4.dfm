object TargetVoucha4: TTargetVoucha4
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 224
  Width = 397
  object Connection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = ''
    BeforeConnect = ConnectionBeforeConnect
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 28
    Top = 16
  end
  object ZQuery: TZQuery
    Connection = Connection
    Params = <>
    Left = 28
    Top = 76
  end
  object ZSql: TZSQLProcessor
    Params = <>
    Connection = Connection
    Delimiter = ';'
    Left = 28
    Top = 132
  end
end
