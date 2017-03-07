

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function download-beat
{
    param([string]$beat, [string]$ver, [string]$folder, [bool]$install)

    $url = "https://artifacts.elastic.co/downloads/beats/$beat/$beat-$ver-windows-x86_64.zip"
    $destfile = "$folder\$beat-$ver-windows-x86_64.zip"
    wget $url -OutFile $destfile
    unzip $destfile $folder
    $f = dir $folder\*$beat-$ver*-windows-x86_64
    rename-item $f $beat
    if ($install -eq $true) {invoke-expression $folder\$beat\install-service-$beat.ps1}
}


$folder = "c:\beats"
mkdir $folder
$ver = "5.2.2"


$beat = "filebeat"
download-beat $beat  $ver $folder $true

$beat = "packetbeat"
download-beat $beat  $ver $folder $true

$beat = "metricbeat"
download-beat $beat  $ver $folder $true

$beat = "winlogbeat"
download-beat $beat  $ver $folder $true

$beat = "heartbeat"
download-beat $beat  $ver $folder $true
