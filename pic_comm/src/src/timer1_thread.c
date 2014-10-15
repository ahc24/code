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

    static unsigned char left_speed = 0;
    static unsigned char right_speed = 0;

    unsigned char whatever_msg[UART_DATA_LENGTH];

    whatever_msg[0] = MSGID_MOVE;
    whatever_msg[1] = left_speed++;
    whatever_msg[2] = right_speed++;


    send_uart_message( whatever_msg );

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