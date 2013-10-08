object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Shrink Database'
  ClientHeight = 491
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    666
    491)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 81
    Caption = 'Pilih interval'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 209
      Height = 13
      Caption = 'Shrink database sampai interval'
    end
    object cbbInterval: TComboBox
      Left = 8
      Top = 43
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = '1 minggu'
      OnChange = cbbIntervalChange
      Items.Strings = (
        '1 minggu'
        '1 bulan'
        '1 tahun'
        'Custom')
    end
    object dtpDate: TDateTimePicker
      Left = 111
      Top = 43
      Width = 106
      Height = 21
      Date = 41555.893581504630000000
      Format = 'dd-MM-yyyy'
      Time = 41555.893581504630000000
      Enabled = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 95
    Width = 233
    Height = 110
    Caption = 'Waktu eksekusi'
    TabOrder = 1
    object rbNow: TRadioButton
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = '&Sekarang'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = changeSchedule
    end
    object rbSchedule: TRadioButton
      Left = 8
      Top = 47
      Width = 113
      Height = 17
      Caption = '&Jadwalkan'
      TabOrder = 1
      OnClick = changeSchedule
    end
    object cbbSchedule: TComboBox
      Left = 8
      Top = 70
      Width = 97
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemIndex = 0
      TabOrder = 2
      Text = '00:00'
      Items.Strings = (
        '00:00'
        '01:00'
        '02:00'
        '03:00'
        '04:00'
        '05:00'
        '06:00'
        '07:00'
        '08:00'
        '09:00'
        '10:00'
        '11:00'
        '12:00'
        '13:00'
        '14:00'
        '15:00'
        '16:00'
        '17:00'
        '18:00'
        '19:00'
        '20:00'
        '21:00'
        '22:00'
        '23:00')
    end
  end
  object mmLog: TMemo
    Left = 251
    Top = 8
    Width = 407
    Height = 469
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnStart: TButton
    Left = 8
    Top = 211
    Width = 75
    Height = 25
    Caption = '&Start'
    TabOrder = 3
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 89
    Top = 211
    Width = 75
    Height = 25
    Caption = 'Sto&p'
    Enabled = False
    TabOrder = 4
  end
end
