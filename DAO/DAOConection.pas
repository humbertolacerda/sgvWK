unit DAOConection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.Dialogs, Vcl.Forms, Messages, FireDAC.Comp.DataSet, IniFiles, JSON;

type
  TdtmGeral = class(TDataModule)
    fdConection: TFDConnection;
    FDTransacao: TFDTransaction;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    fdQueryExecutaSql: TFDQuery;
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
        vlSql.Add('Insert Into public.tbl_wk_pedido ');
        vlSql.Add('(cliente_id, data_emissao, valor_total) ');
        vlSql.Add('Values (');
        vlSql.Add(JsonPedido.GetValue<Integer>('Cliente', 0).ToString + ', ');
        vlSql.Add(QuotedStr(JsonPedido.GetValue<String>('Emissao', '')) + ', ');
        vlSql.Add( TrocaVirgulaPPonto( JsonPedido.GetValue<Double>('ValorTotal', 0).ToString ) + ')');

        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add(vlSql.Text);
        fdQueryExecutaSql.ExecSQL;

        fdQueryExecutaSql.SQL.Clear;
        fdQueryExecutaSql.SQL.Add('Select Max(id) as Id from public.tbl_wk_pedido where cliente_id = ' + JsonPedido.GetValue<Integer>('Cliente', 0).ToString);
        fdQueryExecutaSql.Open;
        vlNumPedido := fdQueryExecutaSql.FieldByName('id').AsInteger;

        JsonArrayItem := JsonPedido.GetValue<TJSONArray>('ItensPedido');
        For vlCount := 0 To JsonArrayItem.Size -1 Do
        Begin
            vlSql.Clear;
            vlSql.Add('Update public.tbl_wk_produtos Set quantidade = quantidade - ' + JsonArrayItem.Get(vlCount).GetValue<Integer>('Qauntidade', 0).ToString);
            vlSql.Add('Where codigo = ' + JsonArrayItem.Get(vlCount).GetValue<Integer>('ProdutoId', 0).ToString);
            fdQueryExecutaSql.SQL.Clear;
            fdQueryExecutaSql.SQL.Add(vlSql.Text);
            fdQueryExecutaSql.ExecSQL;

            vlSql.Clear;
            vlSql.Add('Insert Into public.tbl_wk_itens_pedido ');
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
        fdConection.Rollback;
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

        ShowMessage('Arquivo de configuração ausente, contate a WK Solution');
        Application.Terminate;

    End Else Begin
        Try
            fdConection.Params.Values['DriverName'] := FileConfig.ReadString('PG', 'DriverName', 'PG');
            fdConection.Params.Values['HostName']   := FileConfig.ReadString('PG', 'Port', '5432');
            fdConection.Params.Values['Database']   := FileConfig.ReadString('PG', 'Database', 'wk_tech');
            fdConection.Params.Values['User_Name']  := FileConfig.ReadString('PG', 'User_Name', 'postgres');
            fdConection.Params.Values['Password']   := FileConfig.ReadString('PG', 'Password', '279468');
            fdConection.Params.Values['Server']     := FileConfig.ReadString('PG', 'Server', 'localhost');
            fdConection.Open;
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
            JsonArray.AddPair('Codgo', TJSONNumber.Create(FieldByName('ID').AsInteger) );
            JsonArray.AddPair('Nome', FieldByName('Nome').AsString );
            JsonArray.AddPair('Cidade', FieldByName('Cidade').AsString );
            JsonArray.AddPair('UF', FieldByName('UF').AsString );
        End;
    End Else If (vpSql.Contains('TBL_WK_PRODUTOS')) Then
    Begin
        With fdQueryExecutaSql Do
        Begin
            JsonArray.AddPair('Codigo', TJSONNumber.Create(FieldByName('Codigo').AsInteger) );
            JsonArray.AddPair('Descricao', FieldByName('Descricao').AsString );
            JsonArray.AddPair('Preco', TJSONNumber.Create(FieldByName('Preco').AsFloat) );
            JsonArray.AddPair('Quantidade', TJSONNumber.Create(FieldByName('Quantidade').AsFloat) );
        End;

    End;
    Result := JsonArray.ToString;


End;

Function TdtmGeral.TrocaVirgulaPPonto(Valor: string): String;
begin
  Result := trim(StringReplace(Valor,',','.',[rfReplaceall]));
end;


end.
