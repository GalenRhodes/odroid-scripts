#include <stdio.h>

int main(int argc, const char *argv[]) {
    void (^hello)(void) = ^(void) {
        printf("Hello, block!\n");
    };
    hello();
    return 0;
}
