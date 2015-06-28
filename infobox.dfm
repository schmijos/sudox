object InfoBox_form: TInfoBox_form
  Left = 236
  Top = 142
  AlphaBlend = True
  AlphaBlendValue = 0
  BorderStyle = bsNone
  Caption = 'About'
  ClientHeight = 227
  ClientWidth = 290
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 35
    Top = 97
    Width = 218
    Height = 16
    Caption = 'als Maturaarbeit im Fach Mathematik'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label5: TLabel
    Left = 100
    Top = 73
    Width = 88
    Height = 16
    Caption = 'im Herbst 2006'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 24
    Top = 145
    Width = 241
    Height = 16
    Caption = 'und Korreferent Herr Daniel Baumgartner'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 27
    Top = 121
    Width = 235
    Height = 16
    Caption = 'mit Betreuung von Herr Daniel Germann'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 50
    Top = 49
    Width = 188
    Height = 16
    Caption = 'geschrieben von Josua Schmid'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 77
    Top = 17
    Width = 130
    Height = 16
    Caption = 'SudoX - Release 1'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 192
    Width = 157
    Height = 16
    Caption = 'Releasedatum: 17.11.2006'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object InfoBoxTimer1: TTimer
    Enabled = False
    Interval = 5
    OnTimer = InfoBoxTimer1Timer
    Left = 188
    Top = 179
  end
  object InfoBoxTimer2: TTimer
    Enabled = False
    Interval = 5
    OnTimer = InfoBoxTimer2Timer
    Left = 220
    Top = 179
  end
end
