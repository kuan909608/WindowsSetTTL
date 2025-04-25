# WindowsSetTTL

> 🌐 This README is available in other languages:
>
> - [繁體中文 (Traditional Chinese)](README.zh-TW.md)

This script allows you to easily set or reset the global IPv4 TTL (Time To Live) value on Windows.

## Prerequisites

- Administrator privileges

## Usage

1.  Run the `WindowsSetTTL.bat` script.
2.  The script will display the current IPv4 interfaces on your machine and the current global IPv4 TTL value.
3.  You will be prompted to restore the TTL to 128 (if it is not already 128).
4.  You will then be prompted to set a new TTL value.
5.  Enter a new TTL value between 1 and 255.

## Environment

- Windows 10 or later
- PowerShell 5.0 or later

## Notes

- The TTL value determines how many hops a packet can travel before it is discarded.
- A lower TTL value can improve network security by preventing packets from traveling too far.
- A higher TTL value can improve network connectivity by allowing packets to travel further.
- The TTL value will take effect immediately. However, you may need to re-set the TTL value after restarting your computer.
- In certain scenarios such as mobile hotspot sharing, adjusting TTL may improve compatibility or help bypass traffic detection or filtering mechanisms enforced by the provider. Please ensure such usage complies with your network's terms of service.

## Common Issue When Downloading

If you download the script via the "Raw" button on GitHub, your system may save it with line endings in LF format (Unix-style) instead of CRLF format (Windows-style). This can cause the `.bat` script to fail when executed on Windows.

### How to Fix

Ensure the file uses CRLF line endings before running:

- Open the `.bat` file using a text editor like Notepad++ or Visual Studio Code.
- Convert the line endings:
  - **Notepad++:** Edit → EOL Conversion → Windows (CRLF)
  - **VS Code:** Click `LF` in the bottom-right corner → Select `CRLF`
- Save the file after conversion.

Alternatively, consider cloning the repository or downloading the ZIP file to avoid formatting issues.
