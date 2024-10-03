<#
    .SYNOPSIS
        Imports CSV files into MSSQL Database. 
    .DESCRIPTION
        This script imports multiple a CSV files into a given MSSQL Database. 
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
    .PARAMETER MetricsTable
        The table name where data will be stored in.
        Example: MEASUREMENTS
    .PARAMETER MetadataTable
        The table name where the metadata (dimensions) will be stored in.
        Example: DIMENSIONS
    .PARAMETER UploadMetadata
        Specify whether the script should upload metadata or not
        Dafault: $False
    .NOTES
        Version: 0.1.2 (2022-09-23)
        Author: Emerson Navarro
        Date:   May, 2022
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
 
    # Metrics table name
    [Parameter(Mandatory = $false)]
    [String]
    $MetricsTable = "MEASUREMENTS",
 
    # Metadata table name
    [Parameter(Mandatory = $false)]
    [String]
    $MetadataTable = "DIMENSIONS",
   
    # Specify whether the script should upload metadata or not
    [Parameter(Mandatory = $false)]
    [Boolean]
    $UploadMetadata = $True,
 
    # LogPath
    [Parameter(Mandatory = $false)]
    [String]
    $LogPath = "$RootDir\Scripts\KPI_data_Load\logs\loadtodb"
)
 
# CONST
$ROOT_TRANSFORMED_DIR = "$RootDir\Transformed"
$ROOT_ARCHIVED_DIR = "$RootDir\Archive\Loaded"
$LogFile = "$LogPath\$(Get-Date -format 'yyyy-MM-dd')_LoadToDb.log"
$FaileLogFile = "$LogPath\FailedRecords$(Get-Date -format 'yyyy-MM-dd')_LoadToDb.log"
     
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
 
function Write-FailedRecords {
    param (
        $Message
    )
    $File = $FaileLogFile
 
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
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    # Installing module
    Install-Module -Name SqlServer -Scope CurrentUser -Confirm:$false -AllowClobber

    # Importing SqlServer module
    Import-Module SqlServer -PassThru -ErrorAction Stop
}
 
if ($UploadMetadata) {
    $types = @("transformed", "metadata")
} else {
    $types = @("transformed")
}
 
foreach ($CSVFileType in $types) {
   
    # Retrieve the list of CSV files within the "Transformed" directory
    $CSVFilesList = Get-ChildItem -Path $ROOT_TRANSFORMED_DIR -Recurse -Depth 1 -Filter "*_$CSVFileType*.csv"
    Write-Log "$(Get-Date -format 'u') [I] $($CSVFilesList.Count) transformed files to be loaded into the database."
 
    if ($CSVFileType -eq "transformed") {
        $TableName = $MetricsTable
    } else {
        $TableName = $MetadataTable
    }
 
    # Controls the current CSV file being processed.
    $CSVFilesCounter = 1
 
    # Iterates through all CSV files of the list
    ForEach ($CSVFile in $CSVFilesList) {
   
        Write-Log "$(Get-Date -format 'u') [I] Importing CSV file ""$($CSVFile.FullName)"" to table ""$TableName"" ($CSVFilesCounter/$($CSVFilesList.Count))."
       try {
            # Bulk operation as of https://docs.microsoft.com/en-us/powershell/module/sqlserver/write-sqltabledata?view=sqlserver-ps#example-3--import-data-from-a-file-to-a-table
            #, (Import-CSV $CSVFile.FullName) | Write-SqlTableData -ServerInstance $SQLInstance -DatabaseName $SQLDatabase -SchemaName "dbo" -TableName $TableName -Timeout 0 -Force -ErrorAction Stop
            

            $P=Import-CSV $CSVFile.FullName 
            foreach ( $object in $P) {
            , ($object) | Write-SqlTableData -ServerInstance $SQLInstance -DatabaseName $SQLDatabase -SchemaName "dbo" -TableName $TableName -Timeout 0 -Force -ErrorAction SilentlyContinue
            if ( $? -eq $false) { 
                Write-FailedRecords $object}
            }
             
            # If the Bulk insert has happened successfully, retrieves the directory name of the current CSV file...
            $PlatformDirectory = $CSVFile.Directory.Name
            $Destination = "$ROOT_ARCHIVED_DIR\$PlatformDirectory\$($CSVFile)"
           
            # ...then archive the file.
            Write-Log "$(Get-Date -format 'u') [I] Finished importing file $CSVFile. Moving file to archive folder."
            Move-Item -Path $($CSVFile.FullName) -Destination $Destination
        }
        catch {
            # Something went wrong while writing the CSV file content into the database
            Write-Log "$(Get-Date -format 'u') [E] CSV file ""$CSVFile"". File will not be archived."
            Write-Log "$(Get-Date -format 'u') [Error] $($_.Exception.Message)"
        }
   
        # Counter
        $CSVFilesCounter++
    }
}