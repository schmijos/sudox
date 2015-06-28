// X-Algorithmus für SudoX: geschrieben von Josua Schmid
// X-Algorithmus von Donald E. Knuth
// ToDo: Zuerst mit Adjazenzmatrizen, dann mit DLX

unit XAlgorithm;

interface

implementation

{Lösche Zeilen aus dem StartArray, die sicher nicht in der Endlösung
enthalten sind}
function Tmain_form.SudokuEinlesen(): SmallInt;
var
  Zeile, Spalte, z, k, m, Zaehler : SmallInt;
begin
  {Lese Sudokufeld aus und schreibe es in den Arbeitsarray VollesSudokuArray}
  for Zeile := 1 to 9 do
  begin
    for Spalte := 1 to 9 do
    begin
      if SudokuFelderArray[Zeile-1,Spalte-1].Text <> '' then
        VollesSudokuArray[Zeile,Spalte]
        := StrToInt(SudokuFelderArray[Zeile-1,Spalte-1].Text)
      else
        VollesSudokuArray[Zeile,Spalte] := 0;
    end;
  end;
  for Zeile := 1 to 9 do
  begin
    for Spalte := 1 to 9 do
    begin
      z := VollesSudokuArray[Zeile,Spalte];
      {Wenn das momentane Feld einen Inhalt hat}
      if z <> 0 then
      begin
        for k := 1 to 9 do
        begin
          {alle (Zahlen aus vollem Feld) entfernen}
          StartArray[k*81 + Spalte*9 + Zeile - 90,0] := 0;
          {alle (Zahlen aus Zeile) entfernen}
          StartArray[z*81 + k*9 + Zeile - 90,0] := 0;
          {alle (Zahlen aus Spalte) entfernen}
          StartArray[z*81 + Spalte*9 + k - 90,0] := 0;
        end;
        {alle (Zahlen aus Block) entfernen}
        for k := -2 to 0 do
        begin
          for m := -2 to 0 do
          begin
            StartArray[81*z + 9*(Ceil(Spalte/3)*3 + m)
            + (Ceil(Zeile/3)*3 + k) - 90,0] := 0;
          end;
        end;
        StartArray[81*z + 9*Spalte + Zeile - 90,0] := z;
      end;
    end;
  end;
  {überschreibe 0er-Zeilen mit der letzten Zeile des Arrays}
  Zaehler := 0;
  Zeile := 1;
  While Zeile <= 729-Zaehler do
  begin
    if StartArray[Zeile,0] = 0 then
    begin
      StartArray[Zeile] := StartArray[729 - Zaehler];
      inc(Zaehler);
    end
    else
      inc(Zeile);
  end;
  SetLength(StartArray,729 - Zaehler + 1);  
  Result := Zaehler;
end;


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
 