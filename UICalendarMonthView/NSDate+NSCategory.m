#import "NSDate+NSCategory.h"

@interface NSDate (Private)

+(NSDate*)lastOfMonthDate;

-(int)weekday;
-(NSDate*)timelessDate;
-(NSDate*)monthlessDate;

@end

@implementation NSDate (NSCategory)

+(NSDate*)yesterday{
	NSDateInformation info = [[NSDate date] dateInformation];
	info.day--;
	return [NSDate dateFromDateInformation:info];
}

+(NSDate*)month{
	return [[NSDate date] monthDate];
}

-(NSDate*)monthDate{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comps setDay:1];
	NSDate* date = [gregorian dateFromComponents:comps];
	[gregorian release], gregorian = nil;
	return date;
}

-(NSDate*)lastOfMonthDate{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comps setDay:0];
	[comps setMonth:comps.month+1];
	NSDate* date = [gregorian dateFromComponents:comps];
	[gregorian release], gregorian = nil;
	return date;
}

+(NSArray*)datesFromDate:(NSDate*)from toDate:(NSDate*)to{
	NSDate* date = from;
	NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSMutableArray* dates = [NSMutableArray arrayWithObject:from];
	while( TRUE ){
		NSDateInformation info = [date dateInformationWithTimeZone:timeZone];
		info.day++;
		date = [NSDate dateFromDateInformation:info timeZone:timeZone];
		if( [date compare:to] == NSOrderedDescending ) break;
		else [dates addObject:date];
	}
	return dates;
}

-(BOOL)isSameDay:(NSDate*)anotherDate{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDateComponents *comps2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
	return ([comps1 year] == [comps2 year] && [comps1 month] == [comps2 month] && [comps1 day] == [comps2 day]);
}

-(int)monthsBetweenDate:(NSDate*)toDate{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:NSMonthCalendarUnit fromDate:[self monthlessDate] toDate:[toDate monthlessDate] options:0];
	NSInteger months = [comps month];
	[gregorian release], gregorian = nil;
	return abs(months);
}

-(NSInteger)daysBetweenDate:(NSDate*)date{
	NSTimeInterval time = [self timeIntervalSinceDate:date];
	return abs(time / 60 / 60 / 24);
}

-(BOOL)isToday{
	return [self isSameDay:[NSDate date]];
}

-(NSDate*)dateByAddingDays:(NSUInteger)days{
	NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
	comps.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

+(NSDate*)dateWithDatePart:(NSDate*)aDate andTimePart:(NSDate*)aTime{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"dd/MM/yyyy"];
	NSString* datePortion = [formatter stringFromDate:aDate];
	
	[formatter setDateFormat:@"HH:mm"];
	NSString* timePortion = [formatter stringFromDate:aTime];
	
	[formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSString* dateTime = [NSString stringWithFormat:@"%@ %@", datePortion, timePortion];
	return [formatter dateFromString:dateTime];
}

-(NSString*)monthString{
	NSDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
	return [[SharedValues monthNames] objectAtIndex:info.month - 1];
//	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
//	[formatter setDateFormat:@"MMMM"];
//	return [formatter stringFromDate:self];
}

-(NSString*)yearString{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy"];
	return [formatter stringFromDate:self];
}

-(NSDateInformation)dateInformation{
	return [self dateInformationWithTimeZone:nil];
}

-(NSDateInformation)dateInformationWithTimeZone:(NSTimeZone*)tz{
	NSDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	if( tz ) [gregorian setTimeZone:tz];
	NSDateComponents *comps = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:self];
	
	info.day = [comps day];
	info.month = [comps month];
	info.year = [comps year];
	
	info.hour = [comps hour];
	info.minute = [comps minute];
	info.second = [comps second];
	
	info.weekday = [comps weekday];
	
	[gregorian release], gregorian = nil;
	return info;
}

+(NSDate*)dateFromDateInformation:(NSDateInformation)info{
	return [NSDate dateFromDateInformation:info timeZone:nil];
}

+(NSDate*)dateFromDateInformation:(NSDateInformation)info timeZone:(NSTimeZone*)tz{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	if( tz ) [gregorian setTimeZone:tz];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	comps.day = info.day;
	comps.month = info.month;
	comps.year = info.year;
	
	comps.hour = info.hour;
	comps.minute = info.minute;
	comps.second = info.second;
	
	NSDate* date = [gregorian dateFromComponents:comps];
	
	[gregorian release], gregorian = nil;
	
	return date;
}

+(NSString*)dateInformationDescriptionWithInformation:(NSDateInformation)info{
	return [NSString stringWithFormat:@"%d %d %d %d:%d:%d", info.month, info.day, info.year, info.hour, info.minute, info.second];
}

#pragma mark Private Functions

+(NSDate*)lastOfMonthDate{
	return [[NSDate date] lastOfMonthDate];
}

-(int)weekday{
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:self];
	int weekday = [comps weekday];
	[gregorian release], gregorian = nil;
	return weekday;
}

-(NSDate*)timelessDate{
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	[gregorian release], gregorian = nil;
	return [gregorian dateFromComponents:comps];
}

-(NSDate*)monthlessDate{
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[gregorian release], gregorian = nil;
	return [gregorian dateFromComponents:comps];
}

@end