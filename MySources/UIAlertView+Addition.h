#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "YTGlobalValues.h"

#import "UIView+Addition.h"

@protocol YTUIAlertViewDataSource;
@class YTUIAlertViewDataSource;

@interface UIAlertView (Addition)

+(id)alertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)alertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)alertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)alertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)alertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)alertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)alertViewWithDataSource:(id<YTUIAlertViewDataSource>)dataSource;

+(id)showAlertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)showAlertViewWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)showAlertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;
+(id)showAlertViewWithMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;

+(id)showAlertViewWithDataSource:(id<YTUIAlertViewDataSource>)dataSource;

@end

typedef void(^UIAlertViewDidClickBlock)(NSInteger index);
typedef void(^UIAlertViewDidCancelBlock)();
typedef void(^UIAlertViewWillPresentBlock)();
typedef void(^UIAlertViewDidPresentBlock)();
typedef void(^UIAlertViewWillDismissBlock)(NSInteger index);
typedef void(^UIAlertViewDidDismissBlock)(NSInteger index);
typedef BOOL(^UIAlertViewShouldEnableFirstOtherButtonBlock)();

@interface UIAlertView (Block)

-(UIAlertViewDidClickBlock)didClickBlock;
-(void)setDidClickBlock:(UIAlertViewDidClickBlock)didClickBlock;

-(UIAlertViewDidCancelBlock)didCancelBlock;
-(void)setDidCancelBlock:(UIAlertViewDidCancelBlock)didCancelBlock;

-(UIAlertViewWillPresentBlock)willPresentBlock;
-(void)setWillPresentBlock:(UIAlertViewWillPresentBlock)willPresentBlock;

-(UIAlertViewDidPresentBlock)didPresentBlock;
-(void)setDidPresentBlock:(UIAlertViewDidPresentBlock)didPresentBlock;

-(UIAlertViewWillDismissBlock)willDismissBlock;
-(void)setWillDismissBlock:(UIAlertViewWillDismissBlock)willDismissBlock;

-(UIAlertViewDidDismissBlock)didDismissBlock;
-(void)setDidDismissBlock:(UIAlertViewDidDismissBlock)didDismissBlock;

-(UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock;
-(void)setShouldEnableFirstOtherButtonBlock:(UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock;

@end

@protocol YTUIAlertViewDataSource<YTUIViewDataSource>

-(NSString*)cancelButtonTitle:(id)target;

@optional
-(NSString*)title:(id)target;
-(NSString*)message:(id)target;
-(NSString*)okButtonTitle:(id)target;

@end

@interface YTUIAlertViewDataSource : YTUIViewDataSource<YTUIAlertViewDataSource>{
@private
	NSString* _title;
	NSString* _message;
	NSString* _cancelButtonTitle;
	NSString* _okButtonTitle;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* cancelButtonTitle;
@property (nonatomic, retain) NSString* okButtonTitle;

@end