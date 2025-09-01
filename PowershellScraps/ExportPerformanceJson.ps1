$server = "LVLMSPRDSQL1"
$database = "meltshopStelco"
$username = "meltshop365"
$password = "meltshoP365!"
$currentTime = (Get-Date)
$PreviousTime = $currentTime.AddDays(-7)
$query = "  SELECT [BOFCalculationID],[Grade],[AimAnalEOBC],FORMAT(CalculationTime, 'yyyy-MM-dd HH:mm:ss') as CalculationTime,[HeatStatus],PerformanceTB.[HeatNumber],[ModelHeatID],[HotMetalTemp],[HotMetalC],[HotMetalSi],[HotMetalP],[AimC],[AimP],[PredC],[PredFeO],[SteelAnalysisC],[SteelAnalysisP],[SlagAnalysisSiO2],[SlagAnalysisFeO],[SlagAnalysisCaO],[SlagAnalysisMgO],[MixAnalysisC],[MixAnalysisSi],[ModelTemp],[TempMeasTemp],[TempMeasTempModel],FORMAT(TempMeasTempTime, 'yyyy-MM-dd HH:mm:ss') as TempMeasTempTime ,[CeloxTemp],[CeloxOxygen],[CeloxCarbon],[CeloxTempModel],FORMAT(CeloxTempDateTime, 'yyyy-MM-dd HH:mm:ss') as CeloxTempDateTime ,[AimtempEOB],[ModelSteelMass],[PredBascy],[ActBascy],[ModelHotMetalWeight],[ActHotMetalWeight],[PredBush1],[PredDealerBundles],[PredHMS1],[PredHomeScrap],[PredLowSStelcoPigIro],[PredPAndS],[PredPitScrap],[PredPrimeBundles],[PredScrap],[PredShred],[PredSlabCrops],[PredTundish],[PredTotal],[ActBush1],[ActDealerBundles],[ActHMS1],[ActHomeScrap],[ActLowSStelcoPigIro],[ActPAndS],[ActPitScrap],[ActPrimeBundles],[ActScrap],[ActShred],[ActSlabCrops],[ActTundish],[ActTotal],[PRED_ORE],[ACTUAL_ORE],[PRED_LIME],[ACTUAL_LIME],[PRED_DOLO],[ACTUAL_DOLO],[PRED_FESI],[ACTUAL_FESI],[PRED_SIC],[ACTUAL_SIC],[PRED_Limestone],[ACTUAL_Limestone],[ModelCastingLadle],[ActCastingLadle],[OxygenVolumePred],[OxygenVolumeAct],[BlowingProfileActive],[MaterialFluxActive],[MaterialTappingActive]  ,FORMAT([StartTime], 'yyyy-MM-dd HH:mm:ss') as BlowStartTime ,[OffgasAnalyzer] ,[EOBO2Amount],[EOBSwitchOffValue],[EOBSwitchOffValueLast],[EOBSwitchOffValueTarget],[EOBCO],[EOBCO2],[EOBDetectionLog],[EOBO2AmountAct],[EOBSwitchOffValueAct],[EOBSwitchOffValueLastAct],[EOBSwitchOffValueTargetAct],[EOBCOAct],[EOBCO2Act],[EOBDetectionLogAct],[PRED_O2Vol],[AIM_EOB_C],[ACT_FeO],[ACT_C]FROM [meltshopStelco].[dbo].[vwBOFPerformanceLoginov] as PerformanceTB left join [meltshopStelco].[dbo].[vwBOFPerformanceEndOfBlowDetectionLogs] as EOBLogs on EOBLogs.HeatNumber = PerformanceTB.HeatNumber where CalculationTime  > '$PreviousTime' and CalculationTime < '$currentTime' order by CalculationTime "
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
$filePathDay = "vwBOFPerformanceLoginov"+$endDay
$jsonContent = $jsonResult | ConvertTo-Json -Depth 100

$jsonContent | Out-File -FilePath "C:\Users\XST4758\Desktop\AutoExportJsonFile\$filePathDay.json" -Encoding UTF8