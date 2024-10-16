unit uVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  uProductModel, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls, JSON,
  EMS.ResourceAPI, System.Generics.Collections, EMS.DataSetResource,
  uProductController, uProdutoItemModel;

type
  TfrmVendas = class(TForm)
    pnTop: TPanel;
    pnMiddle: TPanel;
    pnBottom: TPanel;
    btnCancelPedido: TBitBtn;
    fdqVendas: TFDQuery;
    Label1: TLabel;
    edtClientID: TEdit;
    edtClientName: TEdit;
    lblCidadeCliente: TLabel;
    lblUFCliente: TLabel;
    edtProductID: TEdit;
    edtProductName: TEdit;
    Label2: TLabel;
    edtQuant: TEdit;
    edtValorUnit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtValorTotal: TEdit;
    Label5: TLabel;
    pnRodape: TPanel;
    dbgVendas: TDBGrid;
    dtsVendas: TDataSource;
    dbNavVendas: TDBNavigator;
    pnValorTotal: TPanel;
    btnFecharPedido: TBitBtn;
    Panel2: TPanel;
    fdqVendasid: TFDAutoIncField;
    fdqVendascliente_id: TIntegerField;
    fdqVendasproduto_id: TIntegerField;
    fdqVendasdescricao: TStringField;
    fdqVendasquantidade: TBCDField;
    fdqVendasvalor_unitario: TBCDField;
    fdqVendasvalor_total: TBCDField;
    btnBuscarPedido: TBitBtn;
    Panel1: TPanel;
    btnExcluir: TBitBtn;
    Panel3: TPanel;
    Timer1: TTimer;
    procedure btnCancelPedidoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtClientIDKeyPress(Sender: TObject; var Key: Char);
    procedure edtProductIDExit(Sender: TObject);
    procedure edtClientIDExit(Sender: TObject);
    procedure edtQuantExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFecharPedidoClick(Sender: TObject);
    procedure dbgVendasKeyPress(Sender: TObject; var Key: Char);
    procedure dbgVendasDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgVendasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FProdutoModel: TProduto;
    FPreco: Double;
    FQuantidade: Double;
    function TrocaVirgulaPPonto(Valor: string): String;
    Function IsOnlyNumber(const vlResposta: string): Boolean;
  public
    { Public declarations }
  end;


var
  frmVendas: TfrmVendas;
  vpProdutoModel : TProduto;
  vlProductController : TProdutoController;
  vpNumeroPedido : Integer;


implementation
Uses
    uClientController, DAOConection, uClientModel;
{$R *.dfm}

Function  SomenteNumeros(Key: Char; Texto: string; EhDecimal: Boolean = False): Char;
Var
    DecimalSeparator: Char;

begin
    DecimalSeparator := '.';
    if  not EhDecimal then
    begin

      { Chr(8) = Back Space }

      if  not ( Key in ['0'..'9', Chr(8)] ) then

          Key := #0

    end  else begin

      if  Key = #46 then
          Key := DecimalSeparator;
      if  not ( Key in ['0'..'9', Chr(8), DecimalSeparator] ) then
          Key := #0
      else
        if  ( Key = DecimalSeparator ) and ( Pos( Key, Texto ) > 0 ) then
            Key := #0;
    end;
    Result := Key;
end;

Function TfrmVendas.IsOnlyNumber(const vlResposta: string): Boolean;
Begin
    Try
        StrToInt(vlResposta);
        Result := True;
    Except
        Result := False;
    End;
End;

procedure TfrmVendas.btnCancelPedidoClick(Sender: TObject);
Var
  vlClientController : ClientController;
begin
    If (edtClientID.Text <> '') Then
    Begin
        vlClientController.DeleteProvisorioByCliente(StrToInt(edtClientID.Text) );
        fdqVendas.Close;
    End;
    Close;
end;

procedure TfrmVendas.btnFecharPedidoClick(Sender: TObject);
Var
    vlQuant, vlTotal, vlSoma : Double;
    JsonPedido, JSonObjItemVenda : TJSONObject;
    JsonItens : TJSONArray;
    vlTexto : String;
    vlPos : Integer;
begin
     vlTexto := pnValorTotal.Caption;
     vlPos := Pos('.', vlTexto)-1;
     vlTexto := vlTexto.Remove(vlPos, 1);
     vlTotal := StrToFloat( vlTexto );
     Try
         JsonPedido := TJSONObject.Create;
         JsonPedido.AddPair('Cliente', TJSONNumber.Create( StrToInt(edtClientID.Text) ) );
         JsonPedido.AddPair('Emissao', FormatDateTime('yyyy-MM-dd', Date) );
         JsonPedido.AddPair('ValorTotal', TJSONNumber.Create( vlTotal ));

         JsonItens := TJSONArray.Create;
         fdqVendas.First;
         While Not fdqVendas.Eof Do
         Begin
            JSonObjItemVenda := TJSONObject.Create;
            JSonObjItemVenda.AddPair('PedidoId', TJSONNumber.Create(0) );
            JSonObjItemVenda.AddPair('ProdutoId', TJSONNumber.Create(fdqVendas.FieldByName('produto_id').AsInteger) );
            JSonObjItemVenda.AddPair('Qauntidade', TJSONNumber.Create(fdqVendas.FieldByName('quantidade').AsInteger) );
            JSonObjItemVenda.AddPair('ValorUnitario', TJSONNumber.Create(fdqVendas.FieldByName('valor_unitario').AsFloat) );
            JSonObjItemVenda.AddPair('ValorTotal', TJSONNumber.Create(fdqVendas.FieldByName('valor_total').AsFloat) );
            JsonItens.Add(JSonObjItemVenda);
            fdqVendas.Next;
         End;
         JsonPedido.AddPair('ItensPedido', JsonItens);
         vlProductController.FechaPedido(JsonPedido.ToString);
         JsonPedido.free;
         Close;
     Except
        vlProductController.Free;
     End;
     vlProductController.Free;
end;

procedure TfrmVendas.dbgVendasDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    If State = [] then
    Begin
        If fdqVendas.RecNo mod 2 = 1 then
            dbgVendas.Canvas.Brush.Color := clAqua
        Else
            dbgVendas.Canvas.Brush.Color := clWhite;
    End;
    dbgVendas.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmVendas.dbgVendasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
    vlQuant, vlTotal, vlSoma : Double;
    vlTexto : String;
    vlPos : Integer;
begin

    If (Key = VK_DELETE) Then
    Begin
        If (MessageDlg('Confirma a remo��o deste produto no pedido?',mtConfirmation,[mbYes,mbNo],0) = mrYes) Then
        Begin
            vlProductController := TProdutoController.Create();
            If vlProductController.DeleteProisorio( dbgVendas.Fields[0].AsInteger) Then
            Begin
                fdqVendas.Refresh;
                vlTotal := 0;
                fdqVendas.First;
                While (Not fdqVendas.Eof) Do
                Begin
                    vlTotal := vlTotal + fdqVendas.FieldByName('valor_total').AsFloat;
                    fdqVendas.Next;
                End;
                fdqVendas.First;
                pnValorTotal.Caption := FormatFloat(',0.00', vlTotal);
            End;
            vlProductController.Free;
        End;
    End;
end;

procedure TfrmVendas.dbgVendasKeyPress(Sender: TObject; var Key: Char);
begin
    If (Key = #13) Then
    Begin
       edtProductID.Text := dbgVendas.Fields[0].AsString;
       edtProductID.ReadOnly := True;
       edtProductID.SetFocus;
    End;
end;

procedure TfrmVendas.edtClientIDExit(Sender: TObject);
Var
  vlSql : String;
  vlClienteModel : TCliente;
  vlClientController : ClientController;
begin
    //Verificar o cliente
    If (edtClientID.Text <> '') Then
    Begin
        edtClientName.Clear;
        lblCidadeCliente.Caption := '';
        lblUFCliente.Caption := '';

        vlClienteModel := TCliente.Create();
        vlClientController := ClientController.Create();
        vlClienteModel := vlClientController.getClientID(StrToInt( edtClientID.Text) );
        vlClientController.Free;

        edtClientName.Text := vlClienteModel.getNome;
        lblCidadeCliente.Caption := vlClienteModel.getCidade;
        lblUFCliente.Caption := vlClienteModel.getUF;
        If (edtClientName.Text = '') Then
        Begin
            ShowMessage('Cliente n�o encontrado.');
            edtClientID.SetFocus;
        End Else Begin
            vlClientController.DeleteProvisorioByCliente(StrToInt(edtClientID.Text) );

            fdqVendas.Close;
            fdqVendas.SQL.Clear;
            fdqVendas.SQL.Add('SELECT id, cliente_id, produto_id, descricao, quantidade, valor_unitario, valor_total ');
	        fdqVendas.SQL.Add('FROM tbl_wk_provisorio ');
        	fdqVendas.SQL.Add('Where cliente_id = ' + edtClientID.Text);
            fdqVendas.Open;
            fdqVendas.Refresh;
        End;
    End;

end;

procedure TfrmVendas.edtClientIDKeyPress(Sender: TObject; var Key: Char);
begin
    Key := SomenteNumeros( Key, TEdit(Sender).Text );
end;

procedure TfrmVendas.edtProductIDExit(Sender: TObject);
Var
    vlQuant, vlValorUnit, vlTotal : Double;
begin
   If (edtProductID.Text <> '') Then
    Begin
        edtProductName.Clear;
        edtQuant.Text := '0';
        edtValorUnit.Text := '0.00';
        edtValorTotal.Text := '0.00';

        vpProdutoModel := TProduto.Create();
        vlProductController := TProdutoController.Create();
        vpProdutoModel := vlProductController.getProductByID(StrToInt( edtProductID.Text) );

        edtProductName.Text := vpProdutoModel.getDescricao;
        vlValorUnit := StrToFloat(StringReplace(edtValorUnit.Text, '.', ',', [rfReplaceAll]));
        vlTotal := StrToFloat(StringReplace(edtValorUnit.Text, '.', ',', [rfReplaceAll]));

        edtValorUnit.Text := FormatFloat(',0.00', vpProdutoModel.getPreco);

        If (edtProductName.Text = '') Then
        Begin
            ShowMessage('Produto n�o encontrado.');
            edtProductID.SetFocus;
        End;
        vlProductController.Free;
    End;
end;

procedure TfrmVendas.edtQuantExit(Sender: TObject);
Var
    vlQuant, vlTotal, vlSoma : Double;
    vlResposta, vlPos : Integer;
    Json : TJSONObject;
    vlTexto : String;
begin
    If (edtQuant.Text = '') Then
        edtQuant.Text := '0';


    vlQuant := StrToFloat(StringReplace(edtQuant.Text, '.', ',', [rfReplaceAll]));

    If (vlQuant > 0) Then
    Begin
        edtValorTotal.Text := FormatFloat(',0.00', vpProdutoModel.getPreco * vlQuant);

        If (vlQuant > vpProdutoModel.getQuantidade) Then
        Begin
           ShowMessage('Aten��o! N�o � permitido vendas com quantidade superior ao estoque.');
           edtProductID.SetFocus;
        End Else
        Begin
            vlResposta := MessageDlg('Confirma a inser��o deste produto?', mtInformation, [mbYes, mbNo, mbCancel], 0);
            If (vlResposta  = mrYes) Then
            Begin
                vlProductController := TProdutoController.Create();

                vlTotal := (vlQuant * vpProdutoModel.getPreco);
                Json := TJSONObject.Create;
                Json.AddPair('Cliente', edtClientID.Text );
                Json.AddPair('ProdutoId', edtProductID.Text );
                Json.AddPair('Descricao', edtProductName.Text );
                Json.AddPair('Quantidade', TJSONNumber.Create(vlQuant) );
                Json.AddPair('PrecoUnitario', TJSONNumber.Create( vpProdutoModel.getPreco ) );
                Json.AddPair('ValorTotal', TJSONNumber.Create( vlTotal ));
                vlProductController.setComporVenda( jSon.ToString );
                vlProductController.Free;
                Json.Free;
                fdqVendas.Refresh;

                edtProductID.Clear;
                edtProductName.Clear;
                edtQuant.Text := '0';
                edtValorUnit.Text := FormatFloat(',0.00', 0);
                edtValorTotal.Text := FormatFloat(',0.00', 0);

                If (pnValorTotal.Caption <> '0,00' ) Then
                Begin
                    vlTexto := pnValorTotal.Caption;
                    vlPos := Pos('.', vlTexto)-1;
                    vlTexto := vlTexto.Remove(vlPos, 1);
                    vlSoma := StrToFloat( vlTexto ) + vlTotal;
                End Else Begin
                    vlSoma := vlTotal;
                End;
                pnValorTotal.Caption := FormatFloat(',0.00', vlSoma);

                edtProductID.SetFocus;
            End Else If(vlResposta  = mrNo) Then
            Begin
                edtProductID.SetFocus;
            End Else If(vlResposta  = mrCancel) Then
            Begin
                edtProductID.Clear;
                edtProductName.Clear;
                edtQuant.Text := '0';
                edtValorUnit.Text := FormatFloat(',0.00', 0);
                edtValorTotal.Text := FormatFloat(',0.00', 0);
                edtProductID.SetFocus;
            End;

        End;

    End;
end;

procedure TfrmVendas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  frmVendas := Nil;
end;

procedure TfrmVendas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then
        btnFecharPedidoClick(Sender);

    If Key = VK_F3 Then
        btnCancelPedidoClick(Sender);

    If Key = VK_F4 Then
        btnExcluirClick(Sender);

    If Key = VK_F5 Then
        btnBuscarPedidoClick(Sender);
end;

procedure TfrmVendas.FormShow(Sender: TObject);
begin
    lblCidadeCliente.Caption := '';
    lblUFCliente.Caption := '';
    fdqVendas.Open();
    vpNumeroPedido := 0;
end;

procedure TfrmVendas.Timer1Timer(Sender: TObject);
begin
    If (vpNumeroPedido > 0) Then
        btnExcluir.Enabled := True
    Else
        btnExcluir.Enabled := False;

end;

function TfrmVendas.TrocaVirgulaPPonto(Valor: string): String;
begin
  Result := trim(StringReplace(Valor,',','.',[rfReplaceall]));
end;

procedure TfrmVendas.btnBuscarPedidoClick(Sender: TObject);
Var
    vlresposta : String;
    vlLista : TObjectList<TProdutoItemModel>;
    vlCount : Integer;
    Json : TJSONObject;
    vlTexto : String;
    vlSoma: Double;
begin
    InputQuery('SGV - WK','Informe o c�digo do pedido:',vlResposta);
    If (vlResposta <> '') Then
    Begin
        If IsOnlyNumber(vlResposta) Then
        Begin
            vlProductController := TProdutoController.Create();
            vlLista := vlProductController.getPedidoByID( StrToInt(vlResposta) );
            fdqVendas.Open;

            If (vlLista.Count > 0 ) Then
            Begin
                edtClientID.Text := vlLista[0].getCodigoCliente.ToString;
                edtClientIDExit(Sender);
                edtProductID.SetFocus;
                vpNumeroPedido := vlLista[0].getCodigoPedido;

                For vlCount := 0 To vlLista.Count -1  Do
                Begin

                    vlProductController := TProdutoController.Create();
                    Json := TJSONObject.Create;
                    Json.AddPair('Cliente', vlLista[vlCount].getCodigoCliente );
                    Json.AddPair('ProdutoId', vlLista[vlCount].getCodigoProduto );
                    Json.AddPair('Descricao', vlLista[vlCount].getDescricao );
                    Json.AddPair('Quantidade', TJSONNumber.Create(vlLista[vlCount].getQuantidade) );
                    Json.AddPair('PrecoUnitario', TJSONNumber.Create( vlLista[vlCount].getPrecoUnitario ) );
                    Json.AddPair('ValorTotal', TJSONNumber.Create( vlLista[vlCount].getValorTotal ));
                    vlProductController.setComporVenda( jSon.ToString );
                    vlProductController.Free;
                    vlSoma := vlSoma + vlLista[vlCount].getValorTotal;
                    Json.Free;
                    fdqVendas.Refresh;
                End;
                pnValorTotal.Caption := FormatFloat(',0.00', vlSoma);

            End;

        End Else Begin
            ShowMessage('Por favor. Tente novamente digitando somente n�meros');
        End;

    End;
end;

procedure TfrmVendas.btnExcluirClick(Sender: TObject);
Var
  vlSql, ClienteId : String;
  vlClienteModel : TCliente;
  vlClientController : ClientController;
  vlResposta : Integer;
begin
    If (vpNumeroPedido > 0) Then
    Begin
        vlResposta := MessageDlg('Confirma a confirma a exclus�o deste pedido', mtConfirmation, [mbYes, mbNo], 0);

        If (vlResposta = mrYes) Then
        Begin
            vlProductController := TProdutoController.Create();
            vlProductController.DeletePedido( vpNumeroPedido );
            vlClientController := ClientController.Create();

            edtClientName.Clear;
            lblCidadeCliente.Caption := '';
            lblUFCliente.Caption := '';
            vlClientController.DeleteProvisorioByCliente(StrToInt(edtClientID.Text) );
            edtClientID.Clear;
            pnValorTotal.Caption := FormatFloat(',0.00', 0);
            fdqVendas.Close;
            vlClientController.Free;
            fdqVendas.Open;
            ShowMessage('Pedido N� (' + IntToStr(vpNumeroPedido) + ') exclu�do com sucesso.' );
            vpNumeroPedido := -1;
        End;

    End;
end;

end.
