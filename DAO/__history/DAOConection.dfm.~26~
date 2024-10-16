object dtmGeral: TdtmGeral
  OnCreate = DataModuleCreate
  Height = 356
  Width = 525
  object fdConection: TFDConnection
    Params.Strings = (
      'Database=wk_tech'
      'User_Name=root'
      'Password=279468'
      'Server=localhost'
      'DriverID=MySQL')
    Left = 120
    Top = 24
  end
  object FDTransacao: TFDTransaction
    Connection = fdConection
    Left = 224
    Top = 40
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 360
    Top = 24
  end
  object fdQueryExecutaSql: TFDQuery
    Connection = fdConection
    Left = 104
    Top = 152
  end
  object fdpMySql: TFDPhysMySQLDriverLink
    VendorLib = 'C:\projects\Delphi\sgvWK\LIBMYSQL.DLL'
    Left = 296
    Top = 192
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 136
    Top = 232
  end
end
