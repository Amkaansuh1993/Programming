<#
    .SYNOPSIS
        Transforms CSV files into Data Model
    .DESCRIPTION
        This script parses one or multiple a raw data CSV files and transforms them in a single CSV file that matches the Data model
    .PARAMETER RootDir
        The project's directory root path
        Example: \\path\to\server\
        Default: \\vdenasnfs03\KPI_Metrics
    .PARAMETER LogFile
        The full path to the log file
        Example: \\path\to\server\mylog.log
        Default: "C:\Windows\Temp\DD-MM-YYYY_TransformCSVFiles.log"
    .NOTES
        Version: 1.1.0 (2022-11-10)
        Author:  Emerson Navarro (en@zoi.tech)
        Created: May, 2022
#>
 
[CmdletBinding()]
param (
    # Root folder of the project
    [Parameter(Mandatory = $false)]
    [String]
    $RootDir = "C:\Users\Manu\Desktop\Programming\PowerShell\KPI_METRICS",
 
    # Root folder of the project
    [Parameter(Mandatory = $false)]
    [String]
    $LogFile = "$RootDir\Scripts\KPI_Data_Load\logs\transformation\$(Get-Date -format 'yyyy-MM-dd')_TransformCSVFiles.log",

    # Root folder of the project
    [Parameter(Mandatory = $false)]
    [String]
    $ErrorLogFile = "$RootDir\Scripts\KPI_Data_Load\logs\transformation\$(Get-Date -format 'yyyy-MM-dd')_ErrorTransformCSVFiles.log",

    # Define email parameters
    [Parameter(Mandatory = $false)]
    [String]
    $smtpServer = "adesmtp3.de.festo.net",
    $smtpPort = 25,
    $toEmail = "thippesh.l@festo.com",
    $fromEmail = "thippesh.l@festo.com",
    $subject = "Script Failure Notification",
    $body = "The script has encountered an error and failed.",
    $attachments = "D:\in0thpl\Testing KPI Metrics\Scripts\KPI_Data_Load\logs\Transformation\$(Get-Date -format 'yyyy-MM-dd')_ErrorTransformCSVFiles.log"
)
 
$DATA_EXTRACTS_ROOT = "$RootDir\Data_Extracts"
$DATA_TRANSFORMED_ROOT = "$RootDir\Transformed"
$DATA_ARCHIVED_ROOT = "$RootDir\Archive\Transformed"
$TransformedFile = "$(Get-Date -Format "yyyy-MM-dd")_transformed.csv"
$MetadataFile = "$(Get-Date -Format "yyyy-MM-dd")_metadata.csv"
$LOG_DESTINATION = $LogFile
$ERROR_LOG_DESTINATION = $ErrorLogFile
 
 
class DataModelException: System.Exception {
    [String] $additionalData 
    DataModelException([String] $Message, [String] $additionalData) :
    base ("A 'DataModelException' exception has occured: $Message") {
        $this.additionalData = $additionalData
    }
}
function Write-Log {
    param (
        $Message,
        $Path = $LOG_DESTINATION
    )
    Tee-Object -InputObject $Message -FilePath $Path -Append
}

function Write-OutputError {
    param (
        $Message,
        $ErrorPath = $ERROR_LOG_DESTINATION
    )
    Tee-Object -InputObject $Message -FilePath $ErrorPath -Append
}

function ConvertTo-SimpleTR {
    param (
        $arrayData,
        $CreationDate,
        $ProductName,
        $Dimension,
        $ConfigFile,
        $MetricType,
        $Metric
    )
    # Retrieves the metric name
    $MetricName = Get-MetricName -Metric $metric
 
    Return $arrayData | Select-Object @{
        name       = "extraction_date";
        expression = { [Datetime]$CreationDate }
    },
    @{
        name       = "time_id";
        expression = { Get-ParsedDateTime -SourceTime $($_.$($ConfigFile.timestamp.column)) -SourceTimeFormat $($ConfigFile.timestamp.source_format) }
    },
    @{
        name       = "platform";
        expression = { $ProductName }
    },
    @{
        name       = "dimension";
        expression = { $Dimension }
    },
    @{
        name       = "dimension_id";
        expression = { Get-DimensionId -ID $ConfigFile.dimension_id -Item $_ }
    },
    @{
        name       = "metric";
        expression = { $MetricName }
    },
    @{
        name       = "metric_value";
        #expression = { $($_.$($metric.column)).Trim() }
        expression = { $($_.$($metric.column)).Trim() -as $MetricType }
    }
}
 
function ConvertTo-CountByTR {
    param (
        $ArrayData,
        $CreationDate,
        $ProductName,
        $Dimension,
        $ConfigFile,
        $Metric
    )
 
    $MetricName = Get-MetricName -Metric $metric
 
    # Ensures the `dimension_id` is a String
    # if ($ConfigFile.dimension_id -isnot [String] ) {
    #     throw [DataModelException]::("Dimension ID type mismatch. Transformation rule ""count_by"" only supports String", $ConfigFile.dimension_id)
    # }
   
    # Retrieves the Dimension ID
    $DimensionID = Get-DimensionId -ID $ConfigFile.dimension_id
 
    # It assumes the first date is the time_id for all elements
    $TimeId = Get-ParsedDateTime -SourceTime $($ArrayData[0].$($ConfigFile.timestamp.column)) -SourceTimeFormat $($ConfigFile.timestamp.source_format)
 
    # Count lines that have the same value
    $groupedArray = $arrayData | Group-Object { $_.$($Metric.column) }
 
    Return $groupedArray | Select-Object @{
        name       = "extraction_date";
        expression = { [Datetime]$CreationDate }
    },
    @{
        name       = "time_id";
        expression = { $TimeId }
    },
    @{
        name       = "platform";
        expression = { $ProductName }
    },
    @{
        name       = "dimension";
        expression = { $Dimension }
    },
    @{
        name       = "dimension_id";
        expression = { $($_.Name) }
    },
    @{
        name       = "metric";
       expression = { "$MetricName" }
    },
    @{
        name       = "metric_value";
        expression = { $_.Count }
    }
}
 
function ConvertTo-CountDistinctTR {
    param (
        $ArrayData,
        $CreationDate,
        $ProductName,
        $Dimension,
        $ConfigFile,
        $Metric
    )
 
    $MetricName = Get-MetricName -Metric $metric
    # Retrieves the Dimension ID
    $DimensionID = Get-DimensionId -ID $ConfigFile.dimension_id
 
    # It assumes the first date is the time_id for all elements
    $TimeId = Get-ParsedDateTime -SourceTime $($ArrayData[0].$($ConfigFile.timestamp.column)) -SourceTimeFormat $($ConfigFile.timestamp.source_format)
 
    # Count lines that have the same value
    $countDistinct = $arrayData | Select-Object { $_.$($Metric.column) } -Unique
 
    Return $countDistinct.Count | Select-Object @{
        name       = "extraction_date";
        expression = { [Datetime]$CreationDate }
    },
    @{
        name       = "time_id";
        expression = { $TimeId }
    },
    @{
        name       = "platform";
        expression = { $ProductName }
    },
    @{
        name       = "dimension";
        expression = { $Dimension }
    },
    @{
        name       = "dimension_id";
        expression = { $DimensionID }
    },
    @{
        name       = "metric";
        expression = { $MetricName }
    },
    @{
        name       = "metric_value";
        expression = { $_ }
    }
}
 
function ConvertTo-ContainsStringTR {
    param (
        $arrayData,
        $CreationDate,
        $ProductName,
        $Dimension,
        $ConfigFile,
        $Metric
    )
 
    # Retrieves the metric name
    $MetricName = Get-MetricName -Metric $metric
 
    Return $arrayData | Select-Object @{
        name       = "extraction_date";
        expression = { [Datetime]$CreationDate }
    },
    @{
        name       = "time_id";
        expression = { Get-ParsedDateTime -SourceTime $($_.$($ConfigFile.timestamp.column)) -SourceTimeFormat $($ConfigFile.timestamp.source_format) }
    },
    @{
        name       = "platform";
        expression = { $ProductName }
    },
    @{
        name       = "dimension";
        expression = { $Dimension }
    },
    @{
        name       = "dimension_id";
        expression = { Get-DimensionId -ID $ConfigFile.dimension_id -Item $_ }
    },
    @{
        name       = "metric";
        expression = { $MetricName }
    },
    @{
        name       = "metric_value";
        expression = { if ( $($_.$($metric.column)).Trim().Length -gt 0) { 1 } else { 0 } }
    }
}
 
function Get-MetadataValue {
    param(
        $ID,
        $Item
    )
 
    # Type of "attribute_value" is String, so returns the value "as is"
    if ( $ID -is [String]) {
        Return $ID.ToLower().Trim().Replace(" ", "_")
    }
 
    # Type of "attribute_value" is Array, so retrieves the attribute_value from the CSV file.
    # If multiple columns are provided, uses only the first one.
    else {
        return $Item.($ID[0]).Trim().ToLower().Replace(" ", "_")
    }
}
 
function Get-MetadataFromCSV { 
    param (
        # A valid ConfigFile object
        [Parameter(Mandatory = $true)]
        [Object]
        $ConfigFile,
 
        # The content of the raw data CSV file
        [Parameter(Mandatory = $true)]
        [System.Array]
        $ArrayData
    )
   
    $acummulator = @()
  
    foreach ($metadata in $ConfigFile.metadata) {
        # Retrieve the "dimension" from metadata specific parameter or the "Global" configuration
        $Dimension = $null
        if ("dimension" -in $metadata.PSObject.Properties.Name) {
            $Dimension = $metadata.dimension
        } else {
            $Dimension = $ConfigFile.dimension
        }
 
        # Retrieve the "dimension_id" from either the metadata specific parameter or the "Global" configuration
        $DimensionId = $null
        if ("dimension_id" -in $metadata.PSObject.Properties.Name) {
            $DimensionId = $metadata.dimension_id
        }         else {
            $DimensionId = $ConfigFile.dimension_id
        }
       
        # Retrieve the "attribute_name" from either the metadata specific parameter or the "Global" configuration
        $AttributeName = $null
        if ("attribute_name" -in $metadata.PSObject.Properties.Name) {
            $AttributeName = [String]$metadata.attribute_name
        } else {
            $AttributeName = [String]$metadata.attribute_value
        }
       
        # Parses the CSV file and retrieves the metadata information
        $acummulator += $arrayData | Select-Object @{
            name       = "updated_at";
            expression = { Get-ParsedDateTime -SourceTime $($_.$($ConfigFile.timestamp.column)) -SourceTimeFormat $($ConfigFile.timestamp.source_format) }
        },
        @{
            name       = "dimension";
            expression = { $Dimension }
        },
        @{
            name       = "dimension_id";
            expression = { Get-DimensionId -ID $DimensionId -Item $_ }
        },
        @{
            name       = "attribute_name";
            expression = { $AttributeName }
        },
        @{
            name       = "attribute_value";
            expression = { Get-MetadataValue -ID $metadata.attribute_value -Item $_ }
        }
    }
    return $acummulator
}
 
function Convert-RawCSVFile {
    param (
        # The configuration file object
        [Parameter(Mandatory = $true)]
        [Object]
        $ConfigFile,
 
        # The path to the CSV file that contains "raw" data
        [Parameter(Mandatory = $true)]
        [System.Array]
        $ArrayData,
        # The product or plaftform name
        [Parameter(Mandatory = $true)]
        [String]
        $ProductName,
       
        [Parameter(Mandatory = $true)]
        [String]
        $CreationDate,
       
        [Parameter(Mandatory = $true)]
        [String]
        $Dimension
    )
 
    $transformedArray = @()
 
    # Iterates through the metrics of the configuration file
    foreach ($metric in $ConfigFile.metrics) {
 
        switch ($metric.transformation_rule) {
            { $_ -match "count_by" } {
                $transformedArray += ConvertTo-CountByTR -arrayData $ArrayData -CreationDate $CreationDate -ProductName $ProductName -ConfigFile $ConfigFile -Dimension $Dimension -metric $metric
            }
            { $_ -match "count_distinct" } {
                $transformedArray += ConvertTo-CountDistinctTR -arrayData $ArrayData -CreationDate $CreationDate -ProductName $ProductName -ConfigFile $ConfigFile -Dimension $Dimension -metric $metric
            }
            { $_ -match "contains_string" } {
                $transformedArray += ConvertTo-ContainsStringTR -arrayData $ArrayData -CreationDate $CreationDate -ProductName $ProductName -ConfigFile $ConfigFile -Dimension $Dimension -metric $metric
            }
            Default {
                if ($metric.metric_type -match "float|double") {
                    $metric_type = "double"
                }
                elseif ($metric.metric_type -match "int|integer") {
                    $metric_type = "int"
                }
                $transformedArray += ConvertTo-SimpleTR -arrayData $ArrayData -CreationDate $CreationDate -ProductName $ProductName -ConfigFile $ConfigFile -Dimension $Dimension -metric $metric -MetricType $metric_type
            }
        }
    }
    return $transformedArray
}
 
function Get-ParsedDateTime {
    param (
        # A string that represents a DateTime
        [Parameter(Mandatory = $true)]
        [String]
        $SourceTime,
       
        # A string that represents the format of the source DateTime
        # It uses .NET format specifiers. For further information, refer to:
        # https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8
        [Parameter(Mandatory = $true)]
        [String]
        $SourceTimeFormat
    )
    try {
        # Returns a datetime object
        Return [Datetime]::ParseExact($SourceTime, $SourceTimeFormat, $null)
    }
    catch {
        throw [DataModelException]::New("Could not parse datetime. Invalid datetime format", "Invalid date time format.  Source datetime: $($SourceTime). Source time format: $($SourceTimeFormat)")
    }
}
 
function Get-DimensionId {
    param (       
        $ID,
        $Item
    )
    Write-Verbose "$(Get-Date -format 'u') [V] Retrieving the DIMENSION_ID of $ID"
 
    # If the dimension_id is a string, use the value direct as the dimension_id
    if ( $ID -is [String]) {
       
        Write-Verbose "$(Get-Date -format 'u') [V] The type of the DIMENSION_ID is String. Returning $ID"
        Return $ID.ToLower().Trim().Replace(" ", "_")
    }
 
    # If the dimension_id is an array, retrieves the dimension_id from the csv file.
    # Moreover, if the array refers to multiple columns, concatenates the value of each the column with a "."
    else {
        $dimension_id = ""
        for ($index = 0; $index -lt $ID.Length; $index++) {
            # if the position of the array ID is a column in the CSV file, retrieves the ID with the column corresponding value of each line in the CSV file
            if ( $Item.PSObject.Properties.Name -contains $ID[$index] ) {
                $dimension_id += $item.$($ID[$index]).Trim().ToLower().replace(" ", "_")
            }
            # If the position of the array isn't a column in the CSV file, use the position's value "as is"
            else {
                $dimension_id += $($ID[$index]).Trim().ToLower().replace(" ", "_")
            }
            # Appends a "." character in the "dimension_id".
            if ($index -lt $($ID.Length - 1)) {
                $dimension_id += "."
            }
        }
 
        Write-Verbose "$(Get-Date -format 'u') [V] Retrieved DIMENSION_ID: $dimension_id"
        Return $dimension_id
    }
}
 
function Get-Dimension {
    param (       
        $ID
    )
    Write-Verbose "$(Get-Date -format 'u') [V] Retrieving the DIMENSION of $ID"
   
    # If the dimentsion is a string, use the value direct as the system_id
    if ( $ID -match "system|instance|user" ) {
        Write-Verbose "$(Get-Date -format 'u') [V] Provided dimension: $ID"
        $dimension = $ID.ToLower().Trim().replace(" ", "_")
        Return $dimension
    }
    else {
        throw [DataModelException]::New("Invalid dimension '$ID'", "Dimension '$ID' is invalid. Values must be either 'system' or 'instance' or 'user'")
    }
}
 
function Get-MetricName {
    param (       
        $Metric
    )
 
    # If the metric_name is provided in the configuration file;
    if ( "metric_name" -in $metric.PSObject.Properties.Name ) {
        $metric_name = $metric.metric_name.Trim().ToLower().Replace(" ", "_")
        Write-Verbose "$(Get-Date -format 'u') [V] Obtained metric_name from configuration file. Metric name is: $metric_name."
        Return $metric_name
    }
   
    # If the metric_name is not set in the configuration file;
    else {
        $metric_name = $metric.column.Trim().ToLower().Replace(" ", "_")
        Write-Verbose "$(Get-Date -format 'u') [V] Obtaining metric_name from CSV header. Metric name is: $metric_name."
        Return $metric_name
    }
}
 
function Assert-RawCSVFile {
    param(
        # Path of the raw data CSV fIle
        [Parameter(Mandatory = $true)]
        [String]
        $File,
 
        # The parsed config file
        [Parameter(Mandatory = $true)]
        [Object]
        $ValidConfigFile
    )
 
    # Get the header of the file
    $header = Get-RawCSVFileHeader -File $file -HeaderLine $ValidConfigFile.firstline -Delimiter $ValidConfigFile.delimiter
   
    # Create arrayData object that will hold the CSV file
    $arrayData = @()
 
    # Create a reader object to iterate through the CSV file
    $read = New-Object System.IO.StreamReader($file)
 
    # Sets the line iterator to 0.
    # This iterator ensures the CSV file will get read
    # from the firstline defined in the Config file.
    $ln = 1
    # Read through the file
    while (!$read.EndOfStream) {
        # As long as the value of '$ln' is different from the 'firstline'
        # defined in the Config file, skip the the line.
        if ($ln -lt $ValidConfigFile.firstline) {
            $read.ReadLine()
        }
        else {
            # read the line of in the CSV file.
            # Then check if the number of columns in the line match
            # the number of columns in the header. If not throw an error and abort.
            $line = $read.ReadLine()
           
            if ($line.Split($ValidConfigFile.delimiter).Count -ne $header.Count) {
                throw [DataModelException]::New("Invalid raw data CSV file.", "Check number of columns of file: ""$file"" on line $ln")
            }
   
            # If no error found, append the line to the 'arrayData' Object
            $arrayData += $line           
        }
        $ln++
    }
 
    # Close and dipose the reader object
    $read.Close()
    $read.Dispose()
 
 
    # Ensures the raw data CSV file has content, otherwise thrown an error...
    if ($arrayData.Count -le 1) {
        throw [DataModelException]::New("File is empty or couldn't be read", "File: $($RawCsvFIle). No. of lines: $($arrayData.Count)")
    }
   
    # Convert the arrayData object to CSV object and return it
    $arrayData = $arrayData | ConvertFrom-Csv -Delimiter $ValidConfigFile.Delimiter
 
    return $arrayData
}
 
function Get-RawCSVFileHeader {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $File,
       
        [Parameter(Mandatory = $true)]
        [String]
        $HeaderLine,
 
        [Parameter(Mandatory = $true)]
        [String]
        $Delimiter
    )
 
    $read = New-Object System.IO.StreamReader($file)
 
   $ln = 0
    while ($ln -ne $HeaderLine) {
        $read.ReadLine()
        $ln++   
    }
       
    $header = $read.ReadLine()
    $read.Close()
    $read.Dispose()
 
    $header = $header.Replace("`"", "").Split($Delimiter)
    return $header
}
 
function Assert-SchemaFile {
    param(
        # Path of the configuration file
        [Parameter(Mandatory = $false)]
        [String]
        $SchemaFile
    )
 
    # Loads the content of the Configuration File
    try {
        $parsed_schema_file = Get-Content $SchemaFile | ConvertFrom-Json
    }
    Catch [System.ArgumentException] {
        throw [DataModelException]::New("Invalid JSON primitive", "JSON structure of ""$SchemaFile"" is invalid")
    }
   
    # Mandatory properties of the configuration file
    $properties = [array]@("timestamp", "dimension", "dimension_id")
 
    # Ensures all the mandatory properties have been specified in the configuration file
    foreach ($property in $properties) {
        if (-not (Get-Member -InputObject $parsed_schema_file -Name $property -MemberType Properties)) {           
            throw [DataModelException]::New("Missing required parameter: '$property'", "Config file is missing required parameter: '$property'" )
        }
    }
 
    # Checks if either "metrics" or "metadata" were specified
    if (-not ( @("metrics", "metadata") | Where-Object { $parsed_schema_file.PSObject.Properties.Name -Contains $_ } )) {
        throw [DataModelException]::New("Missing required parameter: Either 'metrics' or 'metadata' must be specified.", "Config file is missing required parameter: ""$property""." )
    }
 
    foreach ( $metadata in $parsed_schema_file.metadata ) {
        if ( ("attribute_name" -notin $metadata.PSObject.Properties.Name) -and (( "attribute_value" -notin $metadata.PSObject.Properties.Name)) ) {
            throw [DataModelException]::New("Missing required parameter: You must specify at least one of these 'metadata' parameters: 'attribute_name' or 'attribute_value'", "" )
        }
    }
       
    # Checks the "transformation_rule"
    foreach ($metric in $parsed_schema_file.metrics) {
        if (-not ("transformation_rule" -in $metric.PSObject.Properties.Name  ) ) {
            Write-Verbose "$(Get-Date -format 'u') [V] Setting transformation rule for $($metric.column) as 'simple'."
            Add-Member -InputObject $metric -MemberType NoteProperty -Name "transformation_rule" -Value "simple"
        }
 
        if ($metric.transformation_rule -match "simple" -and $metric.metric_type -notmatch "int|float|double") {
            throw [DataModelException]::New("Parameter missmatch: 'simple' transformation rule supports only numeric metric types", "Transformation rule: $($metric.transformation_rule). Metric type: $($metric.metric_type)")
        }
    }
 
    # Defines the first line of the CSV file to be parsed. If the "firstline" param was not specified in the config file, set "firstline" to 1
    if (-not ('firstline' -in $parsed_schema_file.PSObject.Properties.Name)) {
        Write-Verbose "$(Get-Date -format 'u') [V] First line not provided. Set skip to 0"
        Add-Member -InputObject $parsed_schema_file -MemberType NoteProperty -Name 'firstline' -Value 0
    }
    return $parsed_schema_file
}
 
try {
    Write-Log "$(Get-Date -format 'u') [I] Transformation script execution started."
    Write-Log "$(Get-Date -format 'u') [I] Looking for product folders in the directory root: $RootDir."
 
    # Retrieves the PRODUCT/PLATFORMS folders under the root directory
    $product_folders = Get-ChildItem $DATA_EXTRACTS_ROOT -Directory
    Write-Log "$(Get-Date -format 'u') [I] Found $($product_folders.Count) product folders."
 
    # Iterates through the product folders
    foreach ($product_folder in $product_folders) {
 
        # Set the root folder of the Product/Platform that contains raw CSV files
        $PRODUCT_EXTRACTS_ROOT = "$DATA_EXTRACTS_ROOT\$product_folder"
   
        # Set the root folder of the Product/Platform that stores the transformed CSV file
        $PRODUCT_OUTPUT_ROOT = "$DATA_TRANSFORMED_ROOT\$product_folder"
   
        # Search for configuration files in the root folder of the Product/Platform
        Write-Log "$(Get-Date -format 'u') [I] Searching for configuration files in ""$PRODUCT_EXTRACTS_ROOT"" directory."
        $ConfigurationFiles = Get-ChildItem $PRODUCT_EXTRACTS_ROOT -File -Name "*.json"
 
        # If it finds Configuration files for a given Product/Plaform, iterates through the configuration files
        if ($ConfigurationFiles.Count -gt 0) {
            Write-Log "$(Get-Date -format 'u') [I] Found $($ConfigurationFiles.Count) configuration files in ""$PRODUCT_EXTRACTS_ROOT""."
            $configFileNumber = 0
            foreach ($ConfigurationFile in $ConfigurationFiles) {
                $configFileNumber += 1
                try {
 
                    # Validate that the configuration file structure is correct
                    Write-Log "$(Get-Date -format 'u') [I] Validating structure of the ""$($ConfigurationFile)"" configuration file ($configFileNumber/$($ConfigurationFiles.count))."
                   
                    $ValidConfigFile = Assert-SchemaFile -SchemaFile "$PRODUCT_EXTRACTS_ROOT\$ConfigurationFile"
                   
                    # TODO: SIMPLIFY LOGS
                    Write-Log "$(Get-Date -format 'u') [I] Config file ""$ConfigurationFile"" contains $($ValidConfigFile.metrics.count) metric(s) and $($ValidConfigFile.metadata.count) metadata object(s)"
                   
                    $Dimension = Get-Dimension -ID $ValidConfigFile.dimension
               
                    # Search for CSV files names that contains the "NameMatch" value.  For example, if the config file name is "config_Transformation.json", it matches CSV files which name is "*_Transformation.csv"
                    $NameMatch = "*_" + $($ConfigurationFile -split 'config_(.+).json')[1] + ".csv"
               
                    Write-Log "$(Get-Date -format 'u') [I] Searching for raw data CSV files that contain ""$NameMatch"" in the name."
                    $RawCSVFiles = Get-ChildItem -Path $PRODUCT_EXTRACTS_ROOT -Filter $NameMatch
               
                    Write-Log "$(Get-Date -format 'u') [I] Found $($RawCsvFiles.Count) CSV files in the ""$PRODUCT_EXTRACTS_ROOT"" directory that contains ""$NameMatch"" in the name."
                   
                    if ($RawCsvFiles.Count -gt 0 ) {
                        $csvFileNumber = 0
 
                        # Iterates through the raw data CSV files
                        foreach ($RawCSVFile in $RawCSVFiles) {
                            $csvFileNumber++
                            Write-Log "$(Get-Date -format 'u') [I] Transforming CSV file ""$($RawCSVFile.Name)"" ($csvFileNumber/$($RawCsvFiles.Count))"
 
                            $CreationDate = $RawCSVFile.CreationTime
   
                            # $arrayData = Assert-RawCSVFile -file $RawCSVFile.FullName -ValidConfigFile $ValidConfigFile
                            $arrayData = [System.IO.File]::ReadAllLines($RawCSVFile.FullName)
 
                            # If the raw CSV file has less than 2 lines, it means the raw CSV file is invalid. Thus, throw an error.
                            if ($arrayData.Count -le 1) {
                                throw [DataModelException]::New("File is empty or couldn't be read", "File: $($RawCsvFIle.Name). No. of lines: $($arrayData.Count)")
                            }
 
                            $arrayData = $arrayData | Select-Object -Skip $ValidConfigFile.firstline
                            $arrayData = $arrayData | ConvertFrom-Csv -Delimiter $ValidConfigFile.Delimiter -ErrorAction Stop
                            $arrayData = Sort-Object -InputObject $arrayData
                           
                            # If there are metrics in the Configuration file, transforms the metrics
                            if ($ValidConfigFile.metrics.count -gt 0) {
                                Write-Log "$(Get-Date -format 'u') [I] Extracting $($ValidConfigFile.metrics.count) metric(s) from ""$($RawCSVFile.Name)"""
                                $ExtractedMetrics = Convert-RawCSVFile -ConfigFile $ValidConfigFile -ArrayData $arrayData -ProductName $product_folder -CreationDate $CreationDate -Dimension $Dimension
                                $ExtractedMetrics | Export-Csv -Path "$PRODUCT_OUTPUT_ROOT\$TransformedFile" -Append -NoTypeInformation -Force
                                Write-Log "$(Get-Date -format 'u') [I] Finished extracting metrics for ""$($RawCSVFile.Name)""."
                            }
                           
                            # if config file contains medatada
                            if ($ValidConfigFile.metadata.count -gt 0 -and $arrayData.Count -gt 0) {
                                Write-Log "$(Get-Date -format 'u') [I] Extracting $($ValidConfigFile.metadata.count) metadata object(s) from ""$($RawCSVFile.Name)"""
                                $metadata = Get-MetadataFromCSV -ConfigFile $ValidConfigFile -ArrayData $arrayData
                                $metadata | Export-Csv -Path "$PRODUCT_OUTPUT_ROOT\$MetadataFile" -Append -NoTypeInformation -Force
                                Write-Log "$(Get-Date -format 'u') [I] Finished extracting medatata object(s) from ""$($RawCSVFile.Name)""."
                            }
                           
                            # Archive the raw data CSV file
                            Write-Log "$(Get-Date -format 'u') [I] Finished processing ""$($RawCSVFile.Name)"" file."
                            Write-Log "$(Get-Date -format 'u') [I] Archiving file ""$($RawCSVFile.Name)"" to ""$DATA_ARCHIVED_ROOT\$product_folder\$(Get-Date -Format 'yyyyMMdd')_$RawCSVFile"""
                            Move-Item -path $PRODUCT_EXTRACTS_ROOT\$RawCSVFile -Destination "$DATA_ARCHIVED_ROOT\$product_folder\$(Get-Date -Format 'yyyyMMdd')_$RawCSVFile" -Force
                        }
                    }
                }
                catch [DataModelException] {
                    Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.Message)."
                    Write-Log "$(Get-Date -format 'u') [E] $($_.Exception.additionalData)."
                    Write-OutputError "$(Get-Date -format 'u') [E] $($_.Exception.Message)."
                    Write-OutputError "$(Get-Date -format 'u') [E] $($_.Exception.additionalData)."
                }
            }
        }
        else {
            Write-Log "$(Get-Date -format 'u') [I] No config files found in the ""$PRODUCT_EXTRACTS_ROOT"" directory."
        }
    }

    # Send email
Send-MailMessage -From $fromEmail -To $toEmail -Subject $subject -Body $body -Priority High -DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer $smtpServer -Attachments $attachments
}
catch {   
    # Default unhandled exception
    Write-Log "$(Get-Date -format 'u') [E] Critical exception"
    Write-OutputError "$(Get-Date -format 'u') [E] Critical exception"
    Write-Log "Exception: $($Error[0].Exception)"
    Write-Log "Message details: $($Error[0].PSMessageDetails)"
    Write-Log "ScriptStackTrace: $($Error[0].ScriptStackTrace)"
    Write-Log $Error[0].InvocationInfo
    Exit 1609
}