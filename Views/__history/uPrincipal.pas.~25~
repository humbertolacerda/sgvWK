unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus;

type
  TfrmPrincipal = class(TForm)
    mmPrincipal: TMainMenu;
    Cadastro1: TMenuItem;
    Clientes1: TMenuItem;
    Produtos1: TMenuItem;
    Produtos2: TMenuItem;
    Fornecedores1: TMenuItem;
    Fornecedores2: TMenuItem;
    Sair1: TMenuItem;
    sbPrincipal: TStatusBar;
    tmPrincipal: TTimer;
    Movimentao1: TMenuItem;
    Vendas1: TMenuItem;
    ToolBar1: TToolBar;
    spbSair: TSpeedButton;
    spbEstoque: TSpeedButton;
    spbClientes: TSpeedButton;
    ToolButton2: TToolButton;
    spbFornecedores: TSpeedButton;
    spbPedidos: TSpeedButton;
    ToolButton1: TToolButton;
    spbNotas: TSpeedButton;
    procedure Sair1Click(Sender: TObject);
    procedure tmPrincipalTimer(Sender: TObject);
    procedure Vendas1Click(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure spbPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
  Uses
    uVendas;
{$R *.dfm}

procedure TfrmPrincipal.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.spbPedidosClick(Sender: TObject);
begin
  Vendas1Click(Sender);
end;

procedure TfrmPrincipal.spbSairClick(Sender: TObject);
begin
  Sair1Click(Sender);
end;

procedure TfrmPrincipal.tmPrincipalTimer(Sender: TObject);
var
  KS : TkeyboardState;
begin
  GetKeyboardState(KS);

  sbPrincipal.Panels[0].Text := FormatDateTime('dd/MM/yyyy', Now);
  sbPrincipal.Panels[1].Text := FormatDateTime('HH:MM:SS', Now);

  If Odd( Ks[VK_CAPITAL]) then
     sbPrincipal.Panels[2].text := 'CAPS'
  Else
     sbPrincipal.Panels[2].text := '';

  If Odd( Ks[VK_INSERT]) then
     sbPrincipal.Panels[3].text := 'INS'
  else
     sbPrincipal.Panels[3].text := '';

  If Odd( Ks[VK_NUMLOCK]) then
     sbPrincipal.Panels[4].text := 'NLock'
  else
     sbPrincipal.Panels[4].text := '';


  sbPrincipal.Panels[7].text :=   Application.Hint;


end;

procedure TfrmPrincipal.Vendas1Click(Sender: TObject);
begin
  If (frmVendas = nil) Then
  Begin
    frmVendas := TfrmVendas.Create(Self);
  End;
  frmVendas.Show();

end;

end.
