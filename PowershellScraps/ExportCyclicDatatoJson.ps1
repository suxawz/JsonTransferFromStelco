
$server = "LVLMSPRDSQL1"
$database = "meltshopStelco"
$username = "meltshop365"
$password = "meltshoP365!"
$currentTime = (Get-Date)
$PreviousTime = $currentTime.AddDays(-1)
$query = "select FORMAT(T.TimestampLocal, 'yyyy-MM-dd HH:mm:ss') as TimestampLocal,max(T.[BOF1.OFFGAS.Flow]) as BOF1OFFGASFlow ,max(T.[BOF2.OFFGAS.Flow]) as BOF2OFFGASFlow,max(T.[BOF2.OFFGAS.Temp]) as BOF2OFFGASTemp,max(T.[BOF1.OFFGAS.Temp]) as BOF1OFFGASTemp ,max(T.[BOF1.OFFGAS.CO2]) as BOF1OFFGASCO2, max(T.[BOF2.OFFGAS.CO2]) as BOF2OFFGASCO2,max(T.[BOF1.OFFGAS.CO]) as BOF1OFFGASCO,max(T.[BOF2.OFFGAS.CO]) as BOF2OFFGASCO,max(T.[BOF1.OFFGAS.O2]) as BOF1OFFGASO2,max(T.[BOF2.OFFGAS.O2]) as BOF2OFFGASO2 from (SELECT DATEADD(SECOND, DATEDIFF(SECOND, '19700101', TimestampLocal) / 10 * 10, '19700101') AS  TimestampLocal,[BOF2.OFFGAS.Flow] ,[BOF1.OFFGAS.Flow],[BOF2.OFFGAS.Temp],[BOF1.OFFGAS.Temp],[BOF1.OFFGAS.CO2],[BOF2.OFFGAS.CO2],[BOF1.OFFGAS.CO],[BOF2.OFFGAS.CO],[BOF1.OFFGAS.O2],[BOF2.OFFGAS.O2] FROM (SELECT [Path],[Value],FORMAT(TimestampLocal, 'yyyy-MM-dd HH:mm:ss') as TimestampLocal,[VariableID] FROM [meltshopStelco].[dbo].[vwVariableTrends] where Value is not null and ( Path like 'BOF1.OFFGAS%' or Path like 'BOF2.OFFGAS%') and TimestampLocal > '$PreviousTime' and TimestampLocal < '$currentTime' ) AS SourceData PIVOT (AVG(Value) FOR [Path] IN ([BOF2.OFFGAS.Flow],[BOF1.OFFGAS.Flow],[BOF2.OFFGAS.Temp],[BOF1.OFFGAS.Temp],[BOF1.OFFGAS.CO2],[BOF2.OFFGAS.CO2],[BOF1.OFFGAS.CO],[BOF2.OFFGAS.CO],[BOF1.OFFGAS.O2],[BOF2.OFFGAS.O2])) AS PivotTable ) as T group by TimestampLocal order by TimestampLocal; "
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
$filePathDay = "vwVariableTrends"+$endDay
$jsonContent = $jsonResult | ConvertTo-Json -Depth 100

$jsonContent | Out-File -FilePath "C:\Users\XST4758\Desktop\AutoExportJsonFile\$filePathDay.json" -Encoding UTF8