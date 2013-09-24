object FrmSettingMySQL: TFrmSettingMySQL
  Left = 0
  Top = 0
  ActiveControl = edtHostname
  BorderStyle = bsDialog
  Caption = 'MySQL Connection Setting'
  ClientHeight = 245
  ClientWidth = 494
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
  object grpSetting: TGroupBox
    Left = 16
    Top = 16
    Width = 373
    Height = 205
    Caption = '&Setting'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 27
      Width = 62
      Height = 13
      Caption = 'Hostname/IP'
    end
    object Label2: TLabel
      Left = 16
      Top = 54
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Label3: TLabel
      Left = 16
      Top = 81
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object Label4: TLabel
      Left = 16
      Top = 108
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label5: TLabel
      Left = 16
      Top = 135
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object edtHostname: TEdit
      Left = 164
      Top = 24
      Width = 189
      Height = 21
      TabOrder = 0
      Text = 'localhost'
    end
    object edtDatabase: TEdit
      Left = 164
      Top = 51
      Width = 189
      Height = 21
      TabOrder = 1
    end
    object edtUsername: TEdit
      Left = 164
      Top = 78
      Width = 189
      Height = 21
      TabOrder = 2
      Text = 'root'
    end
    object edtPassword: TEdit
      Left = 164
      Top = 105
      Width = 189
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object edtPort: TEdit
      Left = 164
      Top = 132
      Width = 189
      Height = 21
      NumbersOnly = True
      TabOrder = 4
      Text = '3306'
    end
    object btnTest: TButton
      Left = 164
      Top = 164
      Width = 75
      Height = 25
      Caption = '&Test'
      TabOrder = 5
    end
    object btnShowPassword: TButton
      Left = 245
      Top = 164
      Width = 108
      Height = 25
      Caption = 'Show &Password'
      TabOrder = 6
      OnClick = btnShowPasswordClick
    end
  end
  object btnOK: TButton
    Left = 405
    Top = 16
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 405
    Top = 47
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object appevents: TApplicationEvents
    Left = 352
    Top = 32
  end
end
