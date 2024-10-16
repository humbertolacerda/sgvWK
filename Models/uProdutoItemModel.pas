unit uProdutoItemModel;

interface
    type
    TProdutoItemModel = class
    private
        FCodigoPedido   : Integer;
        FCodigoCliente  : Integer;
        FCodigoProduto  : Integer;
        FDescricao      : String;
        FQuantidade     : Double;
        FPrecoUnitario  : Double;
        FValorTotal     : Double;
        { private declarations }
    protected
       { protected declarations }
    public
       { public declarations }
        procedure SetCodigoPedido(const Value: Integer);
        procedure SetCodigoCliente(const Value: Integer);
        procedure SetCodigoProduto(const Value: Integer);
        procedure SetDescricao(const Value: String);
        procedure SetQuantidade(const Value: Double);
        procedure SetPrecoUnitario(const Value: Double);
        procedure SetValorTotal(const Value: Double);

        Function getCodigoPedido : Integer;
        Function getCodigoCliente : Integer;
        Function getCodigoProduto : Integer;
        Function getDescricao : String;
        Function getQuantidade :Double;
        Function getPrecoUnitario : Double;
        Function getValorTotal : Double;
    published
       { published declarations }
       property CodigoPedido        : Integer read FCodigoPedido write SetCodigoPedido;
       property CodigoCliente       : Integer read FCodigoCliente write SetCodigoCliente;
       property CodigoProduto       : Integer read FCodigoProduto write SetCodigoProduto;
       property Descricao           : String read FDescricao write SetDescricao;
       property Quantidade          : Double read FQuantidade write SetQuantidade;
       property PrecoUnitario       : Double read FPrecoUnitario write SetPrecoUnitario;
       property ValorTotal          : Double read FValorTotal write SetValorTotal;

    end;


implementation

{ TProdutoItemModel }

Function TProdutoItemModel.getCodigoCliente: Integer;
Begin
    Result := FCodigoCliente;
End;

Function TProdutoItemModel.getCodigoPedido: Integer;
Begin
    Result := FCodigoPedido;
End;

Function TProdutoItemModel.getCodigoProduto: Integer;
Begin
    Result := FCodigoProduto;
End;

Function TProdutoItemModel.getDescricao: String;
Begin
    Result := FDescricao;
End;

Function TProdutoItemModel.getPrecoUnitario: Double;
Begin
    Result := FPrecoUnitario;
End;

Function TProdutoItemModel.getQuantidade: Double;
Begin
    Result := FQuantidade;
End;

Function TProdutoItemModel.getValorTotal: Double;
Begin
    Result := FValorTotal;
End;

procedure TProdutoItemModel.SetCodigoCliente(const Value: Integer);
begin
    FCodigoCliente := Value;
end;

procedure TProdutoItemModel.SetCodigoPedido(const Value: Integer);
begin
    FCodigoPedido := Value;
end;

procedure TProdutoItemModel.SetCodigoProduto(const Value: Integer);
begin
    FCodigoProduto := Value;
end;

procedure TProdutoItemModel.SetDescricao(const Value: String);
begin
    FDescricao := Value;
end;

procedure TProdutoItemModel.SetPrecoUnitario(const Value: Double);
begin
    FPrecoUnitario := Value;
end;

procedure TProdutoItemModel.SetQuantidade(const Value: Double);
begin
    FQuantidade := Value;
end;

procedure TProdutoItemModel.SetValorTotal(const Value: Double);
begin
    FValorTotal := Value;
end;

end.
