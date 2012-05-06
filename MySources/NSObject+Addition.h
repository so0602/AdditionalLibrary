#import <UIKit/UIKit.h>

#import "YTGlobalValues.h"

@protocol YTUILocalNotificationDataSource;

@interface NSObject (Addition)

#pragma mark UILocalNotification

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary*)userInfo __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
-(id)initWithDataSource:(id<YTUILocalNotificationDataSource>)dataSource __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary*)userInfo __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+(id)localNotificationWithDataSource:(id<YTUILocalNotificationDataSource>)dataSource __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end

@protocol YTUILocalNotificationDataSource
@optional
-(NSDate*)fireDate:(id)target;
-(NSString*)alertBody:(id)target;
-(NSString*)alertAction:(id)target;
-(NSString*)soundName:(id)target;
-(NSInteger)applicationIconBadgeNumber:(id)target;
-(NSDictionary*)userInfo:(id)target;

@end

@interface YTUILocalNotificationDataSource : NSObject<YTUILocalNotificationDataSource>{
@private
	NSDate* _fireDate;
	NSString* _alertBody;
	NSString* _alertAction;
	NSString* _soundName;
	NSInteger _applicationIconBadgeNumber;
	NSDictionary* _userInfo;
}

@property (nonatomic, retain) NSDate* fireDate;
@property (nonatomic, retain) NSString* alertBody;
@property (nonatomic, retain) NSString* alertAction;
@property (nonatomic, retain) NSString* soundName;
@property (nonatomic, assign) NSInteger applicationIconBadgeNumber;
@property (nonatomic, retain) NSDictionary* userInfo;

@end