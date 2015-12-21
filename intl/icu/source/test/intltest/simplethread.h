/********************************************************************
 * COPYRIGHT: 
 * Copyright (c) 1997-2015, International Business Machines Corporation and
 * others. All Rights Reserved.
 ********************************************************************/

#ifndef SIMPLETHREAD_H
#define SIMPLETHREAD_H

#include "mutex.h"

class U_EXPORT SimpleThread
{
  public:
    SimpleThread();
    virtual  ~SimpleThread();
    int32_t   start(void);        // start the thread. Return 0 if successfull.
    void      join();             // A thread must be joined before deleting its SimpleThread.

    virtual void run(void) = 0;   // Override this to provide the code to run
                                  //   in the thread.
  private:
    void *fImplementation;
};

#endif

