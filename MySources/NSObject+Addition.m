#import "NSObject+Addition.h"

@implementation NSObject (Addition)

#pragma mark UILocalNotification

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody{
	return [self initWithFireDate:fireDate alertBody:alertBody alertAction:nil soundName:UILocalNotificationDefaultSoundName applicationIconBadgeNumber:0 userInfo:nil];
}

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction{
	return [self initWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:UILocalNotificationDefaultSoundName applicationIconBadgeNumber:0 userInfo:nil];
}

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName{
	return [self initWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:0 userInfo:nil];
}

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber{
	return [self initWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:applicationIconBadgeNumber userInfo:nil];
}

-(id)initWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary*)userInfo{
	Class myClass = NSClassFromString(@"UILocalNotification");
	if( !myClass ) return nil;
	
	id localNotification = [[NSClassFromString(@"UILocalNotification") alloc] init];
	[localNotification setFireDate:fireDate];
	[localNotification setAlertBody:alertBody];
	[localNotification setAlertAction:alertAction];
	[localNotification setSoundName:soundName == nil ? UILocalNotificationDefaultSoundName : soundName];
	[localNotification setApplicationIconBadgeNumber:applicationIconBadgeNumber];
	[localNotification setUserInfo:userInfo];
	
	return localNotification;
}

-(id)initWithDataSource:(id<YTUILocalNotificationDataSource>)dataSource{
	Class myClass = NSClassFromString(@"UILocalNotification");
	if( !myClass ) return nil;
	
	NSDate* fireDate = nil;
	NSString* alertBody = nil;
	NSString* alertAction = nil;
	NSString* soundName = UILocalNotificationDefaultSoundName;
	NSInteger applicationIconBadgeNumber = 0;
	NSDictionary* userInfo = nil;
	
	if( RespondsToSelector(dataSource, @selector(fireDate:)) ) fireDate = [dataSource fireDate:self];
	if( RespondsToSelector(dataSource, @selector(alertBody:)) ) alertBody = [dataSource alertBody:self];
	if( RespondsToSelector(dataSource, @selector(alertAction:)) ) alertAction = [dataSource alertAction:self];
	if( RespondsToSelector(dataSource, @selector(soundName:)) ) soundName = [dataSource soundName:self];
	if( RespondsToSelector(dataSource, @selector(applicationIconBadgeNumber:)) ) applicationIconBadgeNumber = [dataSource applicationIconBadgeNumber:self];
	if( RespondsToSelector(dataSource, @selector(userInfo:)) ) userInfo = [dataSource userInfo:self];
	
	return [self initWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:applicationIconBadgeNumber userInfo:userInfo];
}

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody{
	return [self localNotificationWithFireDate:fireDate alertBody:alertBody alertAction:nil soundName:nil applicationIconBadgeNumber:0 userInfo:nil];
}

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction{
	return [self localNotificationWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:nil applicationIconBadgeNumber:0 userInfo:nil];
}

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName{
	return [self localNotificationWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:0 userInfo:nil];
}

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber{
	return [self localNotificationWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:applicationIconBadgeNumber userInfo:nil];
}

+(id)localNotificationWithFireDate:(NSDate*)fireDate alertBody:(NSString*)alertBody alertAction:(NSString*)alertAction soundName:(NSString*)soundName applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary*)userInfo{
	return [[[self alloc] initWithFireDate:fireDate alertBody:alertBody alertAction:alertAction soundName:soundName applicationIconBadgeNumber:applicationIconBadgeNumber userInfo:userInfo] autorelease];
}

+(id)localNotificationWithDataSource:(id<YTUILocalNotificationDataSource>)dataSource{
	return [[[self alloc] initWithDataSource:dataSource] autorelease];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUILocalNotificationDataSource

@implementation YTUILocalNotificationDataSource

@synthesize fireDate = _fireDate;
@synthesize alertBody = _alertBody;
@synthesize alertAction = _alertAction;
@synthesize soundName = _soundName;
@synthesize applicationIconBadgeNumber = _applicationIconBadgeNumber;
@synthesize userInfo = _userInfo;

#pragma mark Memory Management

-(void)dealloc{
	self.fireDate = nil;
	self.alertBody = nil;
	self.alertAction = nil;
	self.soundName = nil;
	self.applicationIconBadgeNumber = 0;
	self.userInfo = nil;
	
	[super dealloc];
}

@end