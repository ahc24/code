#include "maindefs.h"
#include "interrupts.h"
#include "user_interrupts.h"
#include "messages.h"

//----------------------------------------------------------------------------
// Note: This code for processing interrupts is configured to allow for high and
//       low priority interrupts.  The high priority interrupt can interrupt the
//       the processing of a low priority interrupt.  However, only one of each type
//       can be processed at the same time.  It is possible to enable nesting of low
//       priority interrupts, but this code is not setup for that and this nesting is not
//       enabled.

void enable_interrupts() {
    // Peripheral interrupts can have their priority set to high or low
    // enable high-priority interrupts and low-priority interrupts
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    //uart_send_byte( 0x51 );
    INTCONbits.GIEL = 1;

    
}

int in_high_int() {
    return (!INTCONbits.GIEH);
}

int low_int_active() {
    return (!INTCONbits.GIEL);
}

int in_low_int() {
    if (INTCONbits.GIEL == 1) {
        return (0);
    } else if (in_high_int()) {
        return (0);
    } else {
        return (1);
    }
}

int in_main() {
    if ((!in_low_int()) && (!in_high_int())) {
        return (1);
    } else {
        return (0);
    }
}

#ifdef __XC8
// Nothing is needed for this compiler
#else
// Set up the interrupt vectors
void InterruptHandlerHigh();
void InterruptHandlerLow();

#pragma code InterruptVectorLow = 0x18

void
InterruptVectorLow(void) {
    _asm
    goto InterruptHandlerLow //jump to interrupt routine
            _endasm
}

#pragma code InterruptVectorHigh = 0x08

void
InterruptVectorHigh(void) {
    _asm
    goto InterruptHandlerHigh //jump to interrupt routine
            _endasm
}
#endif
//----------------------------------------------------------------------------
// High priority interrupt routine
// this parcels out interrupts to individual handlers

#ifdef __XC8
interrupt
#else
#pragma code
#pragma interrupt InterruptHandlerHigh
#endif
void InterruptHandlerHigh() {
    // We need to check the interrupt flag of each enabled high-priority interrupt to
    // see which device generated this interrupt.  Then we can call the correct handler.

    // check to see if we have an I2C interrupt
    if (PIR1bits.SSPIF) {
        // clear the interrupt flag
        PIR1bits.SSPIF = 0;
        // call the handler

        

        i2c_int_handler();
    }

    // check to see if we have an interrupt on timer 0
    /*
    if (INTCONbits.TMR0IF) {
        INTCONbits.TMR0IF = 0; // clear this interrupt flag
        // call whatever handler you want (this is "user" defined)

        
        blip2();
        timer0_int_handler();
    }
    */

    // here is where you would check other interrupt flags.

    // The *last* thing I do here is check to see if we can
    // allow the processor to go to sleep
    // This code *DEPENDS* on the code in messages.c being
    // initialized using "init_queues()" -- if you aren't using
    // this, then you shouldn't have this call here
    SleepIfOkay();
}

//----------------------------------------------------------------------------
// Low priority interrupt routine
// this parcels out interrupts to individual handlers
// This works the same way as the "High" interrupt handler
#ifdef __XC8
interrupt low_priority
#else
#pragma code
#pragma interruptlow InterruptHandlerLow
#endif
void InterruptHandlerLow() {
    static unsigned long encoder_left=0;
    static unsigned long encoder_right=0;
    
    // check to see if we have an interrupt on timer 1
    if (PIR1bits.TMR1IF) {
        PIR1bits.TMR1IF = 0; //clear interrupt flag

        blip1();
        
        encoder_right++;

        TMR1L = 0x35;
        TMR1H = 0xff;

        //timer1_int_handler();
    }

    // check to see if we have an interrupt on timer 0
    if (INTCONbits.TMR0IF) {
        INTCONbits.TMR0IF = 0;  //clear interrupt flag

        blip2();

        encoder_left++;

        TMR0L = 0x35;
        blink1();

        //timer0_int_handler();
    }

    // check to see if we have an interrupt on USART RX
    if (PIR1bits.RCIF) {
        PIR1bits.RCIF = 0; //clear interrupt flag

        

        uart_receive_interrupt_handler();
    }

    
    //Check interrupt flag for uart transmit
    if (PIR1bits.TX1IF && PIE1bits.TX1IE)
    {
        
        
        
        uart_transmit_interrupt_handler();
        
        //PIR1bits.TX1IF = 0;
      
    }

    // Check for I need data interrupt
    if( PIR1bits.ADIF )
    {
        PIR1bits.ADIF = 0;

        unsigned char sendy_stuff[I2C_DATA_SIZE];

        
        sendy_stuff[2] = encoder_left >> 24;
        sendy_stuff[3] = encoder_left >> 16;
        sendy_stuff[4] = encoder_left >> 8;
        sendy_stuff[5] = encoder_left;
        sendy_stuff[6] = encoder_right >> 24;
        sendy_stuff[7] = encoder_right >> 16;
        sendy_stuff[8] = encoder_right >> 8;
        sendy_stuff[9] = encoder_right;

        ToMainLow_sendmsg(I2C_DATA_SIZE,MSGT_I2C_MOTOR_DATA,(void *) &sendy_stuff );

        blip3();
    }
}

