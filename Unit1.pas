unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.MPlayer;

type
  TForm1 = class(TForm)
    Image1: TImage;
    PaintBox1: TPaintBox;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  color_pen,color_fon:tcolor;
  can,bck:tbitmap;
  click_left,click_right:boolean;
  w,h,mx,my,lx,ly,tx,ty,width_pen:integer;
  s:string;

implementation

{$R *.dfm}



procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
can.SaveToFile(ExtractFilePath(Application.ExeName)+'mybmp.bmp');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  w:=paintbox1.Width;
  h:=paintbox1.Height;

  can:=tbitmap.Create;
  can.Width:=w;
  can.Height:=h;

  bck:=tbitmap.Create;
  bck.Width:=w;
  bck.Height:=h;

  color_pen:=clSkyBlue;
  color_fon:=clwhite;

  can.Canvas.Brush.Color:=color_fon;
  can.Canvas.Pen.Color:=color_fon;
  can.Canvas.Rectangle(can.Canvas.ClipRect);

  can.Canvas.Font.Size:=24;

  width_pen:=5;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // key 90 "Z"
  if (ssCtrl in Shift)and(key=90) then
  begin
    can.Canvas.Draw(0,0,bck);
    paintbox1.Canvas.draw(0,0,can);
  end;


end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if s='' then bck.Canvas.Draw(0,0,can);
  if key>=#32 then
  begin
    s:=s+key;
    can.Canvas.Brush.Style:= bsClear;
    can.Canvas.Font.Color:=color_pen;
    can.Canvas.TextOut(tx,ty,s);
    paintbox1.Canvas.draw(0,0,can);
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

    if key=9 then begin
  bck.Canvas.Draw(0,0,can);
  color_fon:=clWhite;
  can.Canvas.Brush.Color:=color_fon;
  can.Canvas.Pen.Color:=color_fon;
  can.Canvas.Rectangle(can.Canvas.ClipRect);
  width_pen:=5;
  paintbox1.Canvas.draw(0,0,can);
  end;

  if key=27 then form1.Close;
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if width_pen>2 then width_pen:=width_pen-1;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if width_pen<30 then width_pen:=width_pen+1;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  w:=paintbox1.ClientWidth;
  h:=paintbox1.ClientHeight;
  can.Width:=w;
  can.Height:=h;
  bck.Width:=w;
  bck.Height:=h;
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  if ColorDialog1.Execute then color_pen:=ColorDialog1.Color;
  paintbox1.Canvas.draw(0,0,can);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then color_pen:=Form1.Canvas.Pixels[x,image1.Top+y];
  if Button=mbRight then color_fon:=Form1.Canvas.Pixels[x,image1.Top+y];
end;

procedure TForm1.PaintBox1Click(Sender: TObject);
begin
 if not click_left then bck.Canvas.Draw(0,0,can);
 can.Canvas.Pen.Color:=color_pen;
 can.Canvas.Brush.Color:=color_pen;
 can.Canvas.Ellipse(mx-width_pen,my-width_pen,mx+width_pen,my+width_pen);
 paintbox1.Canvas.draw(0,0,can);
end;

procedure TForm1.PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var c:tcolor;
begin
  bck.Canvas.Draw(0,0,can);
  c:=can.Canvas.Pixels[MousePos.x,MousePos.y];
  if c<>color_pen then begin
  can.canvas.Brush.Color:=color_pen;
  can.canvas.FloodFill(MousePos.x,MousePos.y,c,fsSurface);
  paintbox1.Canvas.draw(0,0,can);
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then
  begin
    if not click_left then bck.Canvas.Draw(0,0,can);
    click_left:=true;
  end;
  if button=mbRight then
  begin
    if not click_right then bck.Canvas.Draw(0,0,can);
    click_right:=true;
  end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  r:real;
begin
  mx:=x; my:=y;

  r:=Sqrt(sqr(mx-lx)+sqr(my-ly));

  if click_left then begin
    can.Canvas.Pen.Color:=color_pen;
    can.Canvas.Brush.Color:=color_pen;
    if r<width_pen then
    can.Canvas.Ellipse(mx-width_pen,my-width_pen,mx+width_pen,my+width_pen)
    else
    begin
     can.Canvas.Pen.Width:=width_pen+width_pen;
     can.Canvas.MoveTo(mx,my);
     can.Canvas.LineTo(lx,ly);
     can.Canvas.Pen.Width:=1;
    end;
  paintbox1.Canvas.draw(0,0,can);
  end;

if r>abs(2) then begin if s<>'' then s:=''; tx:=mx; ty:=my; end;

lx:=mx; ly:=my;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button=mbLeft then click_left:=false;
if button=mbRight then click_right:=false;

if button=mbMiddle then color_pen:=can.Canvas.Pixels[x,y];

end;

end.
