object FrmSelectDataSource: TFrmSelectDataSource
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pilih Database'
  ClientHeight = 222
  ClientWidth = 507
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lstDatabase: TListBox
    Left = 20
    Top = 20
    Width = 381
    Height = 177
    ItemHeight = 13
    Items.Strings = (
      'Asta Multimedia - MySQL')
    TabOrder = 0
    OnDblClick = lstDatabaseDblClick
  end
  object btnOK: TButton
    Left = 417
    Top = 20
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 417
    Top = 51
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
  object appevents: TApplicationEvents
    OnActivate = appeventsActivate
    Left = 352
    Top = 32
  end
end
