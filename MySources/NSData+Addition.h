#import <Foundation/Foundation.h>

@interface NSData (Addition)

#pragma mark NSDataStrings

-(NSString*)stringWithHexBytes;

-(NSData*)compressed;

@end