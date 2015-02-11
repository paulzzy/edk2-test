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

#
# test case Name, category, description, GUID...
#
CaseGuid          BAE14BF6-66EF-4d7e-87AC-97B82F0F306C
CaseName          Cancel.Func1.Case5
CaseCategory      TCP
CaseDescription   {This item is to test the [EUT] correctly cancel the pending \
                   asynchronous requests by specifying the Token with NULL.}
################################################################################

Include TCP4/include/Tcp4.inc.tcl

proc CleanUpEutEnvironment {} {
  global RST
 
  UpdateTcpSendBuffer TCB -c $RST
  SendTcpPacket TCB
 
  DestroyTcb
  DelEntryInArpCache

  Tcp4ServiceBinding->DestroyChild "@R_Tcp4Handle, &@R_Status"
  GetAck
 
  EndLogPacket
  EndScope _TCP4_RFC_COMPATIBILITY_
  EndLog
}

#
# Begin log ...
#
BeginLog

#
# BeginScope on OS.
#
BeginScope _TCP4_RFC_COMPATIBILITY_

BeginLogPacket Cancel.Func1.Case5      "host $DEF_EUT_IP_ADDR and host         \
                                             $DEF_ENTS_IP_ADDR"

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
set    L_FragmentLength1         1024
set    L_FragmentLength2         1024

UINTN                            R_Status
UINTN                            R_Tcp4Handle
UINTN                            R_Context

UINTN                            TempStatus

EFI_TCP4_ACCESS_POINT            R_Configure_AccessPoint
EFI_TCP4_CONFIG_DATA             R_Configure_Tcp4ConfigData

EFI_TCP4_COMPLETION_TOKEN        R_Accept_CompletionToken
EFI_TCP4_LISTEN_TOKEN            R_Accept_ListenToken
UINTN                            R_Accept_NewChildHandle

EFI_TCP4_IO_TOKEN                R_Receive_IOToken1
EFI_TCP4_COMPLETION_TOKEN        R_Receive_CompletionToken1
EFI_TCP4_IO_TOKEN                R_Receive_IOToken2
EFI_TCP4_COMPLETION_TOKEN        R_Receive_CompletionToken2

Packet                           R_Packet_Buffer1
EFI_TCP4_RECEIVE_DATA            R_RxData1
EFI_TCP4_FRAGMENT_DATA           R_FragmentTable1
CHAR8                            R_FragmentBuffer1($L_FragmentLength1)
Packet                           R_Packet_Buffer2
EFI_TCP4_RECEIVE_DATA            R_RxData2
EFI_TCP4_FRAGMENT_DATA           R_FragmentTable2
CHAR8                            R_FragmentBuffer2($L_FragmentLength2)

POINTER                          R_Cancel_Token

#
# Initialization of TCB related on OS side.
#
CreateTcb TCB $DEF_ENTS_IP_ADDR $DEF_ENTS_PRT $DEF_EUT_IP_ADDR $DEF_EUT_PRT

LocalEther  $DEF_ENTS_MAC_ADDR
RemoteEther $DEF_EUT_MAC_ADDR
LocalIp     $DEF_ENTS_IP_ADDR
RemoteIp    $DEF_EUT_IP_ADDR

#
# Add an entry in ARP cache.
#
AddEntryInArpCache

#
# Create Tcp4 Child.
#
Tcp4ServiceBinding->CreateChild "&@R_Tcp4Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Tcp4Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4SBP.CreateChild - Create Child 1"                         \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Configure TCP instance.
#
SetVar R_Configure_AccessPoint.UseDefaultAddress      FALSE
SetIpv4Address R_Configure_AccessPoint.StationAddress $DEF_EUT_IP_ADDR
SetIpv4Address R_Configure_AccessPoint.SubnetMask     $DEF_EUT_MASK
SetVar R_Configure_AccessPoint.StationPort            $DEF_EUT_PRT
SetIpv4Address R_Configure_AccessPoint.RemoteAddress  0
SetVar R_Configure_AccessPoint.RemotePort             0
SetVar R_Configure_AccessPoint.ActiveFlag             FALSE

SetVar R_Configure_Tcp4ConfigData.TypeOfService       0
SetVar R_Configure_Tcp4ConfigData.TimeToLive          128
SetVar R_Configure_Tcp4ConfigData.AccessPoint         @R_Configure_AccessPoint
SetVar R_Configure_Tcp4ConfigData.ControlOption       0

Tcp4->Configure {&@R_Configure_Tcp4ConfigData, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4.Configure - Configure Child 1."                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Call Tcp4.Accept for a passive TCP instance.
#
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context,        \
                 &@R_Accept_CompletionToken.Event, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid  "BS.CreateEvent."               \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_Accept_NewChildHandle 0
SetVar R_Accept_ListenToken.CompletionToken @R_Accept_CompletionToken
SetVar R_Accept_ListenToken.CompletionToken.Status $EFI_INCOMPATIBLE_VERSION

Tcp4->Accept {&@R_Accept_ListenToken, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4.Accept - Open an passive connection."                    \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Handles the three-way handshake.
#
UpdateTcpSendBuffer TCB -c $SYN
SendTcpPacket TCB

ReceiveTcpPacket TCB 5

UpdateTcpSendBuffer TCB -c $ACK
SendTcpPacket TCB

#
# Check the Token.Status to verify the connection has been established.
#
while {1 > 0} {
  Stall 1
  GetVar R_Accept_ListenToken.CompletionToken.Status
 
  if { ${R_Accept_ListenToken.CompletionToken.Status} != $EFI_INCOMPATIBLE_VERSION} {
    if { ${R_Accept_ListenToken.CompletionToken.Status} != $EFI_SUCCESS} {
      set assert fail
      puts "Three-way handshake for passive connection failed."
      RecordAssertion $assert $GenericAssertionGuid                            \
                      "Three-way handshake for passive connection failed."     \
      "ReturnStatus - ${R_Accept_ListenToken.CompletionToken.Status}, ExpectedStatus - $EFI_SUCCESS"
      BS->CloseEvent "@R_Accept_CompletionToken.Event, &@R_Status"
      GetAck
      CleanUpEutEnvironment
      return
    } else {
      break
    }
  }
}

#
# Get the NewChildHandle value.
#
GetVar R_Accept_ListenToken.NewChildHandle
SetVar R_Accept_NewChildHandle ${R_Accept_ListenToken.NewChildHandle}
SetVar [subst $ENTS_CUR_CHILD]  @R_Accept_NewChildHandle

#
# Put a receive request token to receive data from the OS.
#
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context,        \
                 &@R_Receive_CompletionToken1.Event, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid   "BS.CreateEvent."              \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_FragmentTable1.FragmentLength     $L_FragmentLength1
SetVar R_FragmentTable1.FragmentBuffer     &@R_FragmentBuffer1
SetVar R_RxData1.FragmentTable(0)          @R_FragmentTable1
SetVar R_RxData1.DataLength                $L_FragmentLength1
SetVar R_RxData1.FragmentCount             1

SetVar R_Packet_Buffer1.RxData             &@R_RxData1

SetVar R_Receive_IOToken1.CompletionToken  @R_Receive_CompletionToken1
SetVar R_Receive_IOToken1.CompletionToken.Status $EFI_INCOMPATIBLE_VERSION
SetVar R_Receive_IOToken1.Packet_Buffer    @R_Packet_Buffer1

BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context,        \
                 &@R_Receive_CompletionToken2.Event, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid   "BS.CreateEvent."              \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_FragmentTable2.FragmentLength     $L_FragmentLength2
SetVar R_FragmentTable2.FragmentBuffer     &@R_FragmentBuffer2
SetVar R_RxData2.FragmentTable(0)          @R_FragmentTable2
SetVar R_RxData2.DataLength                $L_FragmentLength2
SetVar R_RxData2.FragmentCount             1

SetVar R_Packet_Buffer2.RxData             &@R_RxData2

SetVar R_Receive_IOToken2.CompletionToken  @R_Receive_CompletionToken2
SetVar R_Receive_IOToken2.CompletionToken.Status $EFI_INCOMPATIBLE_VERSION
SetVar R_Receive_IOToken2.Packet_Buffer    @R_Packet_Buffer2

Tcp4->Receive {&@R_Receive_IOToken1, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid "Tcp4.Receive - Receive data1."  \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

Tcp4->Receive {&@R_Receive_IOToken2, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid "Tcp4.Receive - Receive data2."  \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Abort the asynchronous receive request.
#
Tcp4->Cancel {NULL, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4.Cancel - Cancel an asynchronous receive request."        \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

set TempStatus $R_Status

while {1 > 0} {
  Stall 1
  GetVar R_Receive_IOToken1.CompletionToken.Status
  GetVar R_Receive_IOToken2.CompletionToken.Status
 
  if { $TempStatus != $EFI_SUCCESS }   {
  set assert fail
  RecordAssertion $assert $Tcp4CancelFunc1AssertionGuid005                     \
                  "Tcp4.Cancel - Call Cancel() with the token being NULL       \
                  to abort an asynchronous receive request."                   \
                  "ReturnStatus - $TempStatus, ExpectedStatus - $EFI_SUCCESS"
  BS->CloseEvent "@R_Accept_CompletionToken.Event, &@R_Status"
  GetAck
  BS->CloseEvent "@R_Receive_CompletionToken1.Event, &@R_Status"
  GetAck
  BS->CloseEvent "@R_Receive_CompletionToken2.Event, &@R_Status"
  GetAck
  CleanUpEutEnvironment
  return
  } else {
 
  if { ${R_Receive_IOToken1.CompletionToken.Status} != $EFI_INCOMPATIBLE_VERSION
  	  & ${R_Receive_IOToken2.CompletionToken.Status} != $EFI_INCOMPATIBLE_VERSION} {
 
    if { ${R_Receive_IOToken1.CompletionToken.Status} != $EFI_ABORTED
    	  & ${R_Receive_IOToken2.CompletionToken.Status} != $EFI_ABORTED} {
 
      set assert fail
      RecordAssertion $assert $Tcp4CancelFunc1AssertionGuid005                 \
                  "Tcp4.Cancel - Call Cancel() with the token being NULL       \
                  to abort an asynchronous receive request."                   \
      "ReturnStatus - ${R_Receive_IOToken1.CompletionToken.Status},            \
      ExpectedStatus - $EFI_ABORTED"
      BS->CloseEvent "@R_Accept_CompletionToken.Event, &@R_Status"
      GetAck
      BS->CloseEvent "@R_Receive_CompletionToken1.Event, &@R_Status"
      GetAck
      BS->CloseEvent "@R_Receive_CompletionToken2.Event, &@R_Status"
      GetAck
      CleanUpEutEnvironment
      return
    } else {
      set assert pass
      RecordAssertion $assert $Tcp4CancelFunc1AssertionGuid005                 \
                  "Tcp4.Cancel - Call Cancel() with the token being NULL       \
                  to abort an asynchronous receive request."                   \
      "ReturnStatus - ${R_Receive_IOToken1.CompletionToken.Status},            \
      ExpectedStatus - $EFI_ABORTED"
      break
    }
  }
 }
}

#while {1 > 0} {
#  Stall 1
#  GetVar R_Receive_IOToken2.CompletionToken.Status
#
#  if { ${R_Receive_IOToken2.CompletionToken.Status} != $EFI_INCOMPATIBLE_VERSION} {
#    if { ${R_Receive_IOToken2.CompletionToken.Status} != $EFI_ABORTED} {
#      set assert fail
#      RecordAssertion $assert $GenericAssertionGuid                            \
#                      "Abort the asynchronous receive request failed."         \
#      "ReturnStatus - ${R_Receive_IOToken2.CompletionToken.Status},            \
#      ExpectedStatus - $EFI_ABORTED"
#      CleanUpEutEnvironment
#      return
#    } else {
#      set assert pass
#      RecordAssertion $assert $GenericAssertionGuid                            \
#                      "Abort the receive request successfully."                \
#      "ReturnStatus - ${R_Receive_IOToken2.CompletionToken.Status},            \
#      ExpectedStatus - $EFI_ABORTED"
#      break
#    }
#  }
#}


#
# Clean up the environment on EUT side.
#
BS->CloseEvent "@R_Accept_CompletionToken.Event, &@R_Status"
GetAck
BS->CloseEvent "@R_Receive_CompletionToken1.Event, &@R_Status"
GetAck
BS->CloseEvent "@R_Receive_CompletionToken2.Event, &@R_Status"
GetAck
CleanUpEutEnvironment