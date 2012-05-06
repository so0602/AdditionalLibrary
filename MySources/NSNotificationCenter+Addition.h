#import <Foundation/Foundation.h>

#import "YTGlobalValues.h"

@interface NSNotificationCenter (Addition)

-(void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString*)aName;

-(void)removeObserver:(id)observer name:(NSString*)aName;
-(void)removeObserver:(id)observer names:(NSString*)firstName, ...;

@end