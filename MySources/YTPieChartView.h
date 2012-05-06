#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class YTPieChartView;

@protocol YTPieChartViewDataSource<NSObject>

@required
-(NSUInteger)numberOfSlicesInPieChartView:(YTPieChartView*)pieChartView;
-(CGFloat)pieChartView:(YTPieChartView*)pieChartView valueForSliceAtIndex:(NSUInteger)index;

@optional
-(UIColor*)pieChartView:(YTPieChartView*)pieChartView colorForSliceAtIndex:(NSUInteger)index;

@end

@protocol YTPieChartViewDelegate<NSObject>

@optional
-(void)pieChartView:(YTPieChartView*)pieChartView willSelectSliceAtIndex:(NSUInteger)index;
-(void)pieChartView:(YTPieChartView*)pieChartView didSelectSliceAtIndex:(NSUInteger)index;
-(void)pieChartView:(YTPieChartView*)pieChartView willDeselectSliceAtIndex:(NSUInteger)index;
-(void)pieChartView:(YTPieChartView*)pieChartView didDeselectSliceAtIndex:(NSUInteger)index;

@end

@interface YTPieChartView : UIView

@property (nonatomic, retain) id<YTPieChartViewDataSource> dataSource;
@property (nonatomic, retain) id<YTPieChartViewDelegate> delegate;
@property (nonatomic, assign) CGFloat startPieAngle;
@property (nonatomic, assign) CGFloat animationSpeed;
@property (nonatomic, assign) CGPoint pieCenter;
@property (nonatomic, assign) CGFloat pieRadius;
@property (nonatomic, assign) BOOL showLabel;
@property (nonatomic, retain) UIFont* labelFont;
@property (nonatomic, assign) CGFloat labelRadius;
@property (nonatomic, assign) CGFloat selectedSliceStroke;
@property (nonatomic, assign) CGFloat selectedSliceOffsetRadius;
@property (nonatomic, assign) BOOL showPercentage;

-(id)initWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius;
-(void)reloadData;
-(void)setPieBackgroundColor:(UIColor*)color;

@end