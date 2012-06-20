#import "HTMLNode.h"

@interface HTMLNode (Addition)

@property (nonatomic, readonly) HTMLNode* aNode;
@property (nonatomic, readonly) NSArray* aNodes;
@property (nonatomic, readonly) NSURL* href;

@property (nonatomic, readonly) HTMLNode* liNode;
@property (nonatomic, readonly) NSArray* liNodes;

@end
