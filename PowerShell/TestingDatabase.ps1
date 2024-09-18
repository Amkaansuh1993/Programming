# [void][System.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector NET 8.4\MySql.Data.dll")
# $myconnection = New-Object MySql.Data.MySqlClient.MySqlConnection
# $myconnection.ConnectionString = "server=127.0.0.1;user id=root;password=;database=pm_kpi;pooling=false"
# $myconnection.Open()

# $mycommand = New-Object MySql.Data.MySqlClient.MySqlCommand
# $mycommand.Connection = $myconnection
# $mycommand.CommandText = "Select 1"
# $myreader = $mycommand.ExecuteReader()
# while($myreader.Read()){ $myreader.GetInt32(0) }

# $myconnection.Close()


# function Invoke-MySQL {
#     Param(
#       [Parameter(
#       Mandatory = $true,
#       ParameterSetName = '',
#       ValueFromPipeline = $true)]
#       [string]$Query
#       )
    
#     $MySQLAdminUserName = 'root'
#     $MySQLAdminPassword = ''
#     $MySQLDatabase = 'pm_kpi'
#     $MySQLHost = '127.0.0.1'
#     $ConnectionString = "server=" + $MySQLHost + "; port=3306; uid=" + $MySQLAdminUserName + "; pwd=" + $MySQLAdminPassword + "; database="+$MySQLDatabase
    
#     Try {
#       [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
#       $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
#       $Connection.ConnectionString = $ConnectionString
#       $Connection.Open()
    
#       $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
#       $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
#       $DataSet = New-Object System.Data.DataSet
#       $RecordCount = $dataAdapter.Fill($dataSet, "data")
#       $DataSet.Tables[0]
#       Write-Output $RecordCount
#       }
    
#     Catch {
#       throw "ERROR : Unable to run query : $query `n$Error[0]"
#      }
    
#     Finally {
#       $Connection.Close()
#       }
#      }
    
#     Invoke-MySQL -Query "select * from Dimensions"



    $sendMailMessageSplat = @{
      From = 'manu.dak@gmail.com'
      To = 'manu.dak@gmail.com'
      Subject = 'Test mail'
  }
  Send-MailMessage @sendMailMessageSplat