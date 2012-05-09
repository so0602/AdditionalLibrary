#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

#import "UIView+Addition.h"
#import "UIImage+Addition.h"

@protocol YTUIButtonDataSource;
@protocol YTUIButtonDataSourceList;

@interface UIButton (Addition)

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title;
+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor;
+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font;
+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font image:(UIImage*)image;
+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font image:(UIImage*)image backgroundImage:(UIImage*)backgroundImage;
+(id)buttonWithType:(UIButtonType)buttonType dataSourceList:(id<YTUIButtonDataSourceList>)dataSourceList;

-(void)setTitle:(NSString*)title titleColor:(UIColor*)titleColor image:(UIImage*)image backgroundImage:(UIImage*)backgroundImage forState:(UIControlState)state;
-(void)setFont:(UIFont*)font;
-(void)setDataSource:(id<YTUIButtonDataSource>)dataSource;
-(void)setDataSourceList:(id<YTUIButtonDataSourceList>)dataSourceList;

@end

@protocol YTUIButtonDataSource<YTUIViewDataSource>

-(UIControlState)state:(id)target;

@optional
-(NSString*)title:(id)target;
-(UIColor*)titleColor:(id)target;
-(UIImage*)image:(id)target;
-(UIImage*)backgroundImage:(id)target;

@end

@interface YTUIButtonDataSource : NSObject<YTUIButtonDataSource>{
	NSString* _title;
	UIColor* _titleColor;
	UIImage* _image;
	UIImage* _backgroundImage;
	UIControlState _state;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIColor* titleColor;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* backgroundImage;
@property (nonatomic, assign) UIControlState state;

@end

@protocol YTUIButtonDataSourceList <YTUIViewDataSource>

-(NSArray<YTUIButtonDataSource>*)dataSources:(id)target;

@optional
-(UIFont*)font:(id)target;

@end

@interface YTUIButtonDataSourceList : NSObject<YTUIButtonDataSourceList>{
	UIFont* _font;
	NSArray<YTUIButtonDataSource>* _dataSources;
}

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) NSArray<YTUIButtonDataSource>* dataSources;

@end