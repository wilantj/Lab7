<#
    PowerShell Lab 7
    Manipulate users, ous, groups, and group membership
    Date: 04/13/2020, week 13
    Created by: Anthony Will
#>

cls

$Choice = Read-Host "Choose form the following Menu Items
      A. VIEW one OU`t`t`t   B. VIEW all OUs 
      C. VIEW one group`t`t`t   D. VIEW all groups 
      E.VIEW one user`t`t       F. VIEW all users`n

    G. CREATE one OU`t`t        H. CREATE one group
    I. CREATE one user`t`t      J. CREATE user from csv file
   
    K. ADD user to group`t       L. REMOVE user form group
    M. DELETE one group`t        N. DELETE one user
       


  "



write-host "Enter anything other than A - N to quit"


If ($Choice -eq "A") {
    
    $OUA = Read-host "What is the name of the OU?"
    Get-ADOrganizationalUnit -filter "name -like'$OUA'" -properties Name, DistinguishedName
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "B") {
    
    Get-AdOrganizationalUnit -Filter * -properties *|format-table -property Name, DistinguishedName
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "C") {
    
    $groupC = Read-host "What is the name of the Group?"
    Get-AdGroup -filter "name -like '$groupC'" |format-table -property Name, GroupScope, GroupCategory
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "D") {
    
    Get-AdGroup -filter *  -properties Name, GroupScope, GroupCategory|format-table Name,Groupscope,GroupCategory
    Read-Host "Press enter to continue..."
    }
ElseIf ($choice -eq "E") {
    
    $UserE = Read-host "What is the name of the User?"
    Get-AdUser -filter "name -like'$UserE'"|format-table -property Name, DistinguishedName
    Read-Host "Press enter to continue..."
    }
ElseIf ($choice -eq "F") {
    
    Get-AdUser -filter * |format-table -property Name, DistinguishedName, GivenName, surName
    Read-Host "Press enter to continue..."
    }
ElseIf ($choice -eq "G") {
    
    $OUg = Read-host "What is the name of the OU you want to create?"
    new-AdOrganizationalUnit -name $Oug
    Get-AdOrganizationalUnit -filter "name -like'$OUg'" -properties Name, DistinguishedName
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "H") {
    'Item H chosen'
    $GroupH = Read-host "What is the name of the Group you want to create?"
    new-AdGroup -name $GroupH -GroupScope Global -GroupCategory Security
    Get-AdGroup -filter "name -like'$GroupH'"|format-table -property Name, GroupScope, GroupCategory
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "I") {
    
    $UserI = Read-host "What is the name of the User you want to create?"
    $FirstName = Read-host "what is the first name?"
    $LastName = Read-host "what is the Last name?"
    $StreetAddress = Read-Host "What is the Street Address?"
    $City = Read-Host "What is the City?"
    $State = Read-Host "What is the State?"
    $PostalCode = Read-Host "What is the Postal Code?"
    $Organization = Read-Host "What is the Organization Name?"
    $Office = Read-Host "What is the Office Name?"
   
    $Where = Read-Host "Should this user to go in A.  User Container, or B. OU?"
    If ($Where -eq "A") {
        'Item A chosen'
        $Path = "CN=Users, DC=Midterm, DC=Com"
        }
    Elseif($Where -eq "B") {
        'Item B chosen'
        $P = Read-Host "which OU?"
        $Path = "OU=$P, DC=Midterm, DC=Com"
        }
        $password= (convertto-securestring -string "Password01" -asplaintext -force)
        
    
    new-ADUser -name $userI -SamAccountName $UserI -UserPrincipalName $UserI -GivenName $FirstName -Surname $LastName -StreetAddress $StreetAddress -City $City -State $State -PostalCode $PostalCode -Organization $Organization -Office $Office -Path $Path -AccountPassword $password -Enabled $True
    Get-ADUser -filter "name -like'$UserI'" -properties *| Format-List -property Name, SAMAccountName, UserPrincipalName, GivenName, Surname, StreetAddress, City, State, PostalCode, Organization, Office
    Read-Host "Press enter to continue..."
    }




ElseIf ($Choice -eq "J") {
   $CSVJ= read-host "what is the name of the CSV file?"
   $pass= read-host "What password do you wanna use for the users?"
   $psw= (ConvertTo-SecureString -String "$pass" -AsPlainText -Force)
   $users = import-csv -path C:\Users\Administrator\desktop\$CSVJ
   $users | New-ADUser -AccountPassword $psw -Enabled $true
   Get-ADUser "name -like'G'" |Format-List -Property Name, SAMAccountName,UserPrincipalName,Firstname,Lastname,City,State,Zipcode,Company,Division
    }




ElseIf ($Choice -eq "K") {
    
    $GroupK = Read-host "What is the name of the Group that will gain a user?"
    $username = Read-host "What is the name of the user that will be added to this group?"
    add-ADgroupmember -Identity $groupK -members $username
    Get-AdGroupmember -Identity $groupK |format-table -property Name, SamAccountName, DistinguishedName
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "L") {
    'Item L chosen'
    $GroupL = Read-host "What is the name of the Group that will lose a user?"
    Get-AdGroupmember -Identity $groupL |format-table -property Name, SamAccountName, DistinguishedName
    $ChoiceUser=Read-host "Is one of these users the user to be removed? (Y or N)"
        If ($ChoiceUser -eq "Y") {
        $username = Read-host "What is the name of the user that will be removed from this group?"
        remove-ADGroupmember -Identity $groupL -Members $username 
        Read-Host "Press enter to continue..."
        }
        Elseif($ChoiceUser -eq "N") {
        Read-host "Please start over and pick the correct group."
        }
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "M") {
   
    $GroupM = Read-host "What is the name of the Group you want to delete?"
    Remove-ADGroup -name $GroupM
    Get-AdGroup -filter "name -like'$GroupM'" -properties Name,groupscope,groupcategory
    Read-Host "Press enter to continue..."
    }
ElseIf ($Choice -eq "N") {
    'Item N chosen'
    $UserN = Read-host "What is the name of the User to be deleated?"
    Remove-AdUser -name $UserN
    Get-ADUser -filter "name -like'$UserN" |format-table -property 
    Read-Host "Press enter to continue..."
    }

   