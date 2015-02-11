#
# The material contained herein is not a license, either      
# expressly or impliedly, to any intellectual property owned  
# or controlled by any of the authors or developers of this   
# material or to any contribution thereto. The material       
# contained herein is provided on an "AS IS" basis and, to the
# maximum extent permitted by applicable law, this information
# is provided AS IS AND WITH ALL FAULTS, and the authors and  
# developers of this material hereby disclaim all other       
# warranties and conditions, either express, implied or       
# statutory, including, but not limited to, any (if any)      
# implied warranties, duties or conditions of merchantability,
# of fitness for a particular purpose, of accuracy or         
# completeness of responses, of results, of workmanlike       
# effort, of lack of viruses and of lack of negligence, all   
# with regard to this material and any contribution thereto.  
# Designers must not rely on the absence or characteristics of
# any features or instructions marked "reserved" or           
# "undefined." The Unified EFI Forum, Inc. reserves any       
# features or instructions so marked for future definition and
# shall have no responsibility whatsoever for conflicts or    
# incompatibilities arising from future changes to them. ALSO,
# THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT,
# QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR          
# NON-INFRINGEMENT WITH REGARD TO THE TEST SUITE AND ANY      
# CONTRIBUTION THERETO.                                       
#                                                             
# IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THIS MATERIAL OR
# ANY CONTRIBUTION THERETO BE LIABLE TO ANY OTHER PARTY FOR   
# THE COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST    
# PROFITS, LOSS OF USE, LOSS OF DATA, OR ANY INCIDENTAL,      
# CONSEQUENTIAL, DIRECT, INDIRECT, OR SPECIAL DAMAGES WHETHER 
# UNDER CONTRACT, TORT, WARRANTY, OR OTHERWISE, ARISING IN ANY
# WAY OUT OF THIS OR ANY OTHER AGREEMENT RELATING TO THIS     
# DOCUMENT, WHETHER OR NOT SUCH PARTY HAD ADVANCE NOTICE OF   
# THE POSSIBILITY OF SUCH DAMAGES.                            
#                                                             
# Copyright 2006, 2007, 2008, 2009, 2010 Unified EFI, Inc. All
# Rights Reserved, subject to all existing rights in all      
# matters included within this Test Suite, to which United    
# EFI, Inc. makes no claim of right.                          
#                                                             
# Copyright (c) 2010, Intel Corporation. All rights reserved.<BR> 
#
#
################################################################################
CaseLevel         FUNCTION
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid        888AFE0F-4F5E-4976-9722-8E541B5B7173
CaseName        ReadDirectory.Func4.Case1
CaseCategory    MTFTP6
CaseDescription {Test ReadDirectory function of MTFTP6,invoke ReadDirectory() with a mtftp6  \
                 error packet received for synchronous calling. EFI_SUCCESS should be returned. 
                }
################################################################################

proc CleanUpEutEnvironment {} {

#
# Destroy Child 
#
Mtftp6ServiceBinding->DestroyChild "@R_Handle, &@R_Status"
GetAck

EUTClose

DestroyPacket
EndCapture
EndScope _MTFTP6_READDIRECTORY_FUNCTION4_CASE1_

#
# End Log
#
EndLog
}

Include MTFTP6/include/Mtftp6.inc.tcl
#
# Begin log ...
#
BeginLog

BeginScope _MTFTP6_READDIRECTORY_FUNCTION4_CASE1_

EUTSetup

UINTN                            R_Status
UINTN                            R_Handle

#
# Create child
#
Mtftp6ServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                      \
                "Mtftp6SB.CreateChild - Create Child 1"                       \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle

#
# Initialize the environment
#
set hostmac    [GetHostMac]
set targetmac  [GetTargetMac]
RemoteEther    $targetmac
LocalEther     $hostmac
set LocalIP    "2002::2"
set RemoteIp   "2002::4321"
LocalIPv6      $LocalIP
RemoteIPv6     $RemoteIp

#
# Check Point: Call Configure function with valid parameters. 
#              EFI_SUCCESS should be returned.
#
EFI_MTFTP6_CONFIG_DATA      R_CfgData
SetIpv6Address    R_CfgData.StationIp         "2002::4321" 
SetVar            R_CfgData.LocalPort         1780
SetIpv6Address    R_CfgData.ServerIp          "2002::2"
SetVar            R_CfgData.InitialServerPort 0
SetVar            R_CfgData.TryCount          3
SetVar            R_CfgData.TimeoutValue      3

Mtftp6->Configure "&@R_CfgData, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                 \
                "Mtftp6.Configure -conf- Call Configure with valid parameters"  \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Check Point: Call ReadDirectory with valid parameters for synchronous calling. \
#              EFI_SUCCESS should be returned.
# 
EFI_MTFTP6_TOKEN                             R_Token

SetVar R_Token.Status                        $EFI_SUCCESS
UINTN                                        R_NotifyContext
SetVar               R_NotifyContext         0
#
# Create an Event
#
BS->CreateEvent      "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_NotifyContext, &@R_Token.Event, &@R_Status"
GetAck
set assert           [VerifyReturnStatus  R_Status  $EFI_SUCCESS]
RecordAssertion      $assert          $GenericAssertionGuid           \
                     "BS->CreateEvent -Func- Create an Event "                  \
                     "ReturnStatus -$R_Status, ExpectedStatus -$EFI_SUCCESS"

SetVar         R_Token.OverrideData          0
CHAR8                                        R_NameOfFile(20)
SetVar         R_NameOfFile                  "Shell.efi"
SetVar         R_Token.Filename              &@R_NameOfFile
SetVar         R_Token.ModeStr               0
SetVar         R_Token.OptionCount           2
EFI_MTFTP6_OPTION                            R_OptionList(2)
CHAR8                                        R_OptionStr1(10)
CHAR8                                        R_OptionVal1(10)
SetVar         R_OptionStr1                  "blksize"
SetVar         R_OptionVal1                  "1024"
SetVar         R_OptionList(0).OptionStr     &@R_OptionStr1
SetVar         R_OptionList(0).ValueStr      &@R_OptionVal1
CHAR8                                        R_OptionStr2(10)
CHAR8                                        R_OptionVal2(10)
SetVar         R_OptionStr2                  "timeout"
SetVar         R_OptionVal2                  "2"
SetVar         R_OptionList(1).OptionStr     &@R_OptionStr2
SetVar         R_OptionList(1).ValueStr      &@R_OptionVal2
SetVar         R_Token.OptionList            &@R_OptionList
SetVar         R_Token.BufferSize            13
CHAR8          R_Buffer(30)
SetVar         R_Token.Buffer                &@R_Buffer
SetVar         R_Token.Context               NULL

#
# Start capture
#
set L_Filter "ether proto 0x86dd"
StartCapture CCB $L_Filter
Mtftp6->ReadDirectory "&@R_Token, 1, 4, 4, &@R_Status"
GetAck

ReceiveCcbPacket CCB Mtftp6Packet 10
if { ${CCB.received} == 0} {
#
# If have not captured the packet. Fail
#
set assert fail
RecordAssertion $assert $GenericAssertionGuid    \
                  "Mtftp6.ReadDirectory -Func- No packet received."

CleanUpEutEnvironment
return
}

#
# If have captured the packet. Server response with a normal OACK packet
# Need to set the option array as the following:
# set option_value_array(blksize) "1024"
# set option_value_len(blksize) 4
#
ParsePacket Mtftp6Packet -t udp -udp_sp client_port -udp_dp server_port
EndCapture
set client_prt $client_port

set option_value_array(blksize) "1024"
set option_value_len(blksize)   4
set option_value_array(timeout) "2"
set option_value_len(timeout)   1
SendPacket [ Mtftp6CreateOack $client_prt $EFI_MTFTP6_OPCODE_OACK]

#
# Capture the Ack for OACK
#
StartCapture CCB $L_Filter
ReceiveCcbPacket CCB TempPacket1 20
if { ${CCB.received} == 0} {
#
# If have not captured the packet. Fail
#
  set assert fail
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "Mtftp6.ReadDirectory - It should transfer a packet, but not."

  CleanUpEutEnvironment
  return
}

#
# If have captured the packet. Server response with a mtftp6 error packet
#
set client_port 1780
SendPacket [ Mtftp6CreateError $client_port]
Stall 5

set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $Mtftp6ReadDirectoryFunc4AssertionGuid001    \
                "Mtftp6.ReadDirectory -Func- Call ReadDirectory with valid parameters for synchronous calling"\
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

GetVar R_NotifyContext
set assert pass
if { $R_NotifyContext == 0} {
  set assert fail
} 
RecordAssertion $assert $$Mtftp6ReadDirectoryFunc4AssertionGuid002              \
                "If Token->Event be signaled,the value of R_NotifyContext should be changed."

GetVar R_Token.Status
set assert pass
if { ${R_Token.Status} != $EFI_TFTP_ERROR } {
   set assert fail
}
RecordAssertion $assert $$Mtftp6ReadDirectoryFunc4AssertionGuid003              \
                "When returned the Token.Status should be EFI_TFTP_ERROR."

CleanUpEutEnvironment