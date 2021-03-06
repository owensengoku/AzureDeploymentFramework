#
# ConfigurationData.psd1
#

@{
    AllNodes = @(
        @{
            NodeName                    = 'LocalHost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true

            DisksPresent                = @{DriveLetter = 'F'; DiskID = '2' }

            ServiceSetStopped           = 'ShellHWDetection'

            # IncludesAllSubfeatures
            WindowsFeaturePresent       = 'RSAT'

            # Current version too low to support Azure AD auth.
            WindowsCapabilityPresent    = @('OpenSSH.Server~~~~0.0.1.0', 'OpenSSH.Client~~~~0.0.1.0')

            ServiceSetStarted           = @('sshd')

            DisableIEESC                = $True

            PowerShellModulesPresent    = 'SQLServer', 'AzureAD', 'oh-my-posh', 'posh-git', 'Terminal-Icons', 'Az.Tools.Predictor'

            # PowerShellModulesPresentCustom2 = @(
            #     @{Name = 'Az'; RequiredVersion = '5.3.0' }
            #     @{Name = 'PSReadline'; RequiredVersion = '2.2.0' }
            # )

            # AppxPackagePresent2             = @(
            #     @{
            #         Name = 'Microsoft.DesktopAppInstaller'
            #         Path = 'F:\Source\Tools\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle' 
            #     }
            # )

            # Single set of features
            WindowsFeatureSetPresent    = 'GPMC', 'NET-Framework-Core'

            DirectoryPresent            = @('F:\Source', 'F:\Repos', 'c:\program files\powershell\7')

            EnvironmentPathPresent      = @(
                'F:\Source\Tools\', 
                'C:\Windows\System32\config\systemprofile\.vs-kubernetes\tools\helm\windows-amd64',
                'C:\Windows\System32\config\systemprofile\.vs-kubernetes\tools\kubectl',
                'C:\Windows\System32\config\systemprofile\.vs-kubernetes\tools\minikube\windows-amd64',
                'C:\Windows\System32\config\systemprofile\.vs-kubernetes\tools\draft\windows-amd64'
            )

            FWRules                     = @(
                @{
                    Name      = 'SSH TCP Inbound'
                    LocalPort = '22'
                }
            )

            DevOpsAgentPresent2         = @(
                @{ 
                    orgUrl       = 'https://dev.azure.com/AzureDeploymentFramework/'
                    AgentVersion = '2.165.0'
                    AgentBase    = 'F:\Source\vsts-agent'
                    Agents       = @(
                        @{pool = '{0}-{1}-Apps1'; name = '{0}-{1}-Apps101'; Ensure = 'Absent'; Credlookup = 'DomainCreds' },
                        @{pool = '{0}-{1}-Apps1'; name = '{0}-{1}-Apps102'; Ensure = 'Absent'; Credlookup = 'DomainCreds' },
                        @{pool = '{0}-{1}-Infra01'; name = '{0}-{1}-Infra01'; Ensure = 'Absent'; Credlookup = 'DomainCreds' }
                    )
                }
            )

            RegistryKeyPresent          = @(
                @{ 
                    # enable developer mode to sideload appx packages, including winget
                    Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'; 
                    ValueName = 'AllowDevelopmentWithoutDevLicense';	ValueData = 1 ; ValueType = 'Dword'
                },

                @{ 
                    Key = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; 
                    ValueName = 'DontUsePowerShellOnWinX';	ValueData = 0 ; ValueType = 'Dword'
                },

                @{ 
                    Key = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; 
                    ValueName = 'TaskbarGlomLevel';	ValueData = 1 ; ValueType = 'Dword'
                },

                @{ 
                    Key = 'HKEY_LOCAL_MACHINE\Software\OpenSSH'; 
                    ValueName = 'DefaultShell';	ValueData = 'C:\Program Files\PowerShell\7\pwsh.exe' ; ValueType = 'String'
                }
            )

            LocalPolicyPresent2         = @(
                @{KeyValueName = 'SOFTWARE\Microsoft\Internet Explorer\Main\NoProtectedModeBanner'; PolicyType = 'User'; Data = '1'; Type = 'DWord' },
                @{KeyValueName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\contoso.com\*'; PolicyType = 'User'; Data = '2'; Type = 'DWord' },
                @{KeyValueName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DontUsePowerShellOnWinX'; PolicyType = 'User'; Data = '0'; Type = 'DWord' },
                @{KeyValueName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarGlomLevel'; PolicyType = 'User'; Data = '1'; Type = 'DWord' },
                @{KeyValueName = 'Software\Policies\Microsoft\Internet Explorer\Main\DisableFirstRunCustomize'; PolicyType = 'Machine'; Data = '1'; Type = 'DWord' }
            )

            # Blob copy with Managed Identity - Oauth2
            AZCOPYDSCDirPresentSource   = @(

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/PSModules/'
                    DestinationPath   = 'F:\Source\PSModules\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/Tools/'
                    DestinationPath   = 'F:\Source\Tools\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/OpenSSH-Win64/'
                    DestinationPath   = 'F:\Source\OpenSSH-Win64\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/GIT/'
                    DestinationPath   = 'F:\Source\GIT\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/EDGE/'
                    DestinationPath   = 'F:\Source\EDGE\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/PSCore/'
                    DestinationPath   = 'F:\Source\PSCore\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/DotNetCore/'
                    DestinationPath   = 'F:\Source\DotNetCore\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/VisualStudio/'
                    DestinationPath   = 'F:\Source\VisualStudio\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/RascalPro3/'
                    DestinationPath   = 'F:\Source\RascalPro3\'
                }
            )

            DirectoryPresentSource      = @(

                @{
                    SourcePath      = 'F:\Source\Tools\.vs-kubernetes\tools\'
                    DestinationPath = 'C:\Windows\System32\config\systemprofile\.vs-kubernetes\tools\'
                },

                @{
                    SourcePath      = 'F:\Source\PSModules\PackageManagement\'
                    DestinationPath = 'c:\program files\WindowsPowershell\Modules\PackageManagement\'
                },

                @{
                    SourcePath      = 'F:\Source\PSModules\PowerShellGet\'
                    DestinationPath = 'c:\program files\WindowsPowershell\Modules\PowerShellGet\'
                },

                @{
                    SourcePath      = 'F:\Source\Tools\profile.ps1'
                    DestinationPath = 'c:\program files\powershell\7\profile.ps1'
                }
            )

            SoftwarePackagePresent      = @(

                @{
                    Name      = 'Microsoft Visual Studio Code'
                    Path      = 'F:\Source\Tools\vscode\VSCodeSetup-x64-1.25.0.exe'
                    ProductId = ''
                    Arguments = '/silent /norestart'
                },

                @{
                    Name      = 'Microsoft Edge'
                    Path      = 'F:\Source\EDGE\MicrosoftEdgeEnterpriseX64.msi'
                    ProductId = '{1BAA23D8-D46C-3014-8E86-DF6C0762F71A}'
                    Arguments = ''
                },

                # use Azure Admin Center in portal instead, deployed via VM extensions
                # @{Name        = 'Windows Admin Center'
                #     Path      = 'F:\Source\Tools\WindowsAdminCenter1904.1.msi'
                #     ProductId = '{65E83844-8B8A-42ED-B78D-BA021BE4AE83}'
                #     Arguments = 'RESTART_WINRM=0 SME_PORT=443 SME_THUMBPRINT=215B3BBC1ABF37BF8D79541383374857A30F86F7 SSL_CERTIFICATE_OPTION=installed /L*v F:\adminCenterlog.txt'
                # },

                @{
                    Name      = 'Git version 2.23.0.windows.1'
                    Path      = 'F:\Source\GIT\Git-2.23.0-64-bit.exe'
                    ProductId = ''
                    Arguments = '/VERYSILENT'
                },

                @{
                    Name      = 'PowerShell 7-x64'
                    Path      = 'F:\Source\PSCore\PowerShell-7.0.3-win-x64.msi'
                    ProductId = '{05321FDB-BBA2-497D-99C6-C440E184C043}'
                    Arguments = 'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1'
                },

                @{
                    Name      = 'Microsoft .NET Core Toolset 3.1.200 (x64)'
                    Path      = 'F:\Source\DotNetCore\dotnet-sdk-3.1.200-win-x64.exe'
                    ProductId = ''
                    Arguments = '/Install /quiet /norestart /log "F:\Source\DotNetCore\install312.txt"'
                },

                @{
                    Name      = 'Microsoft .NET Runtime - 5.0.0 Preview 8 (x64)'
                    Path      = 'F:\Source\DotNetCore\dotnet-sdk-5.0.100-preview.8.20417.9-win-x64.exe'
                    ProductId = ''
                    Arguments = '/Install /quiet /norestart /log "F:\Source\DotNetCore\install50100.txt"'
                },

                @{  
                    Name      = 'Visual Studio Enterprise 2019'
                    Path      = 'F:\Source\VisualStudio\vs_enterprise__2032842161.1584647755.exe'
                    ProductId = ''
                    Arguments = '--installPath F:\VisualStudio\2019\Enterprise --addProductLang en-US  --includeRecommended --quiet --wait'
                }
            )
        }
    )
}
