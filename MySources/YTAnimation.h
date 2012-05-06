#import "YTDefineValues.h"

@interface YTAnimation : NSObject

+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration;
+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration;
+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration;
+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration;
+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)showView:(UIView*)view duration:(NSTimeInterval)duration;
+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration;
+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration;
+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration;
+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration;
+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context;
+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration;
+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector;
+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector;
+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context;
+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration;
+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector;
+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector;
+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context;
+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration;
+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector;
+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector;
+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context;
+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration;
+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector;
+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector;
+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context;
+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

@end