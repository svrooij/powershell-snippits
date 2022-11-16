# --------------------------------------------------------------
# Creating a self-signed certificate for application access
# --------------------------------------------------------------

$certFriendlyName = "Unattended powershell m365";
$certSubject = "CN=powershell.invalid"

$cert = New-SelfSignedCertificate -NotAfter $(Get-Date).AddYears(1) -FriendlyName $certFriendlyName -CertStoreLocation cert:\CurrentUser\My -Subject $certSubject -KeyAlgorithm RSA -KeyLength 2048 -KeyExportPolicy NonExportable;

$cert | Format-list

$exportCert = "c:\temp\new-cert.crt"
Export-Certificate -Cert $cert -Type cer -FilePath $exportCert -Force