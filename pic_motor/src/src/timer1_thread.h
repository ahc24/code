typedef struct __timer1_thread_struct {
    // "persistent" data for this "lthread" would go here
    unsigned int msgcount;
    unsigned long encoder_ticks;
} timer1_thread_struct;

void init_timer1_lthread(timer1_thread_struct *);
int timer1_lthread(timer1_thread_struct *,int,int,unsigned char*);
