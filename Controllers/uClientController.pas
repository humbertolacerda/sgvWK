unit uClientController;

interface
Uses
    uClientModel, System.SysUtils, Vcl.ExtCtrls, System.Classes, System.Json.Types, System.JSON.Writers, JSON;

    Type
        ClientController = class
         private
           { private declarations }
           function TrocaVirgulaPPonto(Valor: string): String;
         protected
           { protected declarations }
         public
           { public declarations }
           procedure SetUF(const Value: String);

           Procedure SaveClient(cliente : TCliente);
           Procedure DeleteClient(Id : Integer);
           Function getClientID(Id : Integer): TCliente;
           procedure DeleteProvisorioByCliente(id: Integer);
           //Function getAllClient(): TList;

         published
           { published declarations }
         end;
implementation
Uses
    DAOConection;
{ ClientController }

procedure ClientController.DeleteClient(Id: Integer);
begin
    //
end;

function ClientController.getClientID(Id: Integer): TCliente;
Var
    vlJsonClient : String;
    vlClienteModel : TCliente;
    JsonCliente : TJSONObject; //TJsonArray;
    vlJson: String;
Begin
    vlJson := dtmGeral.ExecSql( 'Select * from tbl_wk_clientes where codigo = ' + IntToStr(Id) );
    vlClienteModel := TCliente.Create;

    If (vlJson <> '[]') Then
    Begin
        JsonCliente := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(vlJson), 0) As TJSONObject; //TJSONArray;

        vlClienteModel.SetCodigo( JsonCliente.GetValue<Integer>('Codigo', 0) );
        vlClienteModel.SetNome( JsonCliente.GetValue<String>('Nome', '') );
        vlClienteModel.SetCidade( JsonCliente.GetValue<String>('Cidade', '') );
        vlClienteModel.SetUF( JsonCliente.GetValue<String>('UF', '') );
    End;
    Result := vlClienteModel;


    //    Cliente : TList;
    //    Cliente := TList.Create;
end;

procedure ClientController.SaveClient(cliente: TCliente);
begin

end;

procedure ClientController.SetUF(const Value: String);
begin

end;

procedure ClientController.DeleteProvisorioByCliente(id: Integer);
Var
  vlSql, vlDesc : String;
begin

    vlSql := 'Delete from tbl_wk_provisorio where cliente_id = ' + IntToStr(id);
    dtmGeral.InsertSql(vlSql);

end;


function ClientController.TrocaVirgulaPPonto(Valor: string): String;
begin
  Result := trim(StringReplace(Valor,',','.',[rfReplaceall]));
end;

end.
