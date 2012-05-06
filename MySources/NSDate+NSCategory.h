#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct NSDateInformation{
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;
};
typedef struct NSDateInformation NSDateInformation;

@interface NSDate (NSCategory)

+(NSDate*)yesterday;
+(NSDate*)month;

-(NSDate*)monthDate;

-(NSDate*)lastOfMonthDate;

+(NSArray*)datesFromDate:(NSDate*)from toDate:(NSDate*)to;

-(BOOL)isSameDay:(NSDate*)anotherDate;
-(int)monthsBetweenDate:(NSDate*)toDate;
-(NSInteger)daysBetweenDate:(NSDate*)d;
-(BOOL)isToday;

-(NSDate*)dateByAddingDays:(NSUInteger)days;
+(NSDate*)dateWithDatePart:(NSDate*)aDate andTimePart:(NSDate*)aTime;

-(NSString*)monthString;
-(NSString*)yearString;

-(NSDateInformation)dateInformation;
-(NSDateInformation)dateInformationWithTimeZone:(NSTimeZone*)tz;
+(NSDate*)dateFromDateInformation:(NSDateInformation)info;
+(NSDate*)dateFromDateInformation:(NSDateInformation)info timeZone:(NSTimeZone*)tz;
+(NSString*)dateInformationDescriptionWithInformation:(NSDateInformation)info;

@end