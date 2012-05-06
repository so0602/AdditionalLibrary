#import "UIApplication+Addition.h"

@implementation UIApplication (Addition)

-(void)presentLocalNotificationDataSourceNow:(id<YTUILocalNotificationDataSource>)dataSource{
	UIApplication* application = [UIApplication sharedApplication];
	if( RespondsToSelector(application, @selector(presentLocalNotificationNow:)) ){
		id notification = [NSObject localNotificationWithDataSource:dataSource];
		[application presentLocalNotificationNow:notification];
	}
}

-(void)scheduleLocalNotificationDataSource:(id<YTUILocalNotificationDataSource>)dataSource{
	UIApplication* application = [UIApplication sharedApplication];
	if( RespondsToSelector(application, @selector(scheduleLocalNotification:)) ){
		id notification = [NSObject localNotificationWithDataSource:dataSource];
		[application scheduleLocalNotification:notification];
	}
}

-(void)cancelLocalNotificationDataSource:(id<YTUILocalNotificationDataSource>)dataSource{
	UIApplication* application = [UIApplication sharedApplication];
	if( RespondsToSelector(application, @selector(cancelLocalNotification:)) ){
		id notification = [NSObject localNotificationWithDataSource:dataSource];
		[application cancelLocalNotification:notification];
	}
}

@end