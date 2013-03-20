#import "FMDatabaseQueue+Default.h"

#import <objc/runtime.h>

static const char* Key_MaxInsertCount = "&#_Key_MaxInsertCount_#&";

@implementation FMDatabaseQueue (Default)

-(NSInteger)maxInsertCount{
    return objc_getAssociatedObject(self, Key_MaxInsertCount);
}
-(void)setMaxInsertCount:(NSInteger)maxInsertCount{
    objc_setAssociatedObject(self, Key_MaxInsertCount, maxInsertCount, OBJC_ASSOCIATION_ASSIGN);
}

@end