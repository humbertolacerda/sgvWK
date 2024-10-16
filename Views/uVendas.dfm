object frmVendas: TfrmVendas
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Vendas ao Cliente'
  ClientHeight = 778
  ClientWidth = 1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 730
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      474
      730)
    object Label1: TLabel
      Left = 24
      Top = 48
      Width = 120
      Height = 21
      Caption = 'Informe o Cliente'
    end
    object lblCidadeCliente: TLabel
      Left = 24
      Top = 107
      Width = 48
      Height = 21
      Caption = 'Cidade'
    end
    object lblUFCliente: TLabel
      Left = 442
      Top = 107
      Width = 19
      Height = 21
      Caption = 'UF'
    end
    object Label2: TLabel
      Left = 24
      Top = 155
      Width = 128
      Height = 21
      Caption = 'Informe o Produto'
    end
    object Label3: TLabel
      Left = 24
      Top = 227
      Width = 81
      Height = 21
      Caption = 'Quantidade'
    end
    object Label4: TLabel
      Left = 131
      Top = 227
      Width = 96
      Height = 21
      Caption = 'Valor Unit'#225'rio'
    end
    object Label5: TLabel
      Left = 307
      Top = 227
      Width = 72
      Height = 21
      Caption = 'Valor Total'
    end
    object edtClientID: TEdit
      Left = 24
      Top = 72
      Width = 49
      Height = 29
      TabOrder = 0
      OnExit = edtClientIDExit
      OnKeyPress = edtClientIDKeyPress
    end
    object edtClientName: TEdit
      Left = 77
      Top = 72
      Width = 389
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      Color = clGrayText
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object edtProductID: TEdit
      Left = 24
      Top = 182
      Width = 49
      Height = 29
      MaxLength = 4
      TabOrder = 2
      OnExit = edtProductIDExit
      OnKeyPress = edtClientIDKeyPress
    end
    object edtProductName: TEdit
      Left = 77
      Top = 182
      Width = 389
      Height = 29
      Color = clGrayText
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object edtQuant: TEdit
      Left = 24
      Top = 248
      Width = 81
      Height = 29
      MaxLength = 12
      TabOrder = 4
      OnExit = edtQuantExit
      OnKeyPress = edtClientIDKeyPress
    end
    object edtValorUnit: TEdit
      Left = 111
      Top = 248
      Width = 178
      Height = 29
      Alignment = taRightJustify
      Color = clGrayText
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnKeyPress = edtClientIDKeyPress
    end
    object edtValorTotal: TEdit
      Left = 305
      Top = 248
      Width = 161
      Height = 29
      Alignment = taRightJustify
      Color = clGrayText
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
  end
  object pnMiddle: TPanel
    Left = 480
    Top = 0
    Width = 619
    Height = 730
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object pnRodape: TPanel
      Left = 1
      Top = 650
      Width = 617
      Height = 79
      Align = alBottom
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 1
      object pnValorTotal: TPanel
        AlignWithMargins = True
        Left = 358
        Top = 3
        Width = 245
        Height = 69
        Margins.Left = 10
        Margins.Right = 10
        Align = alRight
        Alignment = taRightJustify
        BevelOuter = bvNone
        BiDiMode = bdRightToLeftNoAlign
        Caption = '0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object dbgVendas: TDBGrid
      AlignWithMargins = True
      Left = 11
      Top = 67
      Width = 597
      Height = 573
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      DataSource = dtsVendas
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDrawColumnCell = dbgVendasDrawColumnCell
      OnKeyDown = dbgVendasKeyDown
      OnKeyPress = dbgVendasKeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'produto_id'
          Title.Caption = 'Produto'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao'
          Title.Caption = 'Descri'#231#227'o do Produto'
          Width = 266
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantidade'
          Title.Caption = 'Quantidade'
          Width = 72
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_unitario'
          Title.Caption = 'Valor Unit'#225'rio'
          Width = 78
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_total'
          Title.Caption = 'Valor Total'
          Width = 92
          Visible = True
        end>
    end
    object dbNavVendas: TDBNavigator
      Left = 1
      Top = 1
      Width = 617
      Height = 56
      DataSource = dtsVendas
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbEdit, nbPost, nbCancel]
      Align = alTop
      TabOrder = 2
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 730
    Width = 1099
    Height = 48
    Align = alBottom
    TabOrder = 2
    object btnCancelPedido: TBitBtn
      Left = 211
      Top = 1
      Width = 198
      Height = 46
      Align = alLeft
      Caption = 'F3 - &Cancelar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelPedidoClick
    end
    object btnFecharPedido: TBitBtn
      Left = 1
      Top = 1
      Width = 200
      Height = 46
      Align = alLeft
      Caption = 'F2 - &Fechar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnFecharPedidoClick
    end
    object Panel2: TPanel
      Left = 409
      Top = 1
      Width = 10
      Height = 46
      Align = alLeft
      Alignment = taLeftJustify
      TabOrder = 2
    end
    object btnBuscarPedido: TBitBtn
      Left = 623
      Top = 1
      Width = 194
      Height = 46
      Align = alLeft
      Caption = 'F5 - &Buscar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnBuscarPedidoClick
    end
    object Panel1: TPanel
      Left = 201
      Top = 1
      Width = 10
      Height = 46
      Align = alLeft
      Alignment = taLeftJustify
      TabOrder = 4
    end
    object btnExcluir: TBitBtn
      Left = 419
      Top = 1
      Width = 194
      Height = 46
      Align = alLeft
      Caption = 'F4 - &Excluir Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnExcluirClick
    end
    object Panel3: TPanel
      Left = 613
      Top = 1
      Width = 10
      Height = 46
      Align = alLeft
      Alignment = taLeftJustify
      TabOrder = 6
    end
  end
  object fdqVendas: TFDQuery
    Connection = dtmGeral.fdConection
    SQL.Strings = (
      'SELECT id, cliente_id, produto_id, descricao, quantidade, '
      'valor_unitario, valor_total'
      'FROM tbl_wk_provisorio'
      'Where cliente_id = 0')
    Left = 576
    Top = 249
    object fdqVendasid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object fdqVendascliente_id: TIntegerField
      FieldName = 'cliente_id'
      Origin = 'cliente_id'
      Required = True
    end
    object fdqVendasproduto_id: TIntegerField
      FieldName = 'produto_id'
      Origin = 'produto_id'
      Required = True
    end
    object fdqVendasdescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 120
    end
    object fdqVendasquantidade: TBCDField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Required = True
      Precision = 12
      Size = 3
    end
    object fdqVendasvalor_unitario: TBCDField
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
      Required = True
      DisplayFormat = '#,###0.00'
      Precision = 12
      Size = 2
    end
    object fdqVendasvalor_total: TBCDField
      FieldName = 'valor_total'
      Origin = 'valor_total'
      Required = True
      DisplayFormat = '#,###0.00'
      Precision = 12
      Size = 2
    end
  end
  object dtsVendas: TDataSource
    AutoEdit = False
    DataSet = fdqVendas
    Left = 720
    Top = 240
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 824
    Top = 248
  end
end
