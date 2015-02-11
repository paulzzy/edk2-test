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
if {[info exist ENTS_EFI_BS_INC] == 1} {
  return
}
set ENTS_EFI_BS_INC 1

set EVT_TIMER                           0x80000000
set EVT_RUNTIME                         0x40000000
set EVT_RUNTIME_CONTEXT                 0x20000000
set EVT_NOTIFY_WAIT                     0x00000100
set EVT_NOTIFY_SIGNAL                   0x00000200
set EVT_SIGNAL_EXIT_BOOT_SERVICES       0x00000201
set EVT_SIGNAL_VIRTUAL_ADDRESS_CHANGE   0x60000202

set EFI_TPL_APPLICATION                 4
set EFI_TPL_DRIVER                      6
set EFI_TPL_CALLBACK                    8
set EFI_TPL_NOTIFY                      16
set EFI_TPL_HIGH_LEVEL                  31

Func BS->CreateEvent {
  UINT32
  UINTN
  UINTN
  POINTER
  POINTER
  POINTER
  }

Func BS->CloseEvent {
  UINTN
  POINTER
  }

Func BS->SignalEvent {
  UINTN
  POINTER
  }

Func BS->WaitForEvent {
  UINTN
  POINTER
  POINTER
  POINTER
  }

Func BS->CheckEvent {
  UINTN
  POINTER
  }

Func BS->SetTimer {
  UINTN
  UINTN
  UINT64
  POINTER
  }

Func BS->AllocatePages {
  UINTN
  UINTN
  UINTN
  POINTER
  POINTER
  }

Func BS->FreePages {
  UINTN
  UINTN
  POINTER
  }

Func BS->AllocatePool {
  UINTN
  UINTN
  POINTER
  POINTER
  }

Func BS->FreePool {
  POINTER
  POINTER
  }

Func BS->SetWatchdogTimer {
  UINTN
  UINT64
  UINTN
  POINTER
  POINTER
  }

Func BS->Stall {
  UINTN
  POINTER
  }

Func BS->CopyMem {
  POINTER
  POINTER
  UINTN
  POINTER
  }

Func BS->SetMem {
  POINTER
  UINTN
  UINT8
  POINTER
  }

