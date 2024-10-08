unit uClientModel;

interface
    type
    TCliente = class
               private
                  { private declarations }
                  FUF: String;
                  FCodigo: Integer;
                  FNome: String;
                  FCidade: String;
               protected
                 { protected declarations }
               public
                 { public declarations }

                  procedure SetCidade(const Value: String);
                  procedure SetCodigo(const Value: Integer);
                  procedure SetNome(const Value: String);
                  procedure SetUF(const Value: String);
                 
                  Function getCidade : String;
                  Function getCodigo : Integer;
                  Function getNome   : String;
                  Function getUF     : String;
               published
                 { published declarations }
                  property Codigo : Integer read FCodigo write SetCodigo;
                  property Nome   : String read FNome write SetNome;
                  property Cidade : String read FCidade write SetCidade;
                  property UF     : String read FUF write SetUF;
               end;


implementation

{ TCliente }

function TCliente.getCidade: String;
begin
    Result := FCidade;
end;

function TCliente.getCodigo: Integer;
begin
    Result := FCodigo;
end;

function TCliente.getNome: String;
begin
    Result := FNome;
end;

function TCliente.getUF: String;
begin
    Result := FUF;
end;

procedure TCliente.SetCidade(const Value: String);
begin
  FCidade := Value;
end;

procedure TCliente.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCliente.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TCliente.SetUF(const Value: String);
begin
  FUF := Value;
end;



end.
