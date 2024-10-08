unit uProductController;

interface
Uses
    uProductModel, JSON, System.SysUtils;
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

Function TProdutoController.getProductByID(Id: Integer): TProduto;
Var
    vlProdutoModel : TProduto;
    JsonProduto : TJSONObject;
    vlJson: String;
Begin
    vlJson := dtmGeral.ExecSql( 'Select * from public.tbl_wk_produtos where codigo = ' + IntToStr(Id) );
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

    vlSql := 'Insert Into public.tbl_wk_provisorio ' +
        '(cliente_id, produto_id, descricao, quantidade, valor_unitario, valor_total) ' +
        'Values (' +
        JsonProduto.GetValue<Integer>('Cliente', 0).ToString + ', ' +
        JsonProduto.GetValue<Integer>('ProdutoId', 0).ToString + ', ' +
        QuotedStr( JsonProduto.GetValue<String>('Descricao', '') ) + ', ' +
        TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('Quantidade', 0).ToString) + ', ' +
        TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('PrecoUnitario', 0).ToString) + ', ' +
        TrocaVirgulaPPonto(JsonProduto.GetValue<Double>('ValorTotal', 0).ToString) + ')';
    dtmGeral.InsertSql(vlSql);

end;

procedure TProdutoController.DeleteProvisorioByCliente(id: Integer);
Var
  vlSql, vlDesc : String;
begin

    vlSql := 'Delete from public.tbl_wk_provisorio where cliente_id = ' + IntToStr(id);
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

end.
