#include "maindefs.h"
#include <stdio.h>
#include "messages.h"
#include "timer1_thread.h"
#include "debug.h"
#include "my_uart.h"

void init_timer1_lthread(timer1_thread_struct *tptr) {
    tptr->msgcount = 0;
}

// This is a "logical" thread that processes messages from TIMER1
// It is not a "real" thread because there is only the single main thread
// of execution on the PIC because we are not using an RTOS.

int timer1_lthread(timer1_thread_struct *tptr, int msgtype, int length, unsigned char *msgbuffer) {
    signed char retval;
	
    blink0();	//Make LED0 blink

    static unsigned char move_time = 40;

    unsigned char move_msg[UART_DATA_LENGTH];
    move_msg[0] = MSGID_MOVE;
  

    #define FORWARD     0x00
    #define BACKWARD    0x01
    #define TURN_LEFT   0x02
    #define TURN_RIGHT  0x03
    #define STOP        0x04

    static unsigned char move_state = FORWARD;
    switch(move_state)
    {
        case FORWARD:
        {
           move_msg[1] = 127;
           move_msg[2] = 127;

           send_uart_message( move_msg );

           move_time--;

           if(move_time==0)
           {
                move_time = 40;
                move_state = BACKWARD;
           }
           break;
        }
        case BACKWARD:
        {
            move_msg[1] = (unsigned char)-128;
            move_msg[2] = (unsigned char)-128;

            send_uart_message( move_msg );

           move_time--;

           if(move_time==0)
           {
                move_time = 40;
                move_state = TURN_LEFT;
           }
           break;
        }
        case TURN_LEFT:
        {
            move_msg[1] = (unsigned char)-128;
            move_msg[2] = 127;

            send_uart_message( move_msg );

            move_time--;

            if(move_time==0)
            {
                move_time = 40;
                move_state = TURN_RIGHT;
            }
            break;
        }
        case TURN_RIGHT:
        {
            move_msg[1] = 127;
            move_msg[2] = (unsigned char)-128;
            send_uart_message( move_msg );

            move_time--;

            if(move_time==0)
            {
                move_time = 40;
                move_state = STOP;
            }
            break;
        }
        case STOP:
        {
            move_msg[1] = 0;
            move_msg[2] = 0;
            send_uart_message( move_msg );

            move_time--;

            if(move_time==0)
            {
                move_time = 40;
                move_state = FORWARD;
            }
            break;
        }
        default:
        {
            move_time = 40;
            move_state = FORWARD;
            break;
        }


    }

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