# ICMP-TransferTools-PowerShell

## Table of Contents
1. [Overview](#overview)
2. [Tool Descriptions](#tool-descriptions)
   - [ICMP-SendFile.ps1](#icmp-sendfileps1)
   - [ICMP-ReceiveFile.ps1](#icmp-receivefileps1)
   - [Invoke-IcmpDownload.ps1](#invoke-icmpdownloadps1)
   - [Invoke-IcmpUpload.ps1](#invoke-icmpuploadps1)
3. [Installation and Prerequisites](#installation-and-prerequisites)
4. [Usage Examples](#usage-examples)
5. [Administrative Privileges and Alternatives](#administrative-privileges-and-alternatives)
6. [PowerShell vs Python Version](#powershell-vs-python-version)

## Overview
ICMP-TransferTools-PowerShell is a set of PowerShell scripts designed to transfer files between Windows hosts using ICMP packets. This approach enables file transfers in restricted network environments without relying on traditional file transfer methods.

## Tool Descriptions
### ICMP-SendFile.ps1
**Description:**
Transfers a file over ICMP to a remote host that is running the `Invoke-IcmpDownload.ps1` script.

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
**Description:**
Receives an ICMP-based file transfer from `Invoke-IcmpUpload.ps1`.

**Usage:**
```
ICMP-ReceiveFile.ps1 -src ClientIP -file DestinationFileName
```
- `src`: Public IP address of the sender.
- `file`: Destination file where received data will be saved.

### Invoke-IcmpDownload.ps1
**Description:**
Downloads a file via ICMP by communicating with `ICMP-SendFile.ps1`.

**Usage:**
```
Invoke-IcmpDownload -ServerIP YourPublicIP -FileName FileToDownload
```
- `ServerIP`: The IP of the machine running `ICMP-SendFile.ps1`.
- `FileName`: The name of the file to be downloaded.

### Invoke-IcmpUpload.ps1
**Description:**
Uploads a file over ICMP to a remote system that is running `ICMP-ReceiveFile.ps1`.

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
- `ICMP-ReceiveFile.ps1` and `ICMP-SendFile.ps1` require admin rights to modify ICMP firewall rules.
- Run PowerShell as administrator before executing these scripts.

### Alternative Without Admin Rights:
- If admin rights are unavailable, use **Windows Firewall Advanced Settings** to manually allow ICMP traffic.

## PowerShell vs Python Version
With the conversion of `ICMP-ReceiveFile.py` and `ICMP-SendFile.py` to PowerShell, there are no fundamental changes to the way these tools function. The PowerShell versions remain fully compatible with `Invoke-IcmpDownload.ps1` and `Invoke-IcmpUpload.ps1`, maintaining seamless file transfers. Key impacts of the PowerShell conversion:

- **Removal of Python and Impacket Dependency:** Unlike the previous Python versions, these scripts do not require external libraries like `Impacket`, simplifying deployment.
- **Same Functionality:** The workflow remains identical—files are sent and received using ICMP, maintaining compatibility with the original tools.
- **Increased PowerShell Integration:** The scripts leverage built-in PowerShell commands, removing the need for additional software installation.
- **Alternative Implementation for ICMP Packet Handling:** While Python required raw socket handling via `Impacket`, PowerShell achieves similar behavior using .NET networking objects.

### Key Differences & Alternative Considerations
- **Administrative Rights:** Unlike Python, PowerShell requires admin privileges to modify ICMP firewall rules. If admin rights are unavailable, manually enabling ICMP traffic in Windows Firewall is required.
- **Cross-Platform Compatibility:** The Python versions allowed execution across multiple operating systems, whereas the PowerShell scripts are Windows-exclusive.
- **Performance Considerations:** PowerShell's handling of ICMP packets might introduce slight differences in execution timing, but this does not impact overall functionality.

## Notes
- These scripts should be executed within PowerShell with necessary execution policies enabled.
- Ensure proper firewall settings allow ICMP traffic on both hosts.

**Enjoy secure file transfer over ICMP!**
