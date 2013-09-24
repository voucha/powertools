unit Settings;

interface

type
  TMySQLSetting = packed record
    Hostname: string;
    Database: string;
    Username: string;
    Password: string;
    Port: Integer;
  end;

  TPostgreSQLSetting = packed record
    Hostname: string;
    Database: string;
    Username: string;
    Password: string;
    Port: Integer;
  end;

  IDatabaseSettingDialog = interface

  end;

procedure SetDefaultMySQLSetting(var Value: TMySQLSetting);
procedure SetDefaultPostgreSQLSetting(var Value: TPostgreSQLSetting);

implementation

procedure SetDefaultMySQLSetting(var Value: TMySQLSetting);
begin
  Value.Hostname:='localhost';
  Value.Database:='database';
  Value.Username:='root';
  Value.Password:='';
  Value.Port:=3306;
end;

procedure SetDefaultPostgreSQLSetting(var Value: TPostgreSQLSetting);
begin
  Value.Hostname:='localhost';
  Value.Database:='database';
  Value.Username:='postgres';
  Value.Password:='';
  Value.Port:=5432;
end;

end.
