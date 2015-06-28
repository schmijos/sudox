object Optionen_form: TOptionen_form
  Left = 400
  Top = 226
  BorderStyle = bsToolWindow
  Caption = 'Optionen'
  ClientHeight = 182
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object HilfeStellung_grpbox: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 145
    Caption = 'Hilfestellung'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object ChoseColor1_lab: TLabel
      Left = 176
      Top = 16
      Width = 25
      Height = 25
      AutoSize = False
      Color = clYellow
      Enabled = False
      ParentColor = False
      OnClick = ChoseColorClick
    end
    object ChoseColor2_lab: TLabel
      Left = 176
      Top = 40
      Width = 25
      Height = 25
      AutoSize = False
      Color = clMoneyGreen
      Enabled = False
      ParentColor = False
      OnClick = ChoseColorClick
    end
    object ChoseColor3_lab: TLabel
      Left = 176
      Top = 64
      Width = 25
      Height = 25
      AutoSize = False
      Color = clMoneyGreen
      Enabled = False
      ParentColor = False
      OnClick = ChoseColorClick
    end
    object ChoseColor4_lab: TLabel
      Left = 176
      Top = 88
      Width = 25
      Height = 25
      AutoSize = False
      Color = clSkyBlue
      Enabled = False
      ParentColor = False
      OnClick = ChoseColorClick
    end
    object ChoseColor5_lab: TLabel
      Left = 176
      Top = 112
      Width = 25
      Height = 25
      AutoSize = False
      Color = clInfoBk
      Enabled = False
      ParentColor = False
      OnClick = ChoseColorClick
    end
    object MarkFelder1_chkbox: TCheckBox
      Left = 8
      Top = 24
      Width = 145
      Height = 17
      Caption = 'Markiere gleiche Zahlen'
      TabOrder = 0
      OnClick = MarkFelder_chkboxClick
    end
    object MarkFelder2_chkbox: TCheckBox
      Left = 8
      Top = 48
      Width = 145
      Height = 17
      Caption = 'Markiere gleiche Zeilen'
      TabOrder = 1
      OnClick = MarkFelder_chkboxClick
    end
    object MarkFelder3_chkbox: TCheckBox
      Left = 8
      Top = 72
      Width = 153
      Height = 17
      Caption = 'Markiere gleiche Spalten'
      TabOrder = 2
      OnClick = MarkFelder_chkboxClick
    end
    object MarkFelder4_chkbox: TCheckBox
      Left = 8
      Top = 96
      Width = 153
      Height = 17
      Caption = 'Markiere momentanen Block'
      TabOrder = 3
      OnClick = MarkFelder_chkboxClick
    end
    object MarkFelder5_chkbox: TCheckBox
      Left = 8
      Top = 120
      Width = 153
      Height = 17
      Caption = 'Markiere aktives Feld'
      TabOrder = 4
      OnClick = MarkFelder_chkboxClick
    end
  end
  object OptOK_btn: TButton
    Left = 136
    Top = 160
    Width = 81
    Height = 17
    Caption = 'Schliessen'
    TabOrder = 1
    OnClick = OptOK_btnClick
  end
  object SetToStandard_btn: TButton
    Left = 8
    Top = 160
    Width = 75
    Height = 17
    Caption = 'Standard'
    TabOrder = 2
    OnClick = SetToStandard_btnClick
  end
  object opt_ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 152
    Top = 48
  end
end
