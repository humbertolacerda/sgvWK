unit DAOConection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.Dialogs, Vcl.Forms, Messages, FireDAC.Comp.DataSet, IniFiles, JSON,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Comp.UI;

type
  TdtmGeral = class(TDataModule)
    fdConection: TFDConnection;
    FDTransacao: TFDTransaction;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    fdQueryExecutaSql: TFDQuery;
    fdpMySql: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Function FuncGetJson(): String;
    Function TrocaVirgulaPPonto(Valor: string): String;
  public
    { Public declarations }
    Function ExecSql(vlSql: String): String;
    Procedure InsertSql(vlSql: String);
    Procedure InsertPedidoSql(jSon: String);
    Function ExecDeleteSql(vlSql: String): Boolean;
    Function ExisteRegistro(vlSql: String): Boolean;
    Function getPedido(Id : Integer) : String;
  end;

var
  dtmGeral: TdtmGeral; vpSql: String;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Function TdtmGeral.ExecSql(vlSql: String): String;
Begin
    vpSql := UpperCase( vlSql );
    Try
        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql);
        fdQueryExecutaSql.Open;

        If (fdQueryExecutaSql.IsEmpty) Then
            Result := '[]'
        Else Begin
            Result := FuncGetJson();
        End;
        fdQueryExecutaSql.Close;
    Except
    End;
End;

Function TdtmGeral.ExisteRegistro(vlSql: String): Boolean;
Begin
    Try
        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql);
        fdQueryExecutaSql.Open;

        If (fdQueryExecutaSql.IsEmpty) Then
            Result := False
        Else Begin
            Result := True;
        End;
        fdQueryExecutaSql.Close;
    Except
    End;
End;

Function TdtmGeral.ExecDeleteSql(vlSql: String): Boolean;
Begin
    Try
        fdConection.StartTransaction;
        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql);
        fdQueryExecutaSql.ExecSQL();
        fdConection.Commit;
        Result := True;
    Except
        On vlErro : EFDDBEngineException Do
        Begin
            fdConection.Rollback;
            ShowMessage( 'Aten��o! N�o foi poss�vel excluir o registro: ' + vlErro.Message );
            Result := False;
        End;
    End;

End;

Procedure TdtmGeral.InsertPedidoSql(jSon: String);
Var
    vlSql : TStringList;
    JsonPedido : TJSONObject;
    JsonArrayItem : TJSONArray;
    vlNumPedido, vlCount : Integer;
Begin
    Try
        fdConection.StartTransaction;
        JsonPedido := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jSon), 0) As TJSONObject;
        vlSql := TStringList.Create;
        vlSql.Clear;
        vlSql.Add('Insert Into tbl_wk_pedido ');
        vlSql.Add('(cliente_id, data_emissao, valor_total) ');
        vlSql.Add('Values (');
        vlSql.Add(JsonPedido.GetValue<Integer>('Cliente', 0).ToString + ', ');
        vlSql.Add(QuotedStr(JsonPedido.GetValue<String>('Emissao', '')) + ', ');
        vlSql.Add( TrocaVirgulaPPonto( JsonPedido.GetValue<Double>('ValorTotal', 0).ToString ) + ')');

        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql.Text);
        fdQueryExecutaSql.ExecSQL;

        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add('Select Max(pedido_id) as Id from tbl_wk_pedido where cliente_id = ' + JsonPedido.GetValue<Integer>('Cliente', 0).ToString);
        fdQueryExecutaSql.Open;
        vlNumPedido := fdQueryExecutaSql.FieldByName('id').AsInteger;

        JsonArrayItem := JsonPedido.GetValue<TJSONArray>('ItensPedido');
        For vlCount := 0 To JsonArrayItem.Size -1 Do
        Begin
            vlSql.Clear;
            vlSql.Add('Update tbl_wk_produtos Set quantidade = quantidade - ' + JsonArrayItem.Get(vlCount).GetValue<Integer>('Qauntidade', 0).ToString);
            vlSql.Add('Where codigo = ' + JsonArrayItem.Get(vlCount).GetValue<Integer>('ProdutoId', 0).ToString);
            fdQueryExecutaSql.SQL.Clear;
            fdQueryExecutaSql.SQL.Add(vlSql.Text);
            fdQueryExecutaSql.ExecSQL;

            vlSql.Clear;
            vlSql.Add('Insert Into tbl_wk_itens_pedido ');
            vlSql.Add('(pedido_id, produto_id, quantidade, valor_unitario, valor_total) ');
            vlSql.Add('Values (');
            vlSql.Add(vlNumPedido.ToString + ', ');
            vlSql.Add(JsonArrayItem.Get(vlCount).GetValue<Integer>('ProdutoId', 0).ToString + ', ');
            vlSql.Add(JsonArrayItem.Get(vlCount).GetValue<Integer>('Qauntidade', 0).ToString + ', ');
            vlSql.Add( TrocaVirgulaPPonto( JsonArrayItem.Get(vlCount).GetValue<Double>('ValorUnitario', 0).ToString ) + ', ');
            vlSql.Add( TrocaVirgulaPPonto( JsonArrayItem.Get(vlCount).GetValue<Double>('ValorTotal', 0).ToString ) + ')');
            fdQueryExecutaSql.SQL.Clear;
            fdQueryExecutaSql.SQL.Add(vlSql.Text);
            fdQueryExecutaSql.ExecSQL;
        End;

        fdConection.Commit;
    Except
        On vlErro : EFDDBEngineException Do
        Begin
            fdConection.Rollback;
            ShowMessage( vlErro.Message );
        End;
    End;

End;

Procedure TdtmGeral.InsertSql(vlSql: String);
Begin
    vpSql := UpperCase( vlSql );
    Try
        fdConection.StartTransaction;
        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql);
        fdQueryExecutaSql.ExecSQL;
        fdConection.Commit;
    Except
        fdConection.Rollback;
    End;

End;

procedure TdtmGeral.DataModuleCreate(Sender: TObject);
Var
    FileConfig: TIniFile;
    IniFileName: String;
begin
    IniFileName := ChangeFileExt( Application.ExeName, '.ini' );
    FileConfig := TIniFile.Create( IniFileName );


    If (not fileExists(IniFileName)  ) Then
    Begin

        ShowMessage('Arquivo de configura��o ausente, contate a WK Solution');
        Application.Terminate;

    End Else Begin
        Try
            With fdConection Do
            Begin
                Params.Values['DriverID']   := FileConfig.ReadString('MYSQL', 'DriverID', '');
                Params.Values['Port']       := FileConfig.ReadString('MYSQL', 'Port', '');
                Params.Values['Database']   := FileConfig.ReadString('MYSQL', 'Database', '');
                Params.Values['User_Name']  := FileConfig.ReadString('MYSQL', 'User_Name', '');
                Params.Values['Password']   := FileConfig.ReadString('MYSQL', 'Password', '');
                Params.Values['Server']     := FileConfig.ReadString('MYSQL', 'Server', '');
                fdpMySql.VendorLib := ExtractFilePath(Application.ExeName) + FileConfig.ReadString('MYSQL', 'PathLib', '');
                Open;
            End;
        Except On E: Exception do
            ShowMessage('Erro: ' + E.Message );
    End;
    FileConfig.Free;

    End;
end;

Function TdtmGeral.FuncGetJson(): String;
Var
    vlResult, vlJson : String;
    JsonArray, ArrayItem : TJSONObject; // TJsonArray;
    vlExistString : Boolean;

Begin

    JsonArray := TJSONObject.Create;
    If (vpSql.Contains('TBL_WK_CLIENTES') ) Then
    Begin

        With fdQueryExecutaSql Do
        Begin
            JsonArray.AddPair('Codgo', TJSONNumber.Create(FieldByName('CODIGO').AsInteger) );
            JsonArray.AddPair('Nome', FieldByName('NOME').AsString );
            JsonArray.AddPair('Cidade', FieldByName('CIDADE').AsString );
            JsonArray.AddPair('UF', FieldByName('UF').AsString );
        End;
    End Else If (vpSql.Contains('TBL_WK_PRODUTOS')) Then
    Begin
        With fdQueryExecutaSql Do
        Begin
            JsonArray.AddPair('Codigo', TJSONNumber.Create(FieldByName('CODIGO').AsInteger) );
            JsonArray.AddPair('Descricao', FieldByName('DESCRICAO').AsString );
            JsonArray.AddPair('Preco', TJSONNumber.Create(FieldByName('PRECO_VENDA').AsFloat) );
            JsonArray.AddPair('Quantidade', TJSONNumber.Create(FieldByName('QUANTIDADE').AsFloat) );
        End;

    End;
    Result := JsonArray.ToString;


End;

Function TdtmGeral.TrocaVirgulaPPonto(Valor: string): String;
begin
  Result := trim(StringReplace(Valor,',','.',[rfReplaceall]));
end;


Function TdtmGeral.getPedido(Id : Integer) : String;
Var
    JsonArrayItem : TJSONArray;
    JsonPedido, JSonObjItem:  TJSONObject;
    vlNumPedido, vlCount : Integer;
    vlSql: TStringList;
Begin

    vlSql := TStringList.Create;
    vlSql.Add( 'Select ped.cliente_id, item.id, item.pedido_id, item.produto_id, prod.descricao, ');
    vlSql.Add( 'item.quantidade, item.valor_unitario, item.valor_total ');
    vlSql.Add( 'from wk_tech.tbl_wk_pedido ped ');
    vlSql.Add( 'inner join wk_tech.tbl_wk_itens_pedido item ON ped.pedido_id = item.pedido_id ');
    vlSql.Add( 'inner join wk_tech.tbl_wk_produtos prod ON item.produto_id = prod.codigo ');
    vlSql.Add( 'where ped.pedido_id = ' + IntToStr(Id) );

    Try

        With fdQueryExecutaSql Do
        Begin
            SQL.Clear;
            SQL.Add(vlSql.Text);
            Open;
            First;

            JsonPedido := TJSONObject.Create;
            JsonPedido.AddPair('Cliente', TJSONNumber.Create( FieldByName('cliente_id').AsInteger ) );
            JsonPedido.AddPair('Pedido', TJSONNumber.Create( FieldByName('pedido_id').AsInteger) );

            JsonArrayItem := TJSONArray.Create;
            While Not Eof Do
            Begin
               JSonObjItem := TJSONObject.Create;
               JSonObjItem.AddPair('PedidoId', TJSONNumber.Create( FieldByName('pedido_id').AsInteger ) );
               JSonObjItem.AddPair('ClienteId', TJSONNumber.Create( FieldByName('cliente_id').AsInteger) );
               JSonObjItem.AddPair('ProdutoId', TJSONNumber.Create( FieldByName('produto_id').AsInteger) );
               JSonObjItem.AddPair('Descricao', FieldByName('descricao').AsString );
               JSonObjItem.AddPair('Qauntidade', TJSONNumber.Create( FieldByName('quantidade').AsInteger) );
               JSonObjItem.AddPair('ValorUnitario', TJSONNumber.Create( FieldByName('valor_unitario').AsFloat) );
               JSonObjItem.AddPair('ValorTotal', TJSONNumber.Create( FieldByName('valor_total').AsFloat) );

               JsonArrayItem.Add(JSonObjItem);
               Next;
            End;
            JsonPedido.AddPair('ItensPedido', JsonArrayItem);
        End;
        Result := JsonPedido.ToString;

    Except
        On vlErro : EFDDBEngineException Do
        Begin
            Result := '{}';
        End;
    End;

End;


end.
