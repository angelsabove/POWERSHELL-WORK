# import AD module
Import-Module ActiveDirectory

# specify csv file path
$file = "importCSV.csv"

# import csv file
$users = Import-Csv $file

#FOR LOOP TO DETERMINE HOW MANY USERS
ForEach($user in $users) {

# input user information
$name = $user.Name
$givenname = $user.GivenName
$surname = $user.Surname
$password = $user.Password
$homedrive = $user.HomeDrive
$displayname = $user.DisplayName
$fullName = $user.SamAccountName
$building = $user.building

If ($buiding -eq "3") {
    $HomeDirectoryPartTwo = "\\student\3rdGrade$\"
    $script = "3rdGrade.bat"
    $ou_path = "OU=3rdGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "4") {
    $HomeDirectoryPartTwo = "\\student\4thGrade$\"
     $script = "4thGrade.bat"
     $ou_path = "OU=4thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "5") {
    $HomeDirectoryPartTwo = "\\student\5thGrade$\"
     $script = "5thGrade.bat"
     $ou_path = "OU=5thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "6") {
    $HomeDirectoryPartTwo = "\\student\6thGrade$\"
     $script = "6thGrade.bat"
     $ou_path = "OU=6thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "7") {
    $HomeDirectoryPartTwo = "\\student\7thGrade$\"
     $script = "7thGrade.bat"
     $ou_path = "OU=7thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "8") {
    $HomeDirectoryPartTwo = "\\student\8thGrade$\"
     $script = "8thGrade.bat"
     $ou_path = "OU=8thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "9") {
    $HomeDirectoryPartTwo = "\\student\9thGrade$\"
     $script = "9thGrade.bat"
     $ou_path = "OU=9thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "10") {
    $HomeDirectoryPartTwo = "\\student\10thGrade$\"
     $script = "10thGrade.bat"
     $ou_path = "OU=10thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "11") {
    $HomeDirectoryPartTwo = "\\student\11thGrade$\"
     $script = "11thGrade.bat"
     $ou_path = "OU=11thGrade,OU=Students,DC=vv,DC=local"
} ElseIf ($building -eq "12") {
    $HomeDirectoryPartTwo = "\\student\12thGrade$\"
     $script = "12thGrade.bat"
     $ou_path = "OU=12thGrade,OU=Students,DC=vv,DC=local"
} Else {
    "ERROR!!"
}

$HomeDirectoryPutTogether = $HomeDirectoryPartTwo + $fullName

#Create Home Folder
New-Item -ItemType directory -Path $HomeDirectoryPutTogether

# convert password to secure password
$secure_password = ConvertTo-SecureString $password -AsPlainText -Force

# create ad account
New-ADUser -Name "$givenname$surname" -GivenName $givenname `
-Surname $surname -UserPrincipalName ("$name$surname" + "@vv.local") -Path $ou_path `
-AccountPassword $secure_password -ChangePasswordAtLogon $true -Enabled $true `
-displayName $displayname `
-HomeDirectory $HomeDirectoryPutTogether -HomeDrive $homedrive -ScriptPath $script

#join to object group so it can map drives
Add-ADGroupMember -Identity Faculty -Members $fullName

#DEFINE PERMISSIONS
$path = "$HomeDirectoryPutTogether" #Replace with whatever file you want to do this to.
$user = "VV\$fullName" #User account to grant permisions too.
$Rights = "FullControl" #Comma seperated list.
$InheritSettings = "Containerinherit, ObjectInherit" #Controls how permissions are inherited by children
$PropogationSettings = "None" #Usually set to none but can setup rules that only apply to children.
$RuleType = "Allow" #Allow or Deny.

#ENABLE PERMISSIONS
$acl = Get-Acl $path
$perm = $user, $Rights, $InheritSettings, $PropogationSettings, $RuleType
$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path $path

}
