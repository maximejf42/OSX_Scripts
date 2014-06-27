#!/bin/sh
########################################################################################################
#
# Copyright (c) 2014, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
#
# DESCRIPTION
#   This script allows the end user of a machine to import their FileVault2 Recovory Key if the 
#	machine was encrypted before enrolled with the JSS.
#
#	This script displays a Message Box to the end user asking for their Individual FV2 Recovory Key.
#	Then creates the XML that will get uploaded to the JSS to set their FV2 key in the JSS.
#	This script was designed to be run through a Self Service Policy
#
#	You will need to create a FV2 config in the JSS and fill in the fv2id variable in this script. 
#
####################################################################################################
#
# HISTORY
#
#	Version 1.0
#  	Adapted by John Szaszvari, June 27th, 2014 
#
###################################################################################################

#ID of the FileVault2 Config in the JSS 
fv2id=1 

fullKey=$(osascript <<-EOF

tell application "Finder"
	set theText to display dialog "Please enter your FileVault2 Key provided by I.T" default answer ""
end tell

text returned of theText

EOF)


echo '<?xml version="1.0" encoding="UTF-8"?>' > /tmp/file_vault_2_id.xml
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> /tmp/file_vault_2_id.xml

echo '<plist version="1.0">' >> /tmp/file_vault_2_id.xml
echo '<dict>' >> /tmp/file_vault_2_id.xml

echo '	<key>FV2_ID</key>' >> /tmp/file_vault_2_id.xml
echo '	<string>'"$fv2id"'</string>' >> /tmp/file_vault_2_id.xml

echo '</dict>' >> /tmp/file_vault_2_id.xml
echo '</plist>' >> /tmp/file_vault_2_id.xml


echo '<?xml version="1.0" encoding="UTF-8"?>' > /tmp/file_vault_2_recovery_key.xml
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> /tmp/file_vault_2_recovery_key.xml

echo '<plist version="1.0">' >> /tmp/file_vault_2_recovery_key.xml
echo '<dict>' >> /tmp/file_vault_2_recovery_key.xml

echo '	<key>RecoveryKey</key>' >> /tmp/file_vault_2_recovery_key.xml
echo '	<string>'"$fullKey"'</string>' >> /tmp/file_vault_2_recovery_key.xml

echo '</dict>' >> /tmp/file_vault_2_recovery_key.xml
echo '</plist>' >> /tmp/file_vault_2_recovery_key.xml

/bin/mv /tmp/file_vault_2_* /Library/Application\ Support/JAMF/