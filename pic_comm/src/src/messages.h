#ifndef __messages
#define __messages

// The maximum length (in bytes) of a message
#define MSGLEN 14

// The maximum number of messages in a single queue
#define MSGQUEUELEN 5

//Command Definitions
#define MSGID_MOVE                  0x01
#define MSGID_STATUS_REQUEST        0x02
#define MSGID_STATUS_RESPONSE       0x03
#define MSGID_SENSOR_REQUEST        0x04
#define MSGID_SENSOR_RESPONSE       0x05
#define MSGID_MOTOR_REQUEST         0x06
#define MSGID_MOTOR_RESPONSE        0x07

#define MSGID_UART_ACK              0x11

#define MSGID_UART_BAD_CHECKSUM     0xf1
#define MSGID_UART_BAD_COUNTER      0xf2
#define MSGID_UART_BAD_START        0xf3
#define MSGID_UART_BAD_END          0xf4
//=========================





typedef struct __msg {
    unsigned char full;
    unsigned char length;
    unsigned char msgtype;
    unsigned char data[MSGLEN];
} msg;

typedef struct __msg_queue {
    msg queue[MSGQUEUELEN];
    unsigned char cur_write_ind;
    unsigned char cur_read_ind;
} msg_queue;

// Error Codes
// Too many messages in the queue
#define MSGQUEUE_FULL -1
// Message sent okay
#define MSGSEND_OKAY 1
// The length of the message is either too large or negative
#define MSGBAD_LEN -2
// The message buffer is too small to receive the message in the queue
#define MSGBUFFER_TOOSMALL -3
// The message queue is empty
#define MSGQUEUE_EMPTY -4
// This call must be made from a low-priority interrupt handler
#define MSG_NOT_IN_LOW -5
// This call must be made from a high-priority interrupt handler
#define MSG_NOT_IN_HIGH -6
// This call must be made from the "main()" thread
#define MSG_NOT_IN_MAIN -7

// This MUST be called before anything else in messages and should
// be called before interrupts are enabled
void init_queues(void);

// This is called from a high priority interrupt to decide if the
// processor may sleep. It is currently called in interrupts.c
void SleepIfOkay(void);

// This is called in the "main()" thread (if desired) to block
// until a message is received on one of the two incoming queues
void block_on_To_msgqueues(void);

// Queue:
// The "ToMainLow" queue is a message queue from low priority
// interrupt handlers to the "main()" thread.  The send is called
// in the interrupt handlers and the receive from "main()"
signed char ToMainLow_sendmsg(unsigned char,unsigned char,void *);
signed char ToMainLow_recvmsg(unsigned char,unsigned char *,void *);

// Queue:
// The "ToMainHigh" queue is a message queue from high priority
// interrupt handlers to the "main()" thread.  The send is called
// in the interrupt handlers and the receive from "main()"
signed char ToMainHigh_sendmsg(unsigned char,unsigned char,void *);
signed char ToMainHigh_recvmsg(unsigned char,unsigned char *,void *);

// Queue:
// The "FromMainLow" queue is a message queue from the "main()"
// thread to the low priority interrupt handlers.  The send is called
// in the "main()" thread and the receive from the interrupt handlers.
signed char FromMainLow_sendmsg(unsigned char,unsigned char,void *);
signed char FromMainLow_recvmsg(unsigned char,unsigned char *,void *);

// Queue:
// The "FromMainHigh" queue is a message queue from the "main()"
// thread to the high priority interrupt handlers.  The send is called
// in the "main()" thread and the receive from the interrupt handlers.
signed char FromMainHigh_sendmsg(unsigned char,unsigned char,void *);
signed char FromMainHigh_recvmsg(unsigned char,unsigned char *,void *);

#endif
