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

    /*
    static unsigned char left_side_speed = 255;
    static unsigned char right_side_speed = 255;
    
   

    

    unsigned char msg2[14] = {MSGID_SENSOR_REQUEST,0xff,0xff,0xfe,0xfe,0xaa,0xff,0xff,0xfe,0xfe,0xaa,0x11,0x33,0x45};

    unsigned char msg3[14];
    msg3[0] = MSGID_MOVE;
    msg3[1] = left_side_speed++;
    msg3[2] = right_side_speed++;
    unsigned char msg4[14] = {MSGID_SENSOR_REQUEST,0xa9,0xa9,0xa9,0xa9,0xa9,0xff,0xff,0xfe,0xfe,0xaa,0x11,0x33,0x45};


    
    //send_uart_message( msg2 );

    
    i2c_master_send(14, msg2);
    i2c_master_send(14, msg3);
    i2c_master_send(14, msg4);
    */
    
    
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