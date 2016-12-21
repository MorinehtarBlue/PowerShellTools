#
# Get_StaleComputers_Excel.ps1
#
$Now = Get-Date
$domain = $Args[0]
Write-Host "****************************************"
Write-Host "Starting At" $Now
$strPath = "$PWD\StaleComputers_$domain.xls"
$Excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.add()
$workbook.worksheets.Item(3).delete()
$workbook.worksheets.Item(2).delete()
$workbook.WorkSheets.item(1).Name = "Computers"
$sheet = $workbook.WorkSheets.Item("computers")

$y=2

$lineStyle = "microsoft.office.interop.excel.xlLineStyle" -as [type]
$colorIndex = "microsoft.office.interop.excel.xlColorIndex" -as [type]
$borderWeight = "microsoft.office.interop.excel.xlBorderWeight" -as [type]
$chartType = "microsoft.office.interop.excel.xlChartType" -as [type]

For($b = 1 ; $b -le 5 ; $b++)
{
 $sheet.cells.item(1,$b).font.bold = $true
 $sheet.cells.item(1,$b).borders.LineStyle = $lineStyle::xlContinuous
 $sheet.cells.item(1,$b).borders.ColorIndex = $colorIndex::xlColorIndexAutomatic
 $sheet.cells.item(1,$b).borders.Weight = $borderWeight::xlMedium
}

$sheet.cells.item(1,1) = "Name"
$sheet.cells.item(1,2) = "lastLogon"
$sheet.cells.item(1,3) = "daysOld"
$sheet.cells.item(1,4) = "managedBy"
$sheet.Cells.item(1,5) = "path"


 $root=[ADSI]"LDAP://DC=$domain,DC=xerox,DC=net"
 $search=[System.DirectoryServices.DirectorySearcher]$root
 $Search.Filter="(&(objectCategory=Computer)(objectClass=computer)(name=*))"
 $search.PageSize = 100
 $results=$Search.FindAll()
 $today = Get-Date
 $x=0

 Foreach($result in $results)
 {
  $managedBy = $result.Properties.item('managedBy')[0]
  $name = $result.Properties.item('name')[0]
  #$adsPath = $result.Properties.Item('adsPath')[0]
  $adsPath = $result.Path.Substring($result.Path.IndexOf(",", 0)+1)
  $lastLogon = [datetime]::FromFileTime($result.properties.item('lastLogon')[0])
  [TimeSpan]$staleDuration = New-TimeSpan $lastLogon $today
  $daysOld = $staleDuration.Days
  If($daysOld -gt $Args[1])
  {
    $sheet.cells.item($y,1) = $name
    $sheet.cells.item($y,2) = [String]$lastLogon
    $sheet.cells.item($y,3) = $daysOld
    $sheet.cells.item($y,4) = $managedBy
	$sheet.Cells.item($y,5) = $adsPath
    Write-Host $adsPath
    $x++
    $y++
  }
 } #end foreach

$range = $sheet.usedRange
$range.EntireColumn.AutoFit() | out-null

IF(Test-Path $strPath)
  {
  Remove-Item $strPath
  $Excel.ActiveWorkbook.SaveAs($strPath)
  }
ELSE
  {
  $Excel.ActiveWorkbook.SaveAs($strPath)
  }

$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel)

Remove-Variable Excel
$Now = Get-Date
Write-Host "$x objects found"
Write-Host "Finished At" $Now
