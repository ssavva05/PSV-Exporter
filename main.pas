unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, filedrag, ComCtrls, Menus, PSVClass, ToolWin,
  ImgList, BrowseForFolderU;

  var
  psvFile : TPSVFile;
  initialSaveDir : string;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    FileDrag1: TFileDrag;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenPSVfile1: TMenuItem;
    Extractfile1: TMenuItem;
    ExtractAllFiles1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    btnLoadFile: TToolButton;
    btnSaveFile: TToolButton;
    btnExtractAll: TToolButton;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    ExtractFile2: TMenuItem;
    ExtractAll1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ToolButton4: TToolButton;
    btnSavePS1: TToolButton;
    ExtractPS1Save1: TMenuItem;
    ExtractPS1Save2: TMenuItem;
    SaveDialog2: TSaveDialog;
    Options1: TMenuItem;
    procedure FileDrag1Drop(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure OpenPSVfile1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Extractfile1Click(Sender: TObject);
    procedure ExtractFile;
    procedure ExtractAll;
    procedure ExtractAllFiles1Click(Sender: TObject);
    procedure btnExtractAllClick(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSaveFileClick(Sender: TObject);
    procedure loadFile;
    procedure ExtractFile2Click(Sender: TObject);
    procedure ExtractAll1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    Procedure ClearDisplay;
    procedure FormShow(Sender: TObject);
    procedure showAbout;
    procedure About1Click(Sender: TObject);
    procedure ExtractPS1;
    procedure ExtractPS1Save2Click(Sender: TObject);
    procedure btnSavePS1Click(Sender: TObject);
    procedure ExtractPS1Save1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure showoptions;
    procedure SaveDialog2TypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses PSVFormat, about, options;

{$R *.dfm}

procedure TForm1.About1Click(Sender: TObject);
begin
  showAbout;
end;

procedure TForm1.ClearDisplay;
begin
  ListView1.Clear;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.ExtractAll;
var
  location : string;
begin
  if ListView1.Items.Count > 0  then begin
    location := '';
    location := BrowseforFolder('Choose location to save to..', initialSaveDir, True);
    if location <> '' then begin
      if PSVFile.extractAllFiles(location) then begin
        statusbar1.SimpleText := 'Extraction complete';
      end else begin
      statusbar1.SimpleText := 'Extraction cancelled';
      end;
    end else begin
      statusbar1.SimpleText := 'Extraction cancelled';
    end;
  end else begin
    statusbar1.SimpleText := 'Nothing to Extract!';
  end;
end;

procedure TForm1.ExtractAll1Click(Sender: TObject);
begin
  ExtractAll;
end;

procedure TForm1.ExtractAllFiles1Click(Sender: TObject);
begin
  ExtractAll;
end;

procedure TForm1.ExtractFile;
var
anItem : TlistItem;
begin
  if ListView1.SelCount > 0 then begin
    anItem := listView1.Selected;
    saveDialog1.FileName := PSVFile.CleanFileName(anItem.Caption);
    if saveDialog1.Execute then begin
      if PSVFile.extractAFile(anItem.Index, saveDialog1.FileName) then begin
        StatusBar1.SimpleText := 'File saved';
      end else begin
        StatusBar1.SimpleText := 'Extraction aborted';
      end;
    end;
  end else begin
    StatusBar1.SimpleText := 'No file selected to extract';
  end;
end;

procedure TForm1.Extractfile1Click(Sender: TObject);
Begin
  ExtractFile;
end;

procedure TForm1.ExtractFile2Click(Sender: TObject);
begin
  ExtractFile;
end;

procedure TForm1.ExtractPS1;
begin
  saveDialog2.FileName := '*.mcs';
  saveDialog2.DefaultExt := 'mcs';
  saveDialog2.FilterIndex := 1;
  if SaveDialog2.Execute then begin
     if PSVFile.extractPS1Save(saveDialog2.FileName) then begin
      StatusBar1.SimpleText := 'File saved';
     end else begin
      StatusBar1.SimpleText := 'Extraction aborted';
     end;
  end;
end;

procedure TForm1.ExtractPS1Save1Click(Sender: TObject);
begin
  ExtractPS1
end;

procedure TForm1.ExtractPS1Save2Click(Sender: TObject);
begin
  ExtractPS1
end;

procedure TForm1.FileDrag1Drop(Sender: TObject);
begin
  clearDisplay;
  if not PSVFile.loadFile(FileDrag1.Files.Strings[0]) then begin
      showmessage('Error loading file');
      StatusBar1.SimpleText := 'Error loading file!';
      PSVFile.Clear;
    end else begin
      StatusBar1.SimpleText := ExtractFileName(FileDrag1.Files.Strings[0]) + ' Loaded';
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PSVFile := TPSVFile.Create;
  UseLatestCommonDialogs := True;
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PSVFile.Destroy;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
if paramcount > 0 then begin
    if ExtractFileExt(lowercase(paramstr(1))) = '.psv' then begin
      if not PSVFile.loadFile(paramstr(1)) then begin
        showmessage('Error loading file');
        StatusBar1.SimpleText := 'Error loading file!';
        PSVFile.Clear;
      end else begin
      StatusBar1.SimpleText := ExtractFileName(paramstr(1)) + ' Loaded';
      end;
    end else begin
      StatusBar1.SimpleText := 'File not loaded!';
    end;
  end;
end;

procedure TForm1.loadFile;
begin
  if OpenDialog1.Execute then begin
    clearDisplay;
    if not PSVFile.loadFile(openDialog1.FileName) then begin
      showmessage('Error loading file');
      StatusBar1.SimpleText := 'Error loading file!';
      PSVFile.Clear;
    end else begin
      StatusBar1.SimpleText := ExtractFileName(openDialog1.FileName) + ' Loaded';
    end;
  end else begin
    StatusBar1.SimpleText := 'Load cancelled';
  end;
end;

procedure TForm1.OpenPSVfile1Click(Sender: TObject);
begin
  LoadFile;
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
  showOptions;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  //No items!
  if ListView1.Items.Count > 0 then begin
    popupMenu1.Items[0].Enabled := True;
    popupMenu1.Items[1].Enabled := True;
  end else begin
    popupMenu1.Items[0].Enabled := False;
    popupMenu1.Items[1].Enabled := False;
  end;

  //No item selected
  if ListView1.SelCount > 0 then begin
    popupMenu1.Items[0].Enabled := True;
  end else begin
    popupMenu1.Items[0].Enabled := False;
  end;
end;



procedure TForm1.SaveDialog2TypeChange(Sender: TObject);
begin
  if SaveDialog2.FilterIndex = 1 then begin
    SaveDialog2.DefaultExt := 'mcs';
  end;
  if SaveDialog2.FilterIndex = 2 then begin
    SaveDialog2.DefaultExt := '';
  end;
end;

procedure TForm1.showAbout;
begin
  AboutBox.ShowModal;
end;

procedure TForm1.showoptions;
var
  optionMenu : TOptionsForm;
begin
  optionMenu := TOptionsForm.Create(Form1);
  optionMenu.ShowModal;
  optionMenu.Free;
end;

procedure TForm1.btnLoadFileClick(Sender: TObject);
begin
  LoadFile;
end;

procedure TForm1.btnSaveFileClick(Sender: TObject);
begin
  ExtractFile;
end;

procedure TForm1.btnSavePS1Click(Sender: TObject);
begin
  ExtractPS1
end;


procedure TForm1.btnExtractAllClick(Sender: TObject);
begin
  ExtractAll;
end;

end.
