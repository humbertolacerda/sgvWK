unit uProductModel;

interface
    type
    TProduto = class
    private
        FPreco      : Double;
        FDescricao  : String;
        FCodigo     : Integer;
        FQuantidade : Double;
        { private declarations }
    protected
       { protected declarations }
    public
       { public declarations }
        procedure SetCodigo(const Value: Integer);
        procedure SetDescricao(const Value: String);
        procedure SetPreco(const Value: Double);
        procedure SetQuantidade(const Value: Double);

        Function getCodigo : Integer;
        Function getDescricao : String;
        Function getPreco : Double;
        Function getQuantidade : Double;
    published
       { published declarations }
       property Codigo       : Integer read FCodigo write SetCodigo;
       property Descricao    : String read FDescricao write SetDescricao;
       property Quantidade   : Double read FQuantidade write SetQuantidade;
       property Preco        : Double read FPreco write SetPreco;
    end;

implementation



{ TProduto }

function TProduto.getCodigo: Integer;
begin
    Result := FCodigo;
end;

function TProduto.getDescricao: String;
begin
    Result := FDescricao;
end;

function TProduto.getPreco: Double;
begin
    Result := FPreco;
end;

function TProduto.getQuantidade: Double;
begin
    Result := FQuantidade;
end;

procedure TProduto.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TProduto.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TProduto.SetPreco(const Value: Double);
begin
  FPreco := Value;
end;

procedure TProduto.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
end;

end.
