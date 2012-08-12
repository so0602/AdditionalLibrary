#import "HTMLNode.h"

@interface HTMLNode (Addition)

@property (nonatomic, readonly) HTMLNode* aNode;
@property (nonatomic, readonly) NSArray* aNodes;
@property (nonatomic, readonly) NSURL* href;
-(NSURL*)hrefAtIndex:(NSInteger)index;

@property (nonatomic, readonly) HTMLNode* liNode;
@property (nonatomic, readonly) NSArray* liNodes;

-(HTMLNode*)findChildOfId:(NSString*)idName;
-(NSArray*)findChildrenOfId:(NSString*)idName;

@end
