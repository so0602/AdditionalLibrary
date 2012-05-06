#import "NSInvocation+Addition.h"

@implementation NSInvocation (Addition)

+(id)invocationWithTarget:(NSObject*)target selector:(SEL)selector{
	NSMethodSignature* signature = [target methodSignatureForSelector:selector];
	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
	invocation.target = target;
	invocation.selector = selector;
	[invocation retainArguments];
	return invocation;
}

+(id)invocationWithTarget:(NSObject*)target selector:(SEL)selector arguments:(void*)firstArgument, ...{
	NSInvocation* invocation = [self invocationWithTarget:target selector:selector];
	
	void* eachArgument = nil;
	va_list argumentList;
	
	if( firstArgument ){
		NSInteger index = 2;
		[invocation setArgument:&firstArgument atIndex:index++];
		
		va_start(argumentList, firstArgument);
		while( eachArgument = va_arg(argumentList, void*) ){
			[invocation setArgument:&eachArgument atIndex:index++];
		}
		va_end(argumentList);
	}
	
	return invocation;
}

@end