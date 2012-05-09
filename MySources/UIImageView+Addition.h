#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

#import "UIView+Addition.h"
#import "UIImage+Addition.h"

@protocol YTUIAnimationImageDataSource;
@protocol YTUIImageViewDataSource;

@interface UIImageView (Addition)

-(id)initWithFrame:(CGRect)frame image:(UIImage*)image;
-(id)initWithDataSource:(id<YTUIImageViewDataSource>)dataSource;

+(id)imageViewWithImage:(UIImage*)image;
+(id)imageViewWithFrame:(CGRect)frame image:(UIImage*)image;
+(id)imageViewWithDataSource:(id<YTUIImageViewDataSource>)dataSource;

-(void)setAnimationDataSource:(id<YTUIAnimationImageDataSource>)dataSource;

@end



@protocol YTUIImageViewDataSource<YTUIViewDataSource>

@optional
-(UIImage*)image:(id)target;
-(UIImage*)highlightedImage:(id)target;
-(id<YTUIAnimationImageDataSource>)animationImageDataSource:(id)target;

@end

@interface YTUIImageViewDataSource : YTUIViewDataSource<YTUIImageViewDataSource>{
@private
	UIImage* _image;
	UIImage* _highlightedImage;
	id<YTUIAnimationImageDataSource> _animationImageDataSource;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* highlightedImage;
@property (nonatomic, retain) id<YTUIAnimationImageDataSource> animationImageDataSource;

@end

@protocol YTUIAnimationImageDataSource

-(NSArray*)animationImages:(id)target;

@optional
-(NSArray*)highlightedAnimationImages:(id)target;
-(NSTimeInterval)animationDuration:(id)target; //Default: number of images * 1 / 30th of a second (i.e. 30 fps)
-(NSInteger)animationRepeatCount:(id)target; //Default: 0 - infinite

@end

@interface YTUIAnimationImageDataSource : NSObject<YTUIAnimationImageDataSource>{
@private
	NSArray* _animationImages;
	NSArray* _highlightedAnimationImages;
	NSTimeInterval _animationDuration;
	NSInteger _animationRepeatCount;
}

@property (nonatomic, retain) NSArray* animationImages;
@property (nonatomic, retain) NSArray* highlightedAnimationImages;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSInteger animationRepeatCount;

@end