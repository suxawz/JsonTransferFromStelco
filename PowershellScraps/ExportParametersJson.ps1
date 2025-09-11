$server = "LVLMSPRDSQL1"
$database = "meltshopStelco"
$username = "meltshop365"
$password = "meltshoP365!"
$currentTime = (Get-Date)
$query = "  SELECT [BOFModelParameterID]
      ,[PlantID]
      ,[UNITGROUP_NO]
      ,[PNAME]
      ,[PRAC_NO]
      ,[TYPE]
      ,[UNIT]
      ,[VALUE]
      ,[INST_ACTV]
      ,[DIALOG_PARAM]
      ,[CONV]
      ,[MIN_VALUE]
      ,[MAX_VALUE]
      ,[PARAM_DESCR]
      ,[PARAM_DESCR_C]
      ,[PARAM_GROUP]
      ,FORMAT(ModificationTime, 'yyyy-MM-dd HH:mm:ss') as ModificationTime
      ,[ModifiedBy]
      ,FORMAT(StartTime, 'yyyy-MM-dd HH:mm:ss') as StartTime
      ,FORMAT(EndTime, 'yyyy-MM-dd HH:mm:ss') as EndTime
      ,[ParameterGroup]
  FROM [meltshopStelco].[dbo].[tblBOFModelParameters] order by BOFModelParameterID  "
$connectionString = "Server=$server;Database=$database;User ID=$username;Password=$password;"
 
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$command = $connection.CreateCommand()
$command.CommandText = $query
$connection.Open()
$result = $command.ExecuteReader()
$jsonResult = New-Object System.Collections.ArrayList

while ($result.Read()) {
	#echo $result.FieldCount
    $row = @{}
    for ($i = 0; $i -lt $result.FieldCount; $i++) {
        #$row[$result.GetName($i)] = $result.GetValue($i) | Out-Null
		$row.Add($result.GetName($i),$result.GetValue($i))
		#echo $result.GetValue($i)
		#echo $row
    }
    $jsonResult.Add($row) | Out-Null
}
$result.Close()
$connection.Close()
$endDay = $currentTime.ToString("yyyy-MM-dd")
$filePathDay = "tblBOFModelParameters"+$endDay
$jsonContent = $jsonResult | ConvertTo-Json -Depth 100

$jsonContent | Out-File -FilePath "C:\Users\XST4758\Desktop\AutoExportJsonFile\$filePathDay.json" -Encoding UTF8