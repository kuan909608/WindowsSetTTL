# WindowsSetTTL

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
