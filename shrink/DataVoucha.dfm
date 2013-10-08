object DataModuleVoucha: TDataModuleVoucha
  OldCreateOrder = False
  Height = 329
  Width = 586
  object Connection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = ''
    BeforeConnect = ConnectionBeforeConnect
    AfterConnect = ConnectionAfterConnect
    AfterDisconnect = ConnectionAfterDisconnect
    HostName = ''
    Port = 5432
    Database = ''
    User = 'voucha4'
    Password = ''
    Protocol = 'postgresql'
    Left = 20
    Top = 16
  end
  object Proc: TZSQLProcessor
    Params = <>
    Connection = Connection
    Delimiter = ';'
    OnError = ProcError
    AfterExecute = ProcAfterExecute
    BeforeExecute = ProcBeforeExecute
    Left = 16
    Top = 72
  end
end
