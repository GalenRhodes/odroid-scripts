#!/bin/bash
mkdir -p objctest

cat > objctest/blocktest.m << "EOF"
#include <stdio.h>

int main(int argc, const char *argv[]) {
    void (^hello)(void) = ^(void) {
        printf("Hello, block!\n");
    };
    hello();
    return 0;
}
EOF

cat > objctest/helloGCD_objc.m << "EOF"

#include <dispatch/dispatch.h>
#import <stdio.h>
#import "Fraction.h"

int main( int argc, const char *argv[] ) {
   dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
   Fraction *frac = [[Fraction alloc] init];

   [frac setNumerator: 1];
   [frac setDenominator: 3];

   // print it
   dispatch_sync(queue, ^{
     printf( "The fraction is: " );
     [frac print];
     printf( "\n" );
   });
   dispatch_release(queue);

   return 0;
}

EOF

cat > objctest/Fraction.h << "EOF"

#import <Foundation/NSObject.h>

@interface Fraction: NSObject {
   int numerator;
   int denominator;
}

-(void) print;
-(void) setNumerator: (int) n;
-(void) setDenominator: (int) d;
-(int) numerator;
-(int) denominator;
@end

EOF


cat > objctest/Fraction.m << "EOF"
#import "Fraction.h"
#import <stdio.h>

@implementation Fraction
-(void) print {
   printf( "%i/%i", numerator, denominator );
}

-(void) setNumerator: (int) n {
   numerator = n;
}

-(void) setDenominator: (int) d {
   denominator = d;
}

-(int) denominator {
   return denominator;
}

-(int) numerator {
   return numerator;
}
@end

EOF

cat > objctest/guitest.m << "EOF"
#import <AppKit/AppKit.h>

int main()
{
  NSApplication *app;  // Without these 2 lines, seg fault may occur
  app = [NSApplication sharedApplication];

  NSAlert * alert = [[NSAlert alloc] init];
  [alert setMessageText:@"Hello alert"];
  [alert addButtonWithTitle:@"All done"];
  int result = [alert runModal];
  if (result == NSAlertFirstButtonReturn) {
    NSLog(@"First button pressed");
  }
}
EOF

./buildtests.sh
openapp ./objctest/GUITest.app
