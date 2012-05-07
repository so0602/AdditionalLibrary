#import <Foundation/Foundation.h>

@interface NSInvocation (Addition)

+(id)invocationWithTarget:(NSObject*)target selector:(SEL)selector;

+(id)invocationWithTarget:(NSObject*)target selector:(SEL)selector arguments:(void*)firstArgument, ...;

@property (nonatomic, assign, readonly) NSInteger argumentCount;

@end