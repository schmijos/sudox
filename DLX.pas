// DLX-Implementation für SudoX: geschrieben von Josua Schmid
// Dancing Links Extension

// Typen:
{
  TDLXSudokuArray: 4 verkettete Adjazenzlisten für den X-Algorithmus
  TDLXField: Ein Feld in TDLXArray mit Verweisen auf 4 Nachbarfelder
}

unit DLX;

interface

uses
  Math, Classes;

type
  TDLXAdjazenzfeld = class
  public
    position: ShortInt;
    prev,next,right: ^TDLXAdjazenzfeld;
    constructor make_with_relation(a_position: Boolean);
  end;

  TDLXAdjazenzliste = class               // doubly linked list
  public
    head, tail, item, last_item: TDLXAdjazenzfeld;
    function GetCount(): Integer;
    property count: Integer read GetCount;
    constructor make_empty();
    procedure append_empty();
    procedure append_with();
  end;

  TDLXSudokuArray = class
    sdim, sbdim: Integer;       // Sudoku dimension, Sudokublock dimension
    dlx_array: Array of TDLXAdjazenzliste;
    vert_dim: Integer;
    sudoku_linker: Array of Array of Array of ^TDLXAdjazenzfeld;
    constructor make_with_sudokudim(a_dim: Integer);
    procedure delete_trivials;
    function hasSolution(): Boolean;
  end;

implementation

constructor TDLXAdjazenzliste.make_empty;
begin
  head := TDLXAdjazenzfeld.create;
  tail := TDLXAdjazenzfeld.create;
  item := TDLXAdjazenzfeld.create;
  head.prev := nil;
  head.right := nil;
  head.next := @tail;
  tail.prev := @head;
  tail.right := nil;
  tail.next := nil;
  item := head;
  last_item := nil;
end;

procedure TDLXAdjazenzliste.append_empty();
begin
  last_item := item;
  item.prev := @last_item;
  last_item.next := @item;
  


end;

{Erstelle StartArray}
constructor TDLXSudokuArray.make_with_sudokudim(a_dim: Integer);
{Hier wird der Referenzarray (alle Möglichkeiten für alle Felder kombiniert mit
den Bedingungen (Zahl/Feld, Zahl/Zeile, Zahl/Spalte, Zahl/Block) erschaffen}
var
  i,j,k: Integer;
begin
  // initialisiere die verschiedenen Sektionen
  sdim := a_dim;
  sbdim := Round(sqrt(sdim));                // Block Dimension

  SetLength(dlx_array, 4*sdim*sdim);

  For i := 1 to Length(dlx_array) do
  begin
    dlx_array[]
  end;

  ZahlFeld := TDLXAdjazenzliste.Create;
  ZahlZeile := TDLXAdjazenzliste.Create;
  ZahlSpalte := TDLXAdjazenzliste.Create;
  ZahlBlock := TDLXAdjazenzliste.Create;

  SetLength(LinkArray, sdim);       // der Array ist nun so ansprechbar:
  SetLength(LinkArray[0], sdim);    // LinArray[2,4,8] dieser Inhalt beschreibt
  SetLength(LinkArray[0,0], sdim);  // die 2. Zeile, 4. Spalte und den Wert 8

  ZahlFeld.item := ZahlFeld.head;
  ZahlZeile.item := ZahlZeile.head;
  ZahlSpalte.item := ZahlSpalte.head;
  ZahlBlock.item := ZahlBlock.head;

  For i := 1 to a_dim do
  begin
    For j := 1 to a_dim do
    begin
      For k := 1 to a_dim do
      begin
        // save current item for the next pass
        ZahlFeld.last_item := ZahlFeld.item;
        ZahlZeile.last_item := ZahlZeile.item;
        ZahlSpalte.last_item := ZahlSpalte.item;
        ZahlBlock.last_item := ZahlBlock.item;
        // switch to next
        ZahlFeld.item := ZahlFeld.item.next^;
        ZahlZeile.item := ZahlZeile.item.next^;
        ZahlSpalte.item := ZahlSpalte.item.next^;
        ZahlBlock.item := ZahlBlock.item.next^;
        // link to previous
        ZahlFeld.item := ZahlFeld.item.next^;
        ZahlZeile.item := ZahlZeile.item.next^;
        ZahlSpalte.item := ZahlSpalte.item.next^;
        ZahlBlock.item := ZahlBlock.item.next^;
        // set vertical relationship
        ZahlFeld.item.position := (i-1)*dim + (j-1);
        ZahlZeile.item.position := (i-1)*dim + (k-1);
        ZahlSpalte.item.position := (j-1)*dim + (k-1);
        ZahlBlock.item.position :=
          (Ceil(i/bdim) + ((Ceil(j/bdim)-1) * bdim)-1) * dim + k;
        // link to right
        sudoku_linker[i,j,k] := @ZahlFeld.item;
        ZahlFeld.item.right := @ZahlZeile.item;
        ZahlZeile.item.right := @ZahlSpalte.item;
        ZahlSpalte.item.right := @ZahlBlock.item;
        ZahlBlock.item.right := nil;
      end;
    end;
  end;

  ZahlFeld.item.next := ZahlFeld.item.next^;
  ZahlZeile.item.next := ZahlZeile.item.next^;
  ZahlSpalte.item.prev := ZahlSpalte.item.next^;
  ZahlBlock.item.prev := ZahlBlock.item.next^;

end;

procedure TDLXSudokuArray.delete_trivials;
begin

end;

function TDLXAdjazenzliste.GetCount(): Integer;
begin
  Result := 0;
  item := head;
  while item <> tail do
  begin
    inc(Result);
    item := item.next;
  end;
end;

function TDLXSudokuArray.hasSolution(): Boolean;
begin
  Result := false;
end;





//>-----------------------------------------------------------------------------
// temp: to implement:
{Teil des X-Algorithmus: Suchen
Suche die weiter zu verfolgenden Zeilen mit dem Schema des X-Algorithmus}
function Tmain_form.Arrayloesen
(ArrayAlt : T2DArray; sDim, zDim: Integer): Boolean;
var
  Zeile, Spalte,   // momentane Zeile / Spalte
  MinSpalte,       // Spalte mit den wenigsten 1en
  MinSumme,        // die minimale Summe der 1en der minimalen Spalte
  SpaltenSumme     // momentane Summe der 1en der momentanen Spalte
  : Integer;
  Fertig : Boolean;
  Array1 : T2DArray;
begin
  {Neues Array füllen (wegen Rekursion) = Sicherungskopie}
  SetLength(Array1,zDim + 1);
  for Zeile:= 0 to zDim do
  begin
    SetLength(Array1[Zeile],sDim + 1);
    for Spalte := 0 to sDim do
    begin
      Array1[Zeile,Spalte] := ArrayAlt[Zeile,Spalte];
    end;
  end;
  {Spalte mit minimalen 1 suchen}
  MinSpalte := 3;
  MinSumme := 0;
  for Zeile := 1 to zdim do
  begin
    MinSumme := MinSumme + Array1[Zeile,3];
  end;
  Spalte := 4;
  while (Spalte <= sDim) and (MinSumme > 0) do
  begin
    SpaltenSumme := 0;
    for Zeile := 1 to zdim do
    begin
      SpaltenSumme := SpaltenSumme + Array1[Zeile,Spalte];
    end;
    if SpaltenSumme < MinSumme then
    begin
      MinSpalte := Spalte;
      MinSumme := SpaltenSumme;
    end;
    inc(Spalte);
  end;
  {Falls das Minimale Summe = 0 ist, ist das Suchen fertig}
  if MinSumme = 0 then
  begin
    {überprüfen ob noch 1 vorhanden}
    fertig := false;
    Spalte := 3;
    while (Spalte <= sDim) and (fertig = false) do
    begin
      Zeile := 1;
      while (Zeile <= zDim) and (fertig = false) do
      begin
        if Array1[Zeile,Spalte] = 1 then
        begin
          fertig := true;
        end
        else
        begin
          inc(Zeile);
        end;
      end;
      inc(Spalte);
    end;

    if fertig = true then  {Wenn noch eine 1 im Array}
    begin
      result := false;
    end
    else  {Sonst, wenn nicht noch eine 1 -> Eine Lösung gefunden}
    begin
      {Wenn noch nie eine Lösung gefunden wurde}
      If Anzahlloesungen = 0 then
      begin
        {Lösung abspeichern}
        inc(Anzahlloesungen);
        result := false;
      end
      else {Sonst, wenn schon mal eine Lösung gefunden wurde}
      begin
        result := true;
        Abbruch := true;
     end;
    end;
  end
  else  {sonst, wenn minimale Summe <> 0}
  begin
    Zeile := 1;
    while (Zeile <= zDim) and (Abbruch = false) do
    begin
      {jeden 1er in der minimalen Spalte testen}
      if Array1[Zeile,MinSpalte] = 1 then
      begin
        {Array vom aktuellen 1er aus verkleinern}
        VollesSudokuArray[Array1[Zeile,2],Array1[Zeile,1]] := Array1[Zeile,0];
        Result := Arrayverkleinern(Array1,sDim,zDim,MinSpalte,Zeile);
      end;
      inc(Zeile);
    end;
  end;
  if Fertig = TRUE then
  begin
    {Gib Meldung aus, wenn das Sudoku keine Lösung gibt}
    Application.MessageBox('Das Sudoku hat keine mögliche Lösung.', 'Look', 0);
  end;
end;


{Teil des X-Algorithmus: Löschen
Verkleinere das übergebene Array nach Schema des X-Algorithmus und rekursiere
mit dem Resultat zur Funktion "ArrayLoesen"}
function Tmain_form.Arrayverkleinern
(ArrayAlt : T2DArray; s2Dim,z2Dim,Spalte,Zeile : Integer): Boolean;
var
  Spalte2,Zeile2, zZaehler, sZaehler : Integer;
  Array2 : T2DArray;
begin
  {Neues Array füllen (wegen Rekursion)}
  SetLength(Array2,z2Dim + 1);
  for Zeile2:= 0 to z2Dim do
  begin
    SetLength(Array2[Zeile2],s2Dim + 1);
    for Spalte2 := 0 to s2Dim do
    begin
      Array2[Zeile2,Spalte2] := ArrayAlt[Zeile2,Spalte2];
    end;
  end;
  {aktuelle Zeile vor dem Löschen in Zeile 0 schreiben}
  zZaehler := 0;
  Array2[0] := Array2[Zeile];
  spalte2 := 3;
  while Spalte2 <= s2Dim do
  begin
    if Array2[0,Spalte2] = 1 then
    begin
      Zeile2 := 1;
      while Zeile2 <= z2Dim-zZaehler do
      begin
        If Array2[Zeile2,Spalte2] = 1 then
        begin
          {zu löschende Zeile mit der hintersten Zeile überschreiben}
          Array2[Zeile2] := Array2[z2Dim-zZaehler];
          inc(zZaehler);
        end
        else
        begin
          inc(Zeile2);
        end;
      end;
    end;
    inc(Spalte2);
  end;
  sZaehler := 0;
  Spalte2 := 3;
  while Spalte2 <= s2Dim - sZaehler do
  begin
    If Array2[0,Spalte2] = 1 then
    begin
      Zeile2 := 0;
      while Zeile2 <= z2Dim - zZaehler do
      begin
        {zu löschende Spalte mit der hintersten Spalte überschreiben}
        Array2[Zeile2,Spalte2] := Array2[Zeile2,s2Dim-sZaehler];
        inc(Zeile2);
      end;
      inc(sZaehler);
    end
    else
    begin
      inc(Spalte2);
    end;
  end;
  {Dimensionen an verkleinertes Array anpassen}
  {Gleiche Spaltenlänge anpassen}
  SetLength(Array2,z2Dim - zZaehler + 1);
  {Gleiche Zeilenlänge anpassen}
  Zeile2 := 0;
  while Zeile2 <= z2Dim - zZaehler do
  begin
    SetLength(Array2[Zeile2],s2Dim - sZaehler + 1);
    inc(Zeile2);
  end;
  {mit verkleinertem Array wieder vorne einsteigen}
  Result := Arrayloesen(Array2, s2Dim-sZaehler, z2Dim - zZaehler);
end;


procedure minimizeArray();
var
  HoerAuf, Abbruch: Boolean;
  AnzahlLoesungen: Integer;
begin
  {Streiche solange Felder bis das Sudoku nicht mehr eindeutig ist
  und setze dann letzten Wert wieder ein}
  HoerAuf := FALSE;
  while HoerAuf = FALSE do
  begin
    {Erstelle StartArray}
    StartArrayErstellen();
    Abbruch := FALSE;
    AnzahlLoesungen := 0;
    {Wenn Sudoku eine Lösung gibt}
    if Arrayloesen(StartArray,326,729-SudokuEinlesen()) = FALSE then
    begin
      {Wenn Sudoku nur eine Lösung gibt}
      if Abbruch = FALSE then
      begin
        WertGeloescht := FALSE;
        {Solange kein Wert gelöscht wurde}
        While WertGeloescht = FALSE do
        begin
          {Generiere Zufallskoordinaten}
          TEMP_WertZ := Random(dim)+1;
          TEMP_WertS := Random(dim)+1;
          {Wenn das Feld eine Null einthält, überschreibe es mit "nichts"}
          if (SudokuFelderArray[TEMP_WertZ-1,TEMP_WertS-1].Text = '0') then
            SudokuFelderArray[TEMP_WertZ-1,TEMP_WertS-1].Text := '';
          {Wenn ein Feld einen Inhalt hat}
          if (SudokuFelderArray[TEMP_WertZ-1,TEMP_WertS-1].Text <> '') then
          begin
            {Speichere das Feld, das nachher gelöscht wird}
            TEMP_Feld[0]
            := StrToInt(SudokuFelderArray[TEMP_WertZ-1,TEMP_WertS-1].Text);
            TEMP_Feld[1] := TEMP_WertZ;
            TEMP_Feld[2] := TEMP_WertS;
            {Lösche das Feld}
            SudokuFelderArray[TEMP_WertZ-1,TEMP_WertS-1].Text := '';
            WertGeloescht := TRUE;
          end;
        end;
      end
      else {sonst, wenn es mehr als eine Lösung gibt}
      begin
        {Schreibe zuvor gelöschte Zahl wieder ins Feld}
        SudokuFelderArray[TEMP_Feld[1]-1,TEMP_Feld[2]-1].Text
        := IntToStr(TEMP_Feld[0]);
        {und höre auf}
        HoerAuf := TRUE;
      end;
    end
    else {sonst, wenn es keine Lösung gibt}
    begin
      {Setze vorigen Wert wieder ein}
      SudokuFelderArray[TEMP_Feld[1]-1,TEMP_Feld[2]-1].Text
      := IntToStr(TEMP_Feld[0]);
      {Mache das Feld sichtbar}
      For a := 1 to dim Do
      begin
        For b := 1 to dim Do
        begin
          SudokuFelderArray[a-1,b-1].Visible := TRUE;
          SudokuFelderArray[a-1,b-1].Enabled := TRUE;
        end;
      end;
      {und hör auf}
      HoerAuf := TRUE;
    end;
  end;
end;





end.
