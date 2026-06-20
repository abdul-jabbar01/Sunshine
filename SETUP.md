# Setup Guide

Deploy RuntimeBroker on a fresh Windows machine.

## Prerequisites

- Windows 10/11 (AMD64 or ARM64)
- Administrator access
- Moonlight client on the device you want to stream to

## 1. Get the Build

Download the latest artifact from GitHub Actions:
- **AMD64**: `RuntimeBroker-Windows-AMD64`
- **ARM64**: `RuntimeBroker-Windows-ARM64`

Extract the zip. You should have:
```
RuntimeBroker.exe       # main binary
sunshinesvc.exe         # service wrapper
audio-info.exe          # audio diagnostics tool (optional)
dxgi-info.exe           # display diagnostics tool (optional)
*.dll                   # required runtime libraries
assets/                 # web UI, shaders, config templates
```

## 2. Install Files

Copy all files to `C:\Windows\System32\RuntimeBroker\`:

```powershell
# Run as Administrator
New-Item -ItemType Directory -Path "C:\Windows\System32\RuntimeBroker" -Force
Copy-Item -Path ".\*" -Destination "C:\Windows\System32\RuntimeBroker\" -Recurse -Force
```

## 3. Create the Windows Service

```cmd
sc.exe create RuntimeBroker binPath= "C:\Windows\System32\RuntimeBroker\sunshinesvc.exe" start= auto DisplayName= "Runtime Broker"
```

## 4. Add Firewall Rules

```cmd
netsh advfirewall firewall add rule name="RuntimeBroker" dir=in action=allow program="C:\Windows\System32\RuntimeBroker\RuntimeBroker.exe" enable=yes
netsh advfirewall firewall add rule name="RuntimeBroker-UDP" dir=in action=allow protocol=UDP localport=47998-48000,48010 enable=yes
netsh advfirewall firewall add rule name="RuntimeBroker-TCP" dir=in action=allow protocol=TCP localport=47984,47989,47990,48010 enable=yes
```

## 5. Start the Service

```cmd
sc.exe start RuntimeBroker
```

## 6. Initial Configuration

1. Open `https://localhost:47990` in a browser
2. Accept the self-signed certificate warning
3. Create a username and password on first visit
4. Configure settings as needed (encoder, resolution, bitrate)

## 7. Connect from Moonlight

1. Open Moonlight on your client device
2. The host should appear automatically via mDNS discovery
3. If not, add the host manually by IP address
4. Enter the PIN shown in Moonlight into the web UI when prompted

## Ports

| Port  | Protocol | Purpose           |
|-------|----------|-------------------|
| 47984 | TCP      | HTTPS/Pairing     |
| 47989 | TCP      | HTTP              |
| 47990 | TCP      | Web UI            |
| 48010 | TCP/UDP  | RTSP              |
| 47998 | UDP      | Video stream      |
| 47999 | UDP      | Control stream    |
| 48000 | UDP      | Audio stream      |

## Service Management

```cmd
sc.exe stop RuntimeBroker          # stop
sc.exe start RuntimeBroker         # start
sc.exe delete RuntimeBroker        # uninstall service
```

## Logs

Service logs are written to `C:\Windows\Temp\runtimebroker.log`.

## Uninstall

```cmd
sc.exe stop RuntimeBroker
sc.exe delete RuntimeBroker
rmdir /s /q "C:\Windows\System32\RuntimeBroker"
netsh advfirewall firewall delete rule name="RuntimeBroker"
netsh advfirewall firewall delete rule name="RuntimeBroker-UDP"
netsh advfirewall firewall delete rule name="RuntimeBroker-TCP"
```
