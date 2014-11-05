#include "maindefs.h"
#include <stdio.h>
#include "messages.h"
#include "timer1_thread.h"




void init_timer1_lthread(timer1_thread_struct *tptr) {
    tptr->msgcount = 0;
}

// This is a "logical" thread that processes messages from TIMER1
// It is not a "real" thread because there is only the single main thread
// of execution on the PIC because we are not using an RTOS.

int timer1_lthread(timer1_thread_struct *tptr, int msgtype, int length, unsigned char *msgbuffer) {
    signed char retval;
    blink0();

    unsigned char i2c_msg[14];
    i2c_msg[0]=MSGID_SENSOR_REQUEST;

    i2c_master_send(14,i2c_msg);

    static unsigned char move_counter = 0;

    if( tptr->new_move_msg )
    {
        tptr->new_move_msg = 0;
        move_counter = tptr->move_msg[4];
    }

    if( move_counter != 0 )
    {
        i2c_master_send(14,tptr->move_msg);
        move_counter--;
    }
    else
    {
        tptr->move_msg[0]=MSGID_MOVE;
        tptr->move_msg[1]=0;
        tptr->move_msg[2]=0;
        i2c_master_send(14,tptr->move_msg);
    }

   
    i2c_msg[0]=MSGID_MOTOR_REQUEST;

    i2c_master_send(14,i2c_msg);
    
    
    tptr->msgcount++;
    // Every tenth message we get from timer1 we
    // send something to the High Priority Interrupt
    if ((tptr->msgcount % 10) == 9) {
        retval = FromMainHigh_sendmsg(sizeof (tptr->msgcount), MSGT_MAIN1, (void *) &(tptr->msgcount));
        if (retval < 0) {
            // We would handle the error here
        }
    }
    
}