#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"
#import "NSObject+Addition.h"

@interface UIApplication (Addition)

-(void)presentLocalNotificationDataSourceNow:(id<YTUILocalNotificationDataSource>)dataSource __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(void)scheduleLocalNotificationDataSource:(id<YTUILocalNotificationDataSource>)dataSource __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(void)cancelLocalNotificationDataSource:(id<YTUILocalNotificationDataSource>)dataSource __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end