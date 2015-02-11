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
CaseLevel         CONFORMANCE
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid         30E5FC98-EE97-46f6-B2EA-ACD722B196D9
CaseName         DestroyChild.Conf1.Case1
CaseCategory     IP6
CaseDescription  {Test the DestroyChild Conformance of IP6 - Invoke DestroyChild() \
	              with ChildHandle being NULL. EFI_INVALID_PARAMETER should be returned.}
################################################################################

Include IP6/include/Ip6.inc.tcl

#
# Begin log...
#
BeginLog
#
# BeginScope
#
BeginScope        _IP6_DESTROYCHILD_CONFORMANCE1_CASE1_

#
#Parameter definition
#R_ represents "Remote EFI Side Parameter"
#L- represents "Local OS Side Parameter"
#
UINTN                        R_Status

#
#Check point:Call DestroyChild Function when the child handle is NULL.EFI_INVALID_PARAMETER should be returned.
#
Ip6ServiceBinding->DestroyChild "0, &@R_Status"
GetAck
set assert      [VerifyReturnStatus R_Status $EFI_INVALID_PARAMETER]
RecordAssertion $assert $Ip6DestroyChildConf1AssertionGuid001                   \
                "Ip6SBP.DestroyChild-Conf-With NULL child handle"                \
				"ReturnStatus-$R_Status, ExpectedStatus-$EFI_INVALID_PARAMETER"
				
#
# EndScope
#
EndScope        _IP6_DESTROYCHILD_CONFORMANCE1_CASE1_
#
# End Log
#
EndLog


