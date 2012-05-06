#import "NSNotificationCenter+Addition.h"

@implementation NSNotificationCenter (Addition)

-(void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString*)aName{
	[self addObserver:observer selector:aSelector name:aName object:nil];
}

-(void)removeObserver:(id)observer name:(NSString*)aName{
	[self removeObserver:observer name:aName object:nil];
}

-(void)removeObserver:(id)observer names:(NSString*)firstName, ...{
	NSString* eachName = nil;
	va_list argumentList;
	if( firstName ){
		[self removeObserver:observer name:firstName];
		va_start(argumentList, firstName);
		while( (eachName = va_arg(argumentList, NSString*)) ) [self removeObserver:observer name:eachName];
		va_end(argumentList);
	}
}

@end