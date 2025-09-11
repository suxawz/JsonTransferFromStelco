$server = "LVLMSPRDSQL1"
$database = "meltshopStelco"
$username = "meltshop365"
$password = "meltshoP365!"
$currentTime = (Get-Date)
$query = "  
SELECT [MaterialID]
      ,[MaterialIdentNumber]
      ,[MaterialDeliveryNumber]
      ,[ShortName]
      ,M.[Name]
      ,[InternalName]
      ,M.[Description]
      ,[MaterialTypeID]
      ,[Status]
      ,[DeliveryManaged]
      ,[BasicElementID]
	  ,E.Name as BasicElement
      ,[AccountNumber]
      ,[MaterialFormID]
      ,[SpecificWeight]
      ,[BulkWeight]
      ,[Price]
      ,[SupplierID]
      ,[ShipperID]
      ,[DeliveryDate]
      ,[DeliveryQuantity]
      ,[DeliveryAmount]
      ,[AmountStored]
      ,[AmountUsed]
      ,[AmountReserved]
      ,[DeliveryStatus]
      ,[LiquidusTemperature]
      ,[EffectiveHeatCapacityMin]
      ,[EffectiveHeatCapacityMax]
      ,[Enthalpy]
      ,[HeatOfFusion]
      ,[CoolingEfficiency]
      ,[FeederSwitchOverWeight]
      ,[FeederSwitchOffWeight]
      ,[FeederMin]
      ,[FeederMax]
      ,[DeliveryFlag]
      ,[Yield]
      ,[MaterialIdentNumberERP]
      ,[IsCalculationPriceFixed]
      ,[WeightContributionID]
      ,[MaxWeightForHeat]
      ,[BOFCalculationAimBeforeHmFix]
      ,[MaterialTypeInternalName]
  FROM [meltshopStelco].[dbo].[vwMaterialMasterData] M
  left join tblElements E on E.ElementID = M.BasicElementID  "
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
$filePathDay = "tblBOFModelMaterials"+$endDay
$jsonContent = $jsonResult | ConvertTo-Json -Depth 100

$jsonContent | Out-File -FilePath "C:\Users\XST4758\Desktop\AutoExportJsonFile\$filePathDay.json" -Encoding UTF8