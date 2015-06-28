// Sudokuverwaltungsschicht für SudoX: geschrieben von Josua Schmid

// Typen:
{
  TSudokuArray: Sudokufeld (zB: 9x9, gefüllt mit Zahlen von 0 bis 9)
  TSudoku:      Übertyp. Fasst alle Klassen für das Bearbeiten und berechnen
                von Sudokus zusammen.
}

unit sudoku;

interface

uses
  DLX;

type
  TSudokuArray = Array of Array of ShortInt;

  TSudoku = class
  private
    Spielfeld: TSudokuArray ;
    Loesung: TSudokuArray;
    dim, block_dim: ShortInt;
    DLXArray: TDLXSudokuArray;
    procedure set_dim(a_dim: ShortInt);
    procedure normSudoku();
    procedure randomizeSudoku();
    procedure minimizeSudoku();
  public
    constructor make_with_dim(a_dim: ShortInt);
    procedure setField(X,Y,Wert: ShortInt);
    function getField(X,Y: ShortInt): ShortInt;
    function isCorrect(): Boolean;
    procedure reset(a_dim: ShortInt);
  end;

implementation

{Kreiere ein fertiges Sudoku}
constructor TSudoku.make_with_dim(a_dim: ShortInt);
var
  qpcA, qpcB, qpcC: Int64;
begin
  QueryPerformanceFrequency(qpcA);        // Zeitmessung
  QueryPerformanceCounter(qpcB);

  set_dim(a_dim);               // lege die Seitenlänge eines Sudokus fest
  normSudoku();                 // erstelle ein volles Standardsudoku
  randomizeSudoku();            // individualisiere Sudoku nach festen Regeln
  minimizeSudoku();

  QueryPerformanceCounter(qpcC);
  IntToStr((qpcC - qpcB) * 1000 div qpcA);  //Ausgabe in ms
end;

{Lege die Dimension des Sudokus fest: zB 9x9}
procedure TSudoku.set_dim(a_dim: ShortInt);
var
  i: ShortInt;
begin
  block_dim := round(sqrt(dim));
  if (block_dim * block_dim) = dim then
  begin
    dim := a_dim;
    SetLength(spielfeld, dim);
    SetLength(loesung, dim);
    For i := 1 to dim do
    begin
      SetLength(spielfeld[i], dim);
      SetLength(loesung[i], dim);
    end;
  end else begin
    // ERROR: nicht-quadratische Sudokufelddimension
    Free;
  end;
end;

{Fülle ein Sudoku nach Standardschema =Vorlage für späteres Streichen)}
procedure TSudoku.normSudoku();
var
  i, j: ShortInt;
begin
  // Fülle ein Sudoku nach vorgegebenem Schema.
  // 1 2 3 4 5 6 7 8 9
  // 4 5 6 7 8 9 1 2 3
  // 7 8 9 1 2 3 4 5 6
  // 2 3 4 5 6 7 8 9 1
  // 5 6 7 8 9 1 2 3 4
  // 8 9 1 2 3 4 5 6 7
  // 3 4 5 6 7 8 9 1 2
  // 6 7 8 9 1 2 3 4 5
  // 9 1 2 3 4 5 6 7 8
  For i := 1 to dim do
  begin
    For j := 1 to dim do
    begin
      loesung[i,j] := (j + block_dim*(((i-1) mod block_dim)) +
        ((i+(block_dim-(i mod block_dim))) div block_dim) -1 )
        mod dim;
    end;
  end;
end;


{Ordne das standardmässig erstelltes Sudoku um}
procedure TSudoku.randomizeSudoku();
var
  a,b,q,
  zufall_block,
  zufall_a,
  zufall_b,
  TEMP_Wert
  : ShortInt;
begin
  Randomize;                  // Iniziere Zufallsgenerator
  For q := 1 to 32 Do         // Vertausche 32 mal
  begin
    {Es wird per Zufall ein Block ausgelesen}
    {Der ausgelesene Block (1/2/3) wird mit 3 multipliziert und um die
    erste Zeile zu erhalten wieder mit 1/2/3 subtrahiert}
    zufall_block := Round(Random(block_dim)+1);
    zufall_a := zufall_block * block_dim - Random(block_dim);
    zufall_b := zufall_block * block_dim - Random(block_dim);
    {Vertausche Zeilen pro 3 Blöcke miteinander}
    For b := 1 to dim Do
    begin
      TEMP_Wert := Loesung[zufall_a,b];
      Loesung[zufall_a,b] := Loesung[zufall_b,b];
      Loesung[zufall_b,b] := TEMP_Wert;
    end;
    {Vertausche Spalten pro 3 Blöcke miteinander}
    zufall_block := Round(Random(block_dim)+1);
    zufall_a := zufall_block * block_dim - Random(block_dim);
    zufall_b := zufall_block * block_dim - Random(block_dim);
    For b := 1 to dim Do
    begin
      TEMP_Wert := Loesung[b,zufall_a];
      Loesung[b,zufall_a] := Loesung[b,zufall_b];
      Loesung[b,zufall_a] := TEMP_Wert;
    end;
  {Diagonalenspiegelung}
  end;
    {Mache 50:50-Test ob über die Diagonale gespiegelt werden soll}
    If Random(10) < 4 then
    begin
      For a := 1 to dim Do  {Spiegle diagonal über die Achse von [1,1] nach [9,9]}
      begin
        For b := 1 to a Do
        begin
          {Tausche Arrayinhalte aus, oben links wird begonnen}
          TEMP_Wert := Loesung[a,b];                              // V | |
          Loesung[a,b] := Loesung[b,a];                           // * V |
          Loesung[b,a] := TEMP_Wert;                              // * * V
        end;
      end;
    end;
    {Mache 50:50-Test ob über die Diagonale gespiegelt werden soll}
    If Random(10) < 4 then
    begin
      For a := 1 to dim Do  {Spiegle diagonal über die Achse von [9,1] nach [1,9]}
      begin
        For b := 1 to a Do
        begin
          {Wandle so um, dass rechts oben beim Sudoku begonnen wird}
          TEMP_Wert := Loesung[dim+1-a,b];                        // | | V
          Loesung[dim+1-a,b] := Loesung[dim+1-b,a];               // | V *
          Loesung[dim+1-b,a] := TEMP_Wert;                        // V * *
        end;
      end;
    end;
end;


procedure TSudoku.minimizeSudoku();
begin
  XArray := TXAlgoArray.createXArray(4*dim*dim, dim*dim);


end;


//>--> Other Functions >--------------------------------------------------------

{Setze ein einzelnes Feld}
procedure TSudoku.setField(X, Y, Wert: ShortInt);
begin
  if (X <= dim) and (X <= dim) then
  begin
    Loesung[X,Y] := Wert;
  end else begin
    // ERROR invalid dimensions!
  end;
end;

{Lese ein einzelnes Feld aus}
function TSudoku.getField(X, Y: ShortInt): ShortInt;
begin
  if (X <= dim) and (X <= dim) then
  begin
    Result := Loesung[X,Y];
  end else begin
    // ERROR invalid dimensions!
  end;
end;

{Checke, ob das Spielfeld ein gültiges Sudoku darstellt}
function TSudoku.isCorrect(): Boolean;
begin
  Result := false;
end;

procedure TSudoku.reset(a_dim: ShortInt);
begin
  Self.Free;
  Self := TSudoku.createSudoku(a_dim);
end;

end.
