#!/bin/bash
#
#
#
#           Created by A.Hodgson                     
#            Date: 2021-11-17                            
#            Purpose: Create a default Prestage
#
#
#
#############################################################
# Just for fun
script_title="Electric Default PreStage Generator"
echo ""
echo ""
cat << "EOF"
          _ _,---._
       ,-','       `-.___
      /-;'               `._
     /\/          ._   _,'o \
    ( /\       _,--'\,','"`. )
     |\      ,'o     \'    //\
     |      \        /   ,--'""`-.
     :       \_    _/ ,-'         `-._
      \        `--'  /                )
       `.  \`._    ,'     ________,','
         .--`     ,'  ,--` __\___,;'
          \`.,-- ,' ,`_)--'  /`.,'
           \( ;  | | )      (`-/
             `--'| |)       |-/
               | | |        | |
               | | |,.,-.   | |_
               | `./ /   )---`  )
              _|  /    ,',   ,-'
             ,'|_(    /-<._,' |--,
             |    `--'---.     \/ \
             |          / \    /\  \
           ,-^---._     |  \  /  \  \
        ,-'        \----'   \/    \--`.
       /            \              \   \
EOF
echo "    $script_title!!!"
echo ""
echo ""
#############################################################
jSON_data="{\"keepExistingSiteMembership\": false,\
  \"enrollmentSiteId\": \"-1\",\
  \"id\": \"1\",\
  \"displayName\": \"Electric Standard Pre-stage\",\
  \"supportPhoneNumber\": \"For support please reach out to Electric via Slack\",\
  \"supportEmailAddress\": \"\",\
  \"department\": \"\",\
  \"mandatory\": true,\
  \"mdmRemovable\": false,\
  \"defaultPrestage\": true,\
  \"keepExistingLocationInformation\": false,\
  \"requireAuthentication\": false,\
  \"authenticationPrompt\": \"\",\
  \"profileUuid\": \"A762AA558C5BEAD4E7E2DCA3B2A13B3F\",\
  \"deviceEnrollmentProgramInstanceId\": \"1\",\
  \"versionLock\": 137,\
  \"siteId\": \"-1\",\
  \"skipSetupItems\": {\
    \"Biometric\": true,\
    \"FileVault\": false,\
    \"iCloudDiagnostics\": true,\
    \"Diagnostics\": true,\
    \"Accessibility\": false,\
    \"AppleID\": true,\
    \"ScreenTime\": true,\
    \"Siri\": true,\
    \"DisplayTone\": false,\
    \"Restore\": true,\
    \"Appearance\": false,\
    \"Privacy\": true,\
    \"Payment\": true,\
    \"Registration\": true,\
    \"TOS\": true,\
    \"iCloudStorage\": true,\
    \"Location\": false\
  },\
  \"locationInformation\": {\
    \"username\": \"\",\
    \"realname\": \"\",\
    \"phone\": \"\",\
    \"email\": \"\",\
    \"room\": \"\",\
    \"position\": \"\",\
    \"departmentId\": \"-1\",\
    \"buildingId\": \"-1\",\
    \"id\": \"1\",\
    \"versionLock\": 0\
  },\
  \"purchasingInformation\": {\
    \"id\": \"1\",\
    \"leased\": false,\
    \"purchased\": true,\
    \"appleCareId\": \"\",\
    \"poNumber\": \"\",\
    \"vendor\": \"\",\
    \"purchasePrice\": \"\",\
    \"lifeExpectancy\": 0,\
    \"purchasingAccount\": \"\",\
    \"purchasingContact\": \"\",\
    \"leaseDate\": \"1970-01-01\",\
    \"poDate\": \"1970-01-01\",\
    \"warrantyDate\": \"1970-01-01\",\
    \"versionLock\": 0\
  },\
  \"preventActivationLock\": false,\
  \"enableDeviceBasedActivationLock\": false,\
  \"anchorCertificates\": [],\
  \"enrollmentCustomizationId\": \"0\",\
  \"language\": \"\",\
  \"region\": \"\",\
  \"autoAdvanceSetup\": false,\
  \"customPackageIds\": [],\
  \"customPackageDistributionPointId\": \"-1\",\
  \"installProfilesDuringSetup\": false,\
  \"prestageInstalledProfileIds\": []\
}"

#############################################################
# Functions
#############################################################
function generateAuthToken() {
  
  # created base64-encoded credentials
  encodedCredentials=$( printf "$apiUser:$apiPass" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i - )
  
  # generate an auth token
  authToken=$( /usr/bin/curl "$instanceName/api/v1/auth/token" \
  --header 'Accept: application/json' \
  --silent \
  --request POST \
  --header "Authorization: Basic $encodedCredentials" )
  
  # parse authToken for token, omit expiration
  token=$(echo "$authToken" | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["token"])')

}

function apiResponse() #takes api response code variable
{
  if [ "$1" == "201" ] ; then
    echo "Success"
  else
    echo "Failed"
  fi
}

#############################################################
# Main 
#############################################################
read -r -p "Please enter a JAMF instance to take action on: " instanceName
read -r -p "Please enter a JAMF API administrator name: " apiUser
read -r -s -p "Please enter the password for the account: " apiPass

generateAuthToken
echo ""

response=$(curl --write-out "%{http_code}" -sk -X POST "$instanceName/api/v2/computer-prestages" -H "accept: application/json" -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$jSON_data")
responseStatus=${response: -3}
apiResponse "$responseStatus"
