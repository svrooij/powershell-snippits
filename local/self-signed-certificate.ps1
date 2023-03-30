# --------------------------------------------------------------
# Creating a self-signed certificate for application access
# --------------------------------------------------------------

$certFriendlyName = "Unattended powershell m365";
$certSubject = "CN=powershell.invalid"
# See https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cryptoapi-cryptographic-service-providers
# or https://learn.microsoft.com/en-us/powershell/module/pki/new-selfsignedcertificate?view=windowsserver2019-ps#-provider
$certProvider = "Microsoft Enhanced RSA and AES Cryptographic Provider"

$cert = New-SelfSignedCertificate -NotAfter $(Get-Date).AddYears(1) -FriendlyName $certFriendlyName -CertStoreLocation cert:\CurrentUser\My -Subject $certSubject -KeyAlgorithm RSA -KeyLength 2048 -KeyExportPolicy NonExportable -Provider $certProvider;

$cert | Format-list

$exportCert = "c:\temp\new-cert.crt"
Export-Certificate -Cert $cert -Type cer -FilePath $exportCert -Force
