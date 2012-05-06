#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

typedef enum{
	TabBarCubeAnimationOutside = 0,
	TabBarCubeAnimationInside,
}TabBarCubeAnimation;

@interface UITabBarController (Addition)

@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, readonly) UIView* contentView;

-(void)cubeToIndex:(NSUInteger)index animation:(TabBarCubeAnimation)animation;
-(void)transitionToIndex:(NSUInteger)index;
-(void)scrollToIndex:(NSUInteger)index;
-(void)scrollToIndex:(NSUInteger)index delegate:(id)delegate stopSelector:(SEL)stopSelector;

-(void)tabBarWillChange:(NSUInteger)index;
-(void)tabBarChanging:(NSUInteger)index animated:(BOOL)animated;
-(void)tabBarDidChange:(NSUInteger)index;

@end