// Mainprogramm für SudoX: geschrieben von Josua Schmid

unit main_script;

interface
    
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, Menus, Math, IniFiles, StrUtils, shellapi,
  sudoku;

type
  T2DArray = Array of Array of ShortInt;
  Tmain_form = class(TForm)
    MainMenu1: TMainMenu;
    Datei_menuindex: TMenuItem;
    NeuesSpiel_menupt: TMenuItem;
    line1_menupt: TMenuItem;
    Laden_menupt: TMenuItem;
    Speichern_menupt: TMenuItem;
    line2_menupt: TMenuItem;
    Beenden_menupt: TMenuItem;
    Hilfe_menuindex: TMenuItem;
    Mogeln_menupt: TMenuItem;
    SchrittVorwaerts_menupt: TMenuItem;
    SudokuFertigLoesen_menupt: TMenuItem;
    Hilfe_menupt: TMenuItem;
    About_menupt: TMenuItem;
    line3_menupt: TMenuItem;
    Optionen_menupt: TMenuItem;
    Schrittzurck1: TMenuItem;
    willkommen_lab: TLabel;
    N1: TMenuItem;
    LeeresFeld1: TMenuItem;
    procedure Beenden_menuptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function zeichnefeld(): Bool;
    function Arrayloesen(ArrayAlt : T2DArray; sDim, zDim: Integer): Boolean;
    function Arrayverkleinern
    (ArrayAlt: T2DArray; s2Dim,z2Dim,Spalte,Zeile : Integer): Boolean;
    procedure Speichern_menuptClick(Sender: TObject);
    procedure Laden_menuptClick(Sender: TObject);
    procedure EditFelderEinfaerben
    (Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure EditFelderUInputCheck(Sender: TObject);
    procedure About_menuptClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Optionen_menuptClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SchrittVorwaerts_menuptClick(Sender: TObject);
    procedure NeuesSpiel_menuptClick(Sender: TObject);
    procedure SudokuFertigLoesen_menuptClick(Sender: TObject);
    procedure Schrittzurck1Click(Sender: TObject);
    function FeldVoll(): Bool;
    procedure Hilfe_menuptClick(Sender: TObject);
    procedure LeeresFeld1Click(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  main_form: Tmain_form;

////////////////////////////////////////////////////////////////////////////////
// Eigene Typendeklarationen:

type
  TSudokuArray = Array[1..9] of Array[1..9] of ShortInt;
////////////////////////////////////////////////////////////////////////////////
// Eigene Globale Variablen:

var
  Array0 : T2DArray;
  TEMP_ReferenzArray_Reserve, Referenz_Array: array[-2..324,1..729] of ShortInt;
  StartArray: T2DArray;
  VollesSudokuArray: TSudokuArray;
  Darf_Streichen: Bool;
  Fgr,Blgr: ShortInt;      // Feldgrösse, Blockgrösse
  xcheckzaehler: SmallInt;
  AnzLoesungen: SmallInt;
  SudokuFelderArray : Array[0..8, 0..8] of TEdit;
  Anzahlloesungen : ShortInt;
  Abbruch : boolean;
  KeineLoesung: Bool;
  RueckgaengigSchritteArray: Array of Array[0..1] of ShortInt;
// END /////////////////////////////////////////////////////////////////////////

implementation

uses infobox, optionen;

{$R *.dfm}




{Global wichtige Anfangsangaben werden hier gemacht}
procedure Tmain_form.FormCreate(Sender: TObject);
var
  i: ShortInt;
  iniOptLoad: TIniFile;
begin
  Fgr := 9;
  {Ziehe die Wurzel aus der einen ShortInt-Variable in die andere}
  Blgr := StrToInt(FloatToStr(Sqrt(StrToFloat(IntToStr(Fgr)))));
  {Beginne Ladesequenz der Hilfeoptionen}
  iniOptLoad := TIniFile.Create
  (ExtractFilePath(Application.ExeName) + '\save.ini');
  For i := 1 to 5 do
  begin
    opt_MarkFelder[i] := iniOptLoad.ReadBool
    ('SavedOptions', 'MarkiereFelder' + IntToStr(i), FALSE);
    opt_FelderFarben[i] := StringToColor(iniOptLoad.ReadString
    ('SavedOptions', 'FelderFarben' + IntToStr(i), opt_StandardFarben[i]));
  end;
  iniOptLoad.Free;
end;





{Zeichne ein Feld von 9x9 Editfelder und formatiere sie}
function Tmain_form.zeichnefeld(): Bool;
var
  i,k,
  iBlockabstZ,
  iBlockabstS
  : ShortInt;
begin
  iBlockabstZ := 0;
  iBlockabstS := 0;
  For k := 1 to 9 do
  begin
    {Schaffe Abstand zwischen Blöcken in der Horizontalen}
    if (k mod 3 = 1) then
    begin
      inc(iBlockabstZ);
    end;
    For i := 1 to 9 do
    begin
      {Erschaffe Felder}
      SudokuFelderArray[k-1,i-1] := TEdit.Create(main_form);
      {Schaffe Abstand zwischen Blöcken in der Vertikalen}
      if (i mod 3 = 1) then
      begin
        inc(iBlockabstS);
      end;
      if (i mod 9 = 1) then  // gleiche aus
      begin
        dec(iBlockabstS);
        dec(iBlockabstS);
        dec(iBlockabstS);
      end;
      with SudokuFelderArray[k-1,i-1] do
      begin
        {Sonst sieht man es während der Erstellung kurz wüst aufblinken}
        Visible := FALSE;
        {ist nötig, sonst werden die Felder im Debugmodus nicht angezeigt}
        parent := main_form;
        Top := 20 * k + iBlockabstZ * 2;
        Left := 20 * i + iBlockabstS * 2;
        Width := 18;
        Height := 20;
        MaxLength := 1;
        Ctl3D := False;
        Cursor := crHandPoint;
        Color := clWhite;
        Font.Style := [];
        OnChange := EditFelderUInputCheck;
        OnMouseMove := EditFelderEinfaerben;
      end;
    end;
  end;
end;


{Speichere das aktuelle Sudokuspiel nach 'save.ini'}
procedure Tmain_form.Speichern_menuptClick(Sender: TObject);
var
  a,b: ShortInt;
  sSudokuSave: String;
  iniSudokuSave: TIniFile;
begin
  sSudokuSave := '';
  For a := 1 to 9 do
  begin
    For b := 1 to 9 do
    begin
      if SudokuFelderArray[a-1,b-1].Text = '' then
      begin
        sSudokuSave := sSudokuSave + '0';
      end
      else
      begin
        sSudokuSave := sSudokuSave + SudokuFelderArray[a-1,b-1].Text + '';
      end;
    end;
  end;
  iniSudokuSave := TIniFile.Create
  (ExtractFilePath(Application.ExeName) + '\save.ini');
  iniSudokuSave.WriteString('Spielstand 1', 'Feld', sSudokuSave);
  iniSudokuSave.Free;
end;


{Lade das aktuelle Sudokuspiel aus 'save.ini'}
procedure Tmain_form.Laden_menuptClick(Sender: TObject);
var
  a,b: ShortInt;
  sSudokuLoad: String;
  iniSudokuLoad: TIniFile;
begin
  sSudokuLoad := '';
  iniSudokuLoad := TIniFile.Create
  (ExtractFilePath(Application.ExeName) + '\save.ini');
  sSudokuLoad
  := iniSudokuLoad.ReadString('Spielstand 1', 'Feld', 'ThereIsNoSaveGame');
  iniSudokuLoad.Free;
  if sSudokuLoad = 'ThereIsNoSaveGame' then
  begin
    Application.MessageBox('Es wurde kein Spielstand gefunden.' + Chr(13)
    + 'Falls Sie schon mal ein Spiel gespeichert haben, so wurde der'
    + ' Spielstand gelöscht oder an ein anderes Ort verlegt.',
    'ThereIsNoSaveGame-Error', MB_OK);
  end
  else
  begin
    For a := 1 to 9 do        // Adaptiere geladenen String in Sudokufeld
    begin
      For b := 1 to 9 do
      begin
        if MidStr(sSudokuLoad, (a-1)*9+b,1) = '0' then
        begin
          SudokuFelderArray[a-1,b-1].Text := '';
        end
        else
        begin
          SudokuFelderArray[a-1,b-1].Text := MidStr(sSudokuLoad, (a-1)*9+b,1);
        end;
      end;
    end;
  end;
end;


{Färbe alle Felder, die die gleiche Zahl enthalten, wie das markierte}
procedure Tmain_form.EditFelderEinfaerben
(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  a,b,i,j: ShortInt;
  TempFeld: TEdit;
begin
  TempFeld := Sender as TEdit;
  {Zuerst werden alle vorigen Felder entfärbt}
  For a := 1 to 9 do
  begin
    For b := 1 to 9 do
    begin
      SudokuFelderArray[a-1,b-1].Color := clWhite;
      SudokuFelderArray[a-1,b-1].Font.Style := [];
    end;
  end;
  {Zeilen und Spalten einfärben, wenn entsprechende Optionen aktiviert sind}
  if (opt_MarkFelder[2] = TRUE)
  or (opt_MarkFelder[3] = TRUE)
  or (opt_MarkFelder[4] = TRUE) then
  begin
    For a := 1 to 9 do
    begin
      For b := 1 to 9 do
      begin
        {Suche die Koordinaten des momentan aktuellen Editfeldes}
        if SudokuFelderArray[a-1,b-1] = TempFeld then
        begin
          if (opt_MarkFelder[2] = TRUE) or (opt_MarkFelder[3] = TRUE) then
          begin
            For i := 1 to 9 do
            begin
              {Wenn die Zeilenoption im Optionenfenster aktiviert ist}
              if opt_MarkFelder[2] = TRUE then
              begin
                SudokuFelderArray[i-1,b-1].Color := opt_FelderFarben[2];
              end;
              {Wenn die Spaltenoption im Optionenfenster aktiviert ist}
              if opt_MarkFelder[3] = TRUE then
              begin
                SudokuFelderArray[a-1,i-1].Color := opt_FelderFarben[3];
              end;
            end;
          end;
          {Wenn das Häckchen für die Bloecke im Optionenfenster aktiviert ist}
          if opt_MarkFelder[4] = TRUE then
          begin
            For i := 1 to 3 do
            begin
              For j := 1 to 3 do
              begin
                SudokuFelderArray[(Ceil(a/3)*3-4 + i),(Ceil(b/3)*3-4 + j)].Color
                := opt_FelderFarben[4];
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  {Wenn das Häckchen für die Zahlen im Optionenfenster aktiviert ist}
  if opt_MarkFelder[1] = TRUE then
  begin
    {Alle Felder, die die gleiche Zahl enthalten, wie das markierte,
    werden markiert(=Fett,Gelb)}
    For a := 1 to 9 do
    begin
      For b := 1 to 9 do
      begin
        if (SudokuFelderArray[a-1,b-1].Text = TempFeld.Text)
        and (SudokuFelderArray[a-1,b-1].Text <> '')
        and (SudokuFelderArray[a-1,b-1].Text <> '0') then
        begin
          SudokuFelderArray[a-1,b-1].Color := opt_FelderFarben[1];
          SudokuFelderArray[a-1,b-1].Font.Style := [fsBold];
        end;
      end;
    end;
  end;
  {Wenn "Aktives Feld markieren" im Optionenfenster aktiviert ist}
  if opt_MarkFelder[5] = TRUE then
  begin
    For a := 1 to 9 do
    begin
      For b := 1 to 9 do
      begin
        if SudokuFelderArray[a-1,b-1].Focused = TRUE then
        begin
          SudokuFelderArray[a-1,b-1].Color := opt_FelderFarben[5];
        end;
      end;
    end;
  end;
end;


{Checke, ob der Benutzer gültige Eingaben gemacht hat}
procedure Tmain_form.EditFelderUInputCheck(Sender: TObject);
var
  i,a,b,checkvar,iArrDim: ShortInt;
  TempFeld: TEdit;
begin
  TempFeld := Sender as TEdit;
  checkvar := 0;
  {Zahlen von 0 - 9 sind gültige Eingaben}
  For i:= 0 to 9 do
  begin
    if TempFeld.Text = IntToStr(i) then
    begin
      inc(checkvar);
    end;
  end;
  {Leere Felder sind auch gültige Eingaben}
  if TempFeld.Text = '' then
  begin
    inc(checkvar);
  end;
  {Wenn die Variable nicht gleich 1 ist, so geschah eine ungültige Usereingabe}
  if checkvar <> 1 then
  begin
    Application.MessageBox
    ('Bitte geben Sie eine Zahl zwischen 1 und 9 ein oder gar nichts.',
    'UnexpectedInput-Error', MB_OK);
    TempFeld.Text := '';
  end
  else if (TempFeld.Focused = TRUE) then
  begin
    {Es wurde etwas geändert, also muss der folgende
    Menupunnkt wieder aktiviert werden}
    if Schrittzurck1.Enabled = FALSE then
    begin
      Schrittzurck1.Enabled := TRUE;
    end;
    {Speichere Benutzereingabe in einer globalen Variable ab,
    auf welche mit "Schritt Zurück" wieder zugegriffen werden kann}
    For a := 1 to 9 do
    begin
      For b := 1 to 9 do
      begin
        if (TempFeld = SudokuFelderArray[a-1,b-1]) then
        begin
          iArrDim := Length(RueckgaengigSchritteArray);
          SetLength(RueckgaengigSchritteArray,iArrDim+1);
          {Speichere Zeile}
          RueckgaengigSchritteArray[iArrDim,0] := a;
          {Speichere Spalte}
          RueckgaengigSchritteArray[iArrDim,1] := b;
        end;
      end;
    end;
  end;
end;


{Zeige die Infobox}
procedure Tmain_form.About_menuptClick(Sender: TObject);
begin
  InfoBox_form.ShowModal;
end;


{Menupunkt "Datei->Beenden" initiiert das Beenden des Programms}
procedure Tmain_form.Beenden_menuptClick(Sender: TObject);
begin
  if optionen_form.CloseQuery = TRUE then
  begin
    optionen_form.Close;
  end;
  main_form.Close;
end;


{Schaue, dass die von der Hilfefunktion markierten Felder demarkiert werden,
sobald der Mauszeiger nicht mehr im Feld ist}
procedure Tmain_form.FormMouseMove
(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  a,b: ShortInt;
begin
  if SudokuFelderArray[0,0] <> nil then
  begin
    if (X > SudokuFelderArray[9-1,9-1].Left + SudokuFelderArray[9-1,9-1].Width)
    or (Y > SudokuFelderArray[9-1,9-1].Top + SudokuFelderArray[9-1,9-1].Height)
    or (X < SudokuFelderArray[1-1,1-1].Left)
    or (Y < SudokuFelderArray[1-1,1-1].Top) then
    begin
      For a := 1 to 9 do
      begin
        For b := 1 to 9 do
        begin
          SudokuFelderArray[a-1,b-1].Color := clWhite;
          SudokuFelderArray[a-1,b-1].Font.Style := [];
        end;
      end;
    end;
  end;
end;


{Zeige das Optionenfenster an}
procedure Tmain_form.Optionen_menuptClick(Sender: TObject);
begin
  Optionen_form.Show;
end;


{Mit dem ordnungsgemässen Schliessen wird sichergestellt,
dass die Optionen gespeichert werden}
procedure Tmain_form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if optionen_form.CloseQuery = TRUE then
  begin
    optionen_form.Close;
  end;
  Application.Terminate;
end;





{Erstelle ein neues Spiel}
procedure Tmain_form.NeuesSpiel_menuptClick(Sender: TObject);
begin
  willkommen_lab.Visible := FALSE;
  ES_main§();     // Das erschaffen eines Sudokus wird iniziiert
end;





{"Schritt Zurück"-Menupunkt}
procedure Tmain_form.Schrittzurck1Click(Sender: TObject);
var
  a,b,iArrDim: ShortInt;
begin
  iArrDim := Length(RueckgaengigSchritteArray);
  {Wenn das Array nicht die Länge 0 hat, was hiesse, dass entweder noch
  nichts vom Benutzer eingegeben wurde, oder dass er alle möglichen Schritte
  zurück schon gemacht hat}
  if iArrDim <> 0 then
  begin
    {Leere das zuletzt geänderte Feld}
    a := RueckgaengigSchritteArray[iArrDim-1,0];
    b := RueckgaengigSchritteArray[iArrDim-1,1];
    SudokuFelderArray[a-1,b-1].Text := '';
    SetLength(RueckgaengigSchritteArray,iArrDim-1);
  end
  else  {Der Menupunkt wird deaktiviert}
  begin
    Schrittzurck1.Enabled := FALSE;
  end;
end;


{Kontrolliere, ob das Sudokufeld voll ist. Wenn ja, so gib TRUE zurück}
function Tmain_form.FeldVoll(): Bool;
var
  a,b,checkvar: ShortInt;
begin
  result := FALSE;
  {Checke, ob Feld voll ist}
  checkvar := 0;
  For a := 1 to 9 do
  begin
    For b := 1 to 9 do
    begin
      if SudokuFelderArray[a-1,b-1].Text = '0' then
      begin
        SudokuFelderArray[a-1,b-1].Text := '';
      end;
      if (SudokuFelderArray[a-1,b-1].Text <> '') then
      begin
        inc(checkvar);
        if checkvar = 81 then
        begin
          Application.MessageBox
          ('Das Feld ist schon voll, es macht keinen Sinn, es noch voller'
          + ' machen zu wollen','Info',0);
          result := TRUE;
        end;
      end;
    end;
  end;
end;


procedure Tmain_form.Hilfe_menuptClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(ExtractFilePath(Application.ExeName)
  + '\SudoX.hlp'), nil, nil, SW_SHOWNORMAL);
end;


{Zeichne ein leeres Feld}
procedure Tmain_form.LeeresFeld1Click(Sender: TObject);
var a,b: Integer;
begin
  willkommen_lab.Visible := FALSE;
  {Erschaffe Felder}
  If SudokuFelderArray[0,0] = nil then
  begin
    ZeichneFeld();
  end;
  For a := 1 to 9 do
  begin
    For b := 1 to 9 do
    begin
      SudokuFelderArray[a-1,b-1].Text := '';
      SudokuFelderArray[a-1,b-1].Visible := TRUE;
      SudokuFelderArray[a-1,b-1].Enabled := TRUE;
    end;
  end;
end;


//>-----------------------------------------------------------------------------
// Anzahl Prozessoren ermitteln
function GetNumberOfProcessors: Integer;
var
  SystemInfo: TSystemInfo;
begin
  GetSystemInfo(SystemInfo);
  Result := SystemInfo.dwNumberOfProcessors;
end;

end.
