object dtmGeral: TdtmGeral
  OnCreate = DataModuleCreate
  Height = 356
  Width = 525
  object fdConection: TFDConnection
    Params.Strings = (
      'Database=wk_tech'
      'User_Name=postgres'
      'Server=localhost'
      'DriverID=PG')
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
end
