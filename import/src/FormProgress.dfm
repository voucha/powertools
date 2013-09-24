object FrmProgress: TFrmProgress
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Import Progress'
  ClientHeight = 222
  ClientWidth = 568
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
  object Label1: TLabel
    Left = 20
    Top = 16
    Width = 204
    Height = 13
    Caption = 'Harap tunggu, sedang mengimport data...'
  end
  object Label2: TLabel
    Left = 20
    Top = 112
    Width = 46
    Height = 13
    Caption = 'Progress:'
  end
  object lblCounter: TLabel
    Left = 76
    Top = 112
    Width = 473
    Height = 13
    AutoSize = False
    Caption = '0 / 0'
  end
  object Label3: TLabel
    Left = 20
    Top = 136
    Width = 30
    Height = 13
    Caption = 'Table:'
  end
  object lbTableName: TLabel
    Left = 76
    Top = 136
    Width = 473
    Height = 13
    AutoSize = False
    Caption = '-'
  end
  object Label4: TLabel
    Left = 20
    Top = 160
    Width = 27
    Height = 13
    Caption = 'Data:'
  end
  object lblData: TLabel
    Left = 76
    Top = 160
    Width = 473
    Height = 13
    AutoSize = False
    Caption = '-'
  end
  object ProgressBar: TProgressBar
    Left = 20
    Top = 188
    Width = 529
    Height = 17
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 474
    Top = 16
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object appevents: TApplicationEvents
    OnActivate = appeventsActivate
    Left = 520
    Top = 48
  end
end
