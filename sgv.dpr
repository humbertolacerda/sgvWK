program sgv;

uses
  Vcl.Forms,
  uPrincipal in 'Views\uPrincipal.pas' {frmPrincipal},
  uVendas in 'Views\uVendas.pas' {frmVendas},
  uClientModel in 'Models\uClientModel.pas',
  uProductModel in 'Models\uProductModel.pas',
  uClientController in 'Controllers\uClientController.pas',
  DAOConection in 'DAO\DAOConection.pas' {dtmGeral: TDataModule},
  uProductController in 'Controllers\uProductController.pas',
  uProdutoItemModel in 'Models\uProdutoItemModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdtmGeral, dtmGeral);
  Application.Run;
end.
