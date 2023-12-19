#include <stdio.h>
#include "base.h"

typedef struct {
    int x;
    int y;
    int w;
    int h;
    short vx;
    short vy;
} Ball;

extern Ball ball __asm__("ball");
sysv void log_state(void) __asm__("log_state");
void log_state(void)
{
    static u8 i;
    if (i++ == 0) {
        printf("ball %d %d %d %d\n", ball.x, ball.y, ball.vx, ball.vy);
    }
}

sysv int breakout_entry(void) __asm__("breakout_entry");
int main(void)
{
    return breakout_entry();
}
