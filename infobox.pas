// AboutBox-Code für SudoX: geschrieben von Josua Schmid

unit infobox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TInfoBox_form = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    InfoBoxTimer1: TTimer;
    InfoBoxTimer2: TTimer;
    procedure InfoBoxTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InfoBoxTimer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  InfoBox_form: TInfoBox_form;

implementation

{$R *.dfm}

{Timer1 für AlphaBlend-Steuerung beim Auftauchen}
procedure TInfoBox_form.InfoBoxTimer1Timer(Sender: TObject);
begin
  InfoBox_form.AlphaBlendValue := InfoBox_form.AlphaBlendValue + 1;
  if InfoBox_form.AlphaBlendValue = 200 then
  begin
    InfoBoxTimer1.Enabled := FALSE;
  end;
end;

{Timer1 wird aktiviert, sobald das InfoBox-Formular gezeigt werden soll}
procedure TInfoBox_form.FormShow(Sender: TObject);
begin
  InfoBoxTimer1.Enabled := TRUE;
end;

{Timer2 für AlphaBlend-Steuerung beim Verschwinden}
procedure TInfoBox_form.InfoBoxTimer2Timer(Sender: TObject);
begin
  InfoBox_form.AlphaBlendValue := InfoBox_form.AlphaBlendValue - 1;
  if InfoBox_form.AlphaBlendValue = 0 then
  begin
    InfoBoxTimer2.Enabled := FALSE;
    InfoBox_form.Close;
  end;
end;

{Sobald auf das Formular geklickt wird, so wird der Timer2 aktiviert,
sofern der Timer1 nicht noch am Laufen ist}
procedure TInfoBox_form.FormClick(Sender: TObject);
begin
  if InfoBox_form.AlphaBlendValue >= 200 then
  begin
    InfoBoxTimer2.Enabled := TRUE;
  end;
end;

{Hier werden diverse Dinge beim erschaffen des Formulars geregelt}
procedure TInfoBox_form.FormCreate(Sender: TObject);
var
  i: ShortInt;
  TempLabel: TLabel;
begin
  InfoBox_form.Left := (Screen.Width div 2) - (InfoBox_form.Width div 2);
  InfoBox_form.Top := (Screen.Height div 2) - (InfoBox_form.Height div 2);
  {Die OnClick-Ereignisse werden für die 7 Labels definiert(war zu faul, es
  von Hand zu machen =) }
  For i := 1 to 7 do
  begin
    TempLabel := TLabel(Findcomponent('Label' + IntToStr(i)));
    TempLabel.OnClick := FormClick;
  end;
end;


end.
