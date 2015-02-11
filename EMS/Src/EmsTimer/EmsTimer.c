/*++
  The material contained herein is not a license, either        
  expressly or impliedly, to any intellectual property owned    
  or controlled by any of the authors or developers of this     
  material or to any contribution thereto. The material         
  contained herein is provided on an "AS IS" basis and, to the  
  maximum extent permitted by applicable law, this information  
  is provided AS IS AND WITH ALL FAULTS, and the authors and    
  developers of this material hereby disclaim all other         
  warranties and conditions, either express, implied or         
  statutory, including, but not limited to, any (if any)        
  implied warranties, duties or conditions of merchantability,  
  of fitness for a particular purpose, of accuracy or           
  completeness of responses, of results, of workmanlike         
  effort, of lack of viruses and of lack of negligence, all     
  with regard to this material and any contribution thereto.    
  Designers must not rely on the absence or characteristics of  
  any features or instructions marked "reserved" or             
  "undefined." The Unified EFI Forum, Inc. reserves any         
  features or instructions so marked for future definition and  
  shall have no responsibility whatsoever for conflicts or      
  incompatibilities arising from future changes to them. ALSO,  
  THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT,  
  QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR            
  NON-INFRINGEMENT WITH REGARD TO THE TEST SUITE AND ANY        
  CONTRIBUTION THERETO.                                         
                                                                
  IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THIS MATERIAL OR  
  ANY CONTRIBUTION THERETO BE LIABLE TO ANY OTHER PARTY FOR     
  THE COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST      
  PROFITS, LOSS OF USE, LOSS OF DATA, OR ANY INCIDENTAL,        
  CONSEQUENTIAL, DIRECT, INDIRECT, OR SPECIAL DAMAGES WHETHER   
  UNDER CONTRACT, TORT, WARRANTY, OR OTHERWISE, ARISING IN ANY  
  WAY OUT OF THIS OR ANY OTHER AGREEMENT RELATING TO THIS       
  DOCUMENT, WHETHER OR NOT SUCH PARTY HAD ADVANCE NOTICE OF     
  THE POSSIBILITY OF SUCH DAMAGES.                              
                                                                
  Copyright 2006, 2007, 2008, 2009, 2010 Unified EFI, Inc. All  
  Rights Reserved, subject to all existing rights in all        
  matters included within this Test Suite, to which United      
  EFI, Inc. makes no claim of right.                            
                                                                
  Copyright (c) 2010, Intel Corporation. All rights reserved.<BR>   
   
--*/
/*++

Module Name:
  
    EmsTimer.c
    
Abstract:

  Implementation of EMS Timer functions

--*/

#include <windows.h>
#include "EmsTimer.h"

STATIC
DWORD
WINAPI
EmsTimerThread (
  LPVOID Arg
  )
/*++

Routine Description:

  The thread of EMS timer to wait and do callback function

Arguments:

  Arg - The parameter of callback function

Returns:

  0

--*/
{
  EmsTimer  *Timer;

  Timer = (EmsTimer *) Arg;
  Sleep (Timer->Timeout);
  if (Timer->TimerValid == TRUE) {
    (Timer->Func) (Timer->Arg);
  }

  free (Timer);
  return 0;
}

VOID
EmsDelTimer (
  EmsTimer *Timer
  )
/*++

Routine Description:

  The implementation of deleting an EMS timer

Arguments:

  Timer - The EMS timer to be deleted

Returns:

  None

--*/
{
  Timer->TimerValid = FALSE;
}

EmsTimer *
EmsSetTimer (
  UINT32     Timeout,
  VOID (*HandleTimeout) (VOID *),
  VOID *Arg
  )
/*++

Routine Description:

  The implementation of creating an EMS timer

Arguments:

  Timeout        - The maximum seconds the timer will wait
  HandleTimeout  - The callback function if timer timeout
  Arg            - The parameter of callback function

Returns:

  The new EMS timer

--*/
{
  DWORD     ThreadId;
  EmsTimer  *Timer;

  if (NULL == (Timer = (EmsTimer *) malloc (sizeof (EmsTimer)))) {
    printf ("EmsSetTimer malloc EmsTimer Error\n");
    exit (-1);
  }

  Timer->Func       = HandleTimeout;
  Timer->Arg        = Arg;
  Timer->TimerValid = TRUE;
  Timer->Timeout    = Timeout;

  if (CreateThread (NULL, 0, EmsTimerThread, (LPVOID) Timer, 0, &ThreadId) == NULL) {
    printf ("EmsSetTimer CreateThread Error\n");
    exit (-1);
  }

  return Timer;
}
