// Optionenfenster-Code für SudoX: geschrieben von Josua Schmid

unit optionen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, ExtCtrls;

type
  TOptionen_form = class(TForm)
    HilfeStellung_grpbox: TGroupBox;
    MarkFelder1_chkbox: TCheckBox;
    MarkFelder2_chkbox: TCheckBox;
    MarkFelder3_chkbox: TCheckBox;
    MarkFelder4_chkbox: TCheckBox;
    OptOK_btn: TButton;
    opt_ColorDialog: TColorDialog;
    ChoseColor1_lab: TLabel;
    ChoseColor2_lab: TLabel;
    ChoseColor3_lab: TLabel;
    ChoseColor4_lab: TLabel;
    SetToStandard_btn: TButton;
    ChoseColor5_lab: TLabel;
    MarkFelder5_chkbox: TCheckBox;
    procedure OptOK_btnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MarkFelder_chkboxClick(Sender: TObject);
    procedure ChoseColorClick(Sender: TObject);
    procedure SetToStandard_btnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Optionen_form: TOptionen_form;
  {Setze Optionenvariable für das Markieren der:
  gleichen Zahlen (opt_MarkFelder[1]),
  gleichen Zeilen (opt_MarkFelder[2]),
  gleichen Spalten (opt_MarkFelder[3]),
  gleichen Bloecke (opt_MarkFelder[4])}
  opt_MarkFelder: Array[1..5] of Boolean;
  opt_FelderFarben: Array[1..5] of TColor;
const
  {Lege Standardfarben fest}
  opt_StandardFarben: Array[1..5] of String
  = ('clYellow','clMoneyGreen','clMoneyGreen','clSkyBlue','clInfoBk');

implementation

{$R *.dfm}


{Schliesse das Fenster (und speichere auch die Optionen mit OnClose)}
procedure TOptionen_form.OptOK_btnClick(Sender: TObject);
begin
  Optionen_form.Close;
end;


procedure TOptionen_form.FormCreate(Sender: TObject);
var
  i: ShortInt;
begin
  {Aktualisiere die Checkboxen mit der OptionenVariable}
  For i := 1 to 5 do
  begin
    {"Bemale" die Felder mit der geladenen Farbe}
    TLabel(FindComponent('ChoseColor' + IntToStr(i) + '_lab'))
    .Color := opt_FelderFarben[i];
    if opt_MarkFelder[i] = TRUE then
    begin
      TCheckBox(FindComponent('MarkFelder' + IntToStr(i) + '_chkbox'))
      .State := cbChecked;
    end
    else
    begin
      TCheckBox(FindComponent('MarkFelder' + IntToStr(i) + '_chkbox'))
      .State := cbUnchecked;
    end;
  end;
end;

{Aktiviere die ColorFelder bei gehäkeltem Optioneneintrag}
procedure TOptionen_form.MarkFelder_chkboxClick(Sender: TObject);
var
  TempCheckBox: TCheckBox;
  i: ShortInt;
begin
  TempCheckBox := Sender as TCheckBox;
  For i := 1 to 5 do
  begin
    if TempCheckBox = TCheckBox
    (FindComponent('MarkFelder' + IntToStr(i) + '_chkbox')) then
    begin
      if TempCheckBox.Checked = TRUE then
      begin
        TLabel(FindComponent('ChoseColor' + IntToStr(i) + '_lab')).Enabled
        := TRUE;
        {Schreibe die ausgewählten Farben in das globale Array}
        opt_FelderFarben[i]
        := TEdit(FindComponent('ChoseColor' + IntToStr(i) + '_lab')).Color;
        opt_MarkFelder[i] := TRUE;
      end
      else
      begin
        TLabel(FindComponent('ChoseColor' + IntToStr(i) + '_lab')).Enabled
        := FALSE;
        opt_MarkFelder[i] := FALSE;
      end;
    end;
  end;
end;

{Sobald auf die Farben im Optionenfester geklickt wird}
procedure TOptionen_form.ChoseColorClick(Sender: TObject);
var
  TempLabel: TLabel;
  i: ShortInt;
begin
  TempLabel := Sender as TLabel;
  For i := 1 to 5 do
  begin
    if TempLabel = TLabel
    (FindComponent('ChoseColor' + IntToStr(i) + '_lab')) then
    begin
      opt_ColorDialog.Tag := i;
    end;
  end;
  {Zeige das Farbenwählfenster}
  opt_ColorDialog.Execute;
  TLabel(FindComponent('ChoseColor' + IntToStr(opt_ColorDialog.Tag)
  + '_lab')).Color := opt_ColorDialog.Color;
  {Checke, ob die Optionen Aktiviert sind und schreibe es
  in die globale Variable}
  For i := 1 to 5 do
  begin
    if TCheckBox(FindComponent('MarkFelder' + IntToStr(i) + '_chkbox')).State
    = cbChecked then
    begin
      opt_MarkFelder[i] := TRUE;
    end
    else
    begin
      opt_MarkFelder[i] := FALSE;
    end;
  end;
  {Schreibe die ausgewählten Farben in das globale Array}
  For i := 1 to 5 do
  begin
    opt_FelderFarben[i] := TEdit
    (FindComponent('ChoseColor' + IntToStr(i) + '_lab')).Color;
  end;
  SetToStandard_btn.Enabled := TRUE;
end;

procedure TOptionen_form.SetToStandard_btnClick(Sender: TObject);
var i: Integer;
begin
  For i := 1 to 5 do
  begin
    TLabel(FindComponent('ChoseColor' + IntToStr(i) + '_lab')).Color
    := StringToColor(opt_StandardFarben[i]);
  end;
  SetToStandard_btn.Enabled := FALSE;
end;

{Vor dem Schliessen des Programmes werden die Optionen gespeichert}
procedure TOptionen_form.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: ShortInt;
  iniOptSave: TIniFile;
begin
  {Beginne Speichersequenz}
  iniOptSave := TIniFile.Create
  (ExtractFilePath(Application.ExeName) + '\save.ini');
  For i := 1 to 5 do
  begin
    iniOptSave.WriteBool('SavedOptions', 'MarkiereFelder'
    + IntToStr(i), opt_MarkFelder[i]);
    iniOptSave.WriteString('SavedOptions', 'FelderFarben'
    + IntToStr(i), ColorToString(opt_FelderFarben[i]));
  end;
  iniOptSave.Free;
end;

end.
