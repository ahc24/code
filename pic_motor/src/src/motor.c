#include "motor.h"

void i_like_to_moveit_moveit( signed char left_side_speed , signed char right_side_speed )
{
    unsigned char moves[MOTOR_COMMAND_SIZE];

    // Convert to motor packetized serial format



    moves[0] = MOTOR_CONTROLLER_ADDRESS;

    if( left_side_speed >=0 )
    {
        moves[1] = MOTOR_FORWARD_LEFT;
        moves[2] = left_side_speed;
    }
    else
    {
        moves[1] = MOTOR_BACKWARD_LEFT;

        if(left_side_speed == -128)
        {
            moves[2] = (unsigned char)((-left_side_speed)-1);
        }
        else
        {
            moves[2] = (unsigned char)(-left_side_speed);
        }
    }

    moves[3] = (moves[0] + moves[1] + moves[2])&127;
    
    send_uart_message(moves);

    if( right_side_speed >=0 )
    {
        moves[1] = MOTOR_FORWARD_RIGHT;
        moves[2] = right_side_speed;
    }
    else
    {
        moves[1] = MOTOR_BACKWARD_RIGHT;
        
        if(right_side_speed == -128)
        {
            moves[2] = (unsigned char)((-right_side_speed)-1);
        }
        else
        {
            moves[2] = (unsigned char)(-right_side_speed);
        }
    }
    
    moves[3] = (moves[0] + moves[1] + moves[2])&127;

    send_uart_message(moves);

}
