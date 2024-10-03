<#
    .SYNOPSIS
        Imports CSV files into MSSQL Database. 
    .DESCRIPTION
        This script updates the tables in MSSQL Database. 
    .INPUTS
        The script allows to specify a "secrets" file. The secrets file should contain the encrypted password of the SQL User.
    .PARAMETER RootDir
        Project's directory root path
        Example: \\path\to\server\
        Default: \\vdenasnfs03\KPI_Metrics
    .PARAMETER SQLInstance
        Qualified name of the SQL instance
        Example: Hostname\MSSQL
        Default: LOCALHOST\SQLEXPRESS
    .PARAMETER SQLDatabase
        The database name
        Example: MyDb
    .NOTES
        Version: 0.1.2 (2022-12-01)
        Author: Maren Kneissle
        Date:   Dec, 2022
#>
[CmdletBinding()]
param (
    # The the MSSQL server "Hostname\Instance" name
    [Parameter(Mandatory = $false)]
    [String]
    $RootDir = "C:\Users\Manu\Desktop\Programming\PowerShell\KPI_METRICS",
   
    # MSSQL server qualified name ("Hostname\Instance")
    [Parameter(Mandatory = $false)]
    [String]
    $SQLInstance = "DESKTOP-34AUI23\SQLEXPRESS",
           
    # Database name
    [Parameter(Mandatory = $false)]
    [String]
    $SQLDatabase = "master",
   
 
    # LogPath
    [Parameter(Mandatory = $false)]
    [String]
    $LogPath = "$RootDir\Scripts\KPI_data_Load\logs\updatemodel"
)
 
# CONST
 
$LogFile = "$LogPath\$(Get-Date -format 'yyyy-MM-dd')_UpdateModel.log"
 
function Write-Log {
    param (
        $Message
    )
    $File = $LogFile
 
    try {
        Tee-Object -InputObject $Message -FilePath $File -Append
    }
    catch [System.IO.DirectoryNotFoundException] {
        New-Item $LogPath -ItemType Directory
        Tee-Object -InputObject $Message -FilePath $File -Append
    }
}
 
# Install the SqlServer module from the PSGallery if needed.
if (-not (Get-Module -ListAvailable SqlServer)) {
    Write-Log "$(Get-Date -format 'u') [I] SqlServer Module Not Found - Installing it."
       
    # Not installed, trusting PS Gallery to remove prompt on install
    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted 
       
    # Installing module
    Install-Module -Name SqlServer -Scope CurrentUser -Confirm:$false -AllowClobber
 
    # Importing SqlServer module
    Import-Module SqlServer -PassThru -ErrorAction Stop
}
 
 
# Update fact table
Write-Log "$(Get-Date -format 'u') [I] Update fact table."
$FACT_TABLE_SQL = "$RootDir\Scripts\KPI_Data_Load\Data_Model\kpi_dashboard\target\run\kpi_dashboard\models\serving\fact_table.sql"
try {
    #Invoke-Sqlcmd -InputFile $FACT_TABLE_SQL -ServerInstance $SQLInstance -Database $SQLDatabase 
    Invoke-Sqlcmd -InputFile $FACT_TABLE_SQL -ServerInstance $SQLInstance -Database $SQLDatabase  -TrustServerCertificate
               Write-Log "$(Get-Date -format 'u') [I] Successfully updated fact table."
}
catch {
            # Something went wrong while updating the fact table
            Write-Log "$(Get-Date -format 'u') [E] fact table was not updated"
            Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.Message)"
        }
 
# Update instances table
Write-Log "$(Get-Date -format 'u') [I] Update instances table."
$INSTANCES_TABLE_SQL = "$RootDir\Scripts\KPI_Data_Load\Data_Model\kpi_dashboard\target\run\kpi_dashboard\models\serving\instances.sql"
try {
    Invoke-Sqlcmd -InputFile $INSTANCES_TABLE_SQL -ServerInstance $SQLInstance -Database $SQLDatabase -TrustServerCertificate
               Write-Log "$(Get-Date -format 'u') [I] Successfully updated instances table."
}
catch {
            # Something went wrong while updating the instances table
            Write-Log "$(Get-Date -format 'u') [E] instances table was not updated"
            Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.Message)"
        }
 
 
# Update systems table
Write-Log "$(Get-Date -format 'u') [I] Update systems table."
$SYSTEMS_TABLE_SQL = "$RootDir\Scripts\KPI_Data_Load\Data_Model\kpi_dashboard\target\run\kpi_dashboard\models\serving\systems.sql"
try {
    Invoke-Sqlcmd -InputFile $SYSTEMS_TABLE_SQL -ServerInstance $SQLInstance -Database $SQLDatabase -TrustServerCertificate
               Write-Log "$(Get-Date -format 'u') [I] Successfully updated systems table."
}
catch {
            # Something went wrong while updating the systems table
            Write-Log "$(Get-Date -format 'u') [E] systems table was not updated"
            Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.Message)"
        }
 
# Update users table
Write-Log "$(Get-Date -format 'u') [I] Update users table."
$USERS_TABLE_SQL = "$RootDir\Scripts\KPI_Data_Load\Data_Model\kpi_dashboard\target\run\kpi_dashboard\models\serving\users.sql"
try {
    Invoke-Sqlcmd -InputFile $USERS_TABLE_SQL -ServerInstance $SQLInstance -Database $SQLDatabase -TrustServerCertificate
               Write-Log "$(Get-Date -format 'u') [I] Successfully updated users table."
}
catch {
            # Something went wrong while updating the users table
            Write-Log "$(Get-Date -format 'u') [E] users table was not updated"
            Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.Message)"
        }