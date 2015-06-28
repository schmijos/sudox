// SudoX: geschrieben von Josua Schmid

program sudoq;

uses
  Forms,
  main_script in 'main_script.pas' {main_form},
  infobox in 'infobox.pas' {InfoBox_form},
  optionen in 'optionen.pas' {Optionen_form},
  sudoku in 'sudoku.pas',
  DLX in 'DLX.pas',
  XAlgorithm in 'XAlgorithm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SudoX';
  Application.CreateForm(Tmain_form, main_form);
  Application.CreateForm(TInfoBox_form, InfoBox_form);
  Application.CreateForm(TOptionen_form, Optionen_form);
  Application.Run;
end.
