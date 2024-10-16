unit uProductController;

interface
Uses
    uProductModel, JSON, System.SysUtils, uProdutoItemModel, System.Generics.Collections, Vcl.Dialogs;
    Type
        TProdutoController = class
           private
               { private declarations }
               function TrocaVirgulaPPonto(Valor: string): String;
                procedure DeleteProvisorioByCliente(id: Integer);

           protected
               { protected declarations }
           public
               { public declarations }
               Procedure SaveProduct(objProduto : TProduto);
               Procedure DeleteProduct(Id : Integer);
               Function getProductByID(Id : Integer): TProduto;
               procedure SetComporVenda(jSon: String);
               procedure FechaPedido(jSon: String);
               Function DeleteProisorio(Id: Integer) : Boolean;
               Function getPedidoByID(Id: Integer): TObjectList<TProdutoItemModel>;
               procedure DeletePedido(Id: Integer);
           published
               { published declarations }
           end;

implementation
Uses
    DAOConection;

{ TProdutoController }

procedure TProdutoController.DeleteProduct(Id: Integer);
begin
    //
end;

procedure TProdutoController.DeletePedido(Id: Integer);
begin
    dtmGeral.ExecDeleteSql( 'Delete from tbl_wk_pedido where pedido_id = ' + IntToStr(Id) );
end;

Function TProdutoController.DeleteProisorio(Id: Integer) : Boolean;
begin
    Result := dtmGeral.ExecDeleteSql( 'Delete from tbl_wk_provisorio where produto_id = ' + IntToStr(Id) );
end;

Function TProdutoController.getProductByID(Id: Integer): TProduto;
Var
    vlProdutoModel : TProduto;
    JsonProduto : TJSONObject;
    vlJson: String;
Begin
    vlJson := dtmGeral.ExecSql( 'Select * from tbl_wk_produtos where codigo = ' + IntToStr(Id) );
    vlProdutoModel := TProduto.Create;

    If (vlJson <> '[]') Then
    Begin
        JsonProduto := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(vlJson), 0) As TJSONObject; //TJSONArray;

        vlProdutoModel.SetCodigo( JsonProduto.GetValue<Integer>('Codigo', 0) );
        vlProdutoModel.SetDescricao( JsonProduto.GetValue<String>('Descricao', '') );
        vlProdutoModel.SetQuantidade( JsonProduto.GetValue<Double>('Quantidade', 0) );
        vlProdutoModel.SetPreco( JsonProduto.GetValue<Double>('Preco', 0.00) );
    End;
    Result := vlProdutoModel;

End;

procedure TProdutoController.SaveProduct(objProduto: TProduto);
begin
    //
end;

procedure TProdutoController.SetComporVenda(jSon: String);
Var
  vlSql, vlDesc : String;
  JsonProduto : TJSONObject;
begin
    JsonProduto := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jSon), 0) As TJSONObject;
    vlSql := 'Select * from tbl_wk_provisorio Where produto_id = ' +
    JsonProduto.GetValue<Integer>('ProdutoId', 0).ToString + ' And cliente_id = ' +
    JsonProduto.GetValue<Integer>('Cliente', 0).ToString;

    If (dtmGeral.ExisteRegistro(vlSql)) Then
    Begin
        vlSql := 'Update tbl_wk_provisorio Set quantidade = ' +
                  TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('Quantidade', 0).ToString) +
                 ', valor_total = ' + TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('ValorTotal', 0).ToString) +
                 ' Where produto_id = ' +
                JsonProduto.GetValue<Integer>('ProdutoId', 0).ToString + ' And cliente_id = ' +
                JsonProduto.GetValue<Integer>('Cliente', 0).ToString;

        dtmGeral.InsertSql(vlSql);
    End Else Begin
        vlSql := 'Insert Into tbl_wk_provisorio ' +
            '(cliente_id, produto_id, descricao, quantidade, valor_unitario, valor_total) ' +
            'Values (' +
            JsonProduto.GetValue<Integer>('Cliente', 0).ToString + ', ' +
            JsonProduto.GetValue<Integer>('ProdutoId', 0).ToString + ', ' +
            QuotedStr( JsonProduto.GetValue<String>('Descricao', '') ) + ', ' +
            TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('Quantidade', 0).ToString) + ', ' +
            TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('PrecoUnitario', 0).ToString) + ', ' +
            TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('ValorTotal', 0).ToString) + ')';
        dtmGeral.InsertSql(vlSql);
    End;
end;

procedure TProdutoController.DeleteProvisorioByCliente(id: Integer);
Var
  vlSql, vlDesc : String;
begin

    vlSql := 'Delete from tbl_wk_provisorio where cliente_id = ' + IntToStr(id);
    dtmGeral.InsertSql(vlSql);

end;


procedure TProdutoController.FechaPedido(jSon: String);
Var
    vlJson : String;
begin
    vlJson := jSon;
    dtmGeral.InsertPedidoSql(jSon);
end;

function TProdutoController.TrocaVirgulaPPonto(Valor: string): String;
begin
  Result := trim(StringReplace(Valor,',','.',[rfReplaceall]));
end;


Function TProdutoController.getPedidoByID(Id: Integer): TObjectList<TProdutoItemModel>;
Var
    JsonPedido : TJSONObject;
    JsonArrayItem : TJSONArray;
    objProdutoItemModel : TProdutoItemModel;
    vlLista : TObjectList<TProdutoItemModel>;
    vlJson: String;
    vlCount, vlCodigo : Integer;
Begin
    vlJson := dtmGeral.getPedido( Id );


    If (vlJson <> '{}') Then
    Begin
        JsonPedido := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(vlJson), 0) As TJSONObject;

        vlLista := TObjectList<TProdutoItemModel>.Create;
        vlCodigo := JsonPedido.GetValue<Integer>('Pedido', 0);


        JsonArrayItem := JsonPedido.GetValue<TJSONArray>('ItensPedido');
        For vlCount := 0 To JsonArrayItem.Size -1 Do
        Begin
            objProdutoItemModel := TProdutoItemModel.Create;

            objProdutoItemModel.SetCodigoPedido( JsonArrayItem.Get(vlCount).GetValue<Integer>('PedidoId', 0) );
            objProdutoItemModel.SetCodigoCliente( JsonArrayItem.Get(vlCount).GetValue<Integer>('ClienteId', 0) );
            objProdutoItemModel.SetCodigoProduto( JsonArrayItem.Get(vlCount).GetValue<Integer>('ProdutoId', 0) );
            objProdutoItemModel.SetDescricao( JsonArrayItem.Get(vlCount).GetValue<String>('Descricao', '') );
            objProdutoItemModel.SetQuantidade( JsonArrayItem.Get(vlCount).GetValue<Double>('Qauntidade', 0) );
            objProdutoItemModel.SetPrecoUnitario( JsonArrayItem.Get(vlCount).GetValue<Double>('ValorUnitario', 0.00) );
            objProdutoItemModel.SetValorTotal( JsonArrayItem.Get(vlCount).GetValue<Double>('ValorTotal', 0.00) );
            vlLista.Add(objProdutoItemModel);
        End;

    End;
    Result := vlLista;

End;

end.
