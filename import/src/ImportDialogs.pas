unit ImportDialogs;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Settings;

function ShowSelectDatasource(ParentHandle: HWND; var SelectedIndex:
  Integer):Boolean;

function ShowSettingMySQL(ParentHandle: HWND;
  var MySQLSetting:TMySQLSetting):Boolean;
function ShowSettingPostgreSQL(ParentHandle: HWND;
  var PgSQLSetting:TPostgreSQLSetting):Boolean;

implementation

uses
  FormSelectDatasource, FormSettingMySQL, FormSettingPostgreSQL;

function ShowSelectDatasource(ParentHandle: HWND; var SelectedIndex:
  Integer):Boolean;
var
  F: TFrmSelectDataSource;
  Executed: Boolean;  
begin
  Executed:=False;
  SelectedIndex:=-1;
  F:=TFrmSelectDataSource.CreateParented(ParentHandle);
  try
    F.setSelectedIndex(0);
    if F.ShowModal = mrOK then
    begin    
      SelectedIndex:=F.getSelectedIndex;
      Executed:=True;
    end;
  finally
    FreeAndNil(F);
    Result:=Executed;
  end;
end;

function ShowSettingMySQL(ParentHandle: HWND; var MySQLSetting: TMySQLSetting):Boolean;
var
  F: TFrmSettingMySQL;
  Executed: Boolean;  
begin
  Executed:=False;
  F:=TFrmSettingMySQL.CreateParented(ParentHandle);
  try
    F.setSetting(MySQLSetting);
    if F.ShowModal = mrOK then
    begin
      F.getSetting(MySQLSetting);
      Executed:=True;
    end;
  finally
    FreeAndNil(F);
    Result:=Executed;
  end;
end;

function ShowSettingPostgreSQL(ParentHandle: HWND; var
  PgSQLSetting:TPostgreSQLSetting):Boolean;
var
  F: TFrmSettingPostgreSQL;
  Executed: Boolean;
begin
  Executed:=False;
  F:=TFrmSettingPostgreSQL.CreateParented(ParentHandle);
  try
    F.setSetting(PgSQLSetting);
    if F.ShowModal = mrOK then
    begin
      F.getSetting(PgSQLSetting);
      Executed:=True;
    end;
  finally
    FreeAndNil(F);
    Result:=Executed;
  end;
end;

end.
