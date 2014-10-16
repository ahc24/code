#include "motor.h"

void i_like_to_moveit_moveit( unsigned char left_side_speed , unsigned char right_side_speed )
{
    // 1 - 127 motor 1
    //      1   - Full Reverse
    //      64  - Stop
    //      127 - Full Forward
    // 128 - 255 motor 2
    //      128 - Full Reverse
    //      192 - Stop
    //      255 - Full Forward

    unsigned char moves[MOTOR_COMMAND_SIZE];

    // Convert to motor simplified serial format
    moves[0] = ((signed char)left_side_speed>>1) + 192;
    moves[1] = ((signed char)right_side_speed>>1) + 64;

    if(moves[1] == 0)
    {
        moves[1] = 1;
    }

    send_uart_message(moves);

}
