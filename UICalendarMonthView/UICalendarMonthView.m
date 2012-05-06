#import "UICalendarMonthView.h"
#import "NSDate+NSCategory.h"

#define CalendarViewBundleImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"UICalendarMonthView.bundle/Images/%@", imageName]]
#define CalendarTimeZone [NSTimeZone timeZoneForSecondsFromGMT:28800]

@interface NSDate (CalendarCategory)

-(NSDate*)firstOfMonth;
-(NSDate*)nextMonth;
-(NSDate*)previousMonth;

@end

@implementation NSDate (CalendarCategory)

-(NSDate*)firstOfMonth{
	NSDateInformation info = [self dateInformationWithTimeZone:CalendarTimeZone];
	info.day = 1;
	info.minute = info.second = info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
}

-(NSDate*)nextMonth{
	NSDateInformation info = [self dateInformationWithTimeZone:CalendarTimeZone];
	info.month++;
	if( info.month > 12 ){
		info.month = 1;
		info.year++;
	}
	info.minute = info.second = info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
}

-(NSDate*)previousMonth{
	NSDateInformation info = [self dateInformationWithTimeZone:CalendarTimeZone];
	info.month--;
	if( info.month < 1 ){
		info.month = 12;
		info.year--;
	}
	info.minute = info.second = info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
}

@end

@interface UICalendarMonthTiles : UIView{
	id target;
	SEL action;
	
	int firstOfPrev, lastOfPrev;
	NSArray *marks;
	int today;
	BOOL markWasOnToday;
	
	int selectedDay, selectedPortion;
	
	int firstWeekday, daysInMonth;
	UILabel *dot;
	UILabel *currentDay;
	UIImageView *selectedImageView;
	BOOL startOnSunday;
	NSDate *monthDate;
	
	CGSize cellSize;
	
	UIFont* dayFont;
	UIColor *todayFontColor, *currentMonthFontColor, *anotherMonthFontColor, *selectedDayFontColor;
}

@property (readonly) NSDate *monthDate;
@property (nonatomic, retain) UIFont* dayFont;
@property (nonatomic, retain) UIColor *todayFontColor, *currentMonthFontColor, *anotherMonthFontColor, *selectedDayFontColor;

-(id)initWithMonth:(NSDate*)date marks:(NSArray*)marks startDayOnSunday:(BOOL)sunday;
-(void)setTarget:(id)target action:(SEL)action;

-(void)selectDay:(int)day;
-(NSDate*)dateSelected;

+(NSArray*)rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday;

@end

#define dotFontSize 18.0
#define dateFontSize 22.0

@interface UICalendarMonthTiles (Private)

@property (readonly) UIImageView *selectedImageView;
@property (readonly) UILabel *currentDay;
@property (readonly) UILabel *dot;

@end

@implementation UICalendarMonthTiles

@synthesize monthDate;
@synthesize dayFont;
@synthesize todayFontColor, currentMonthFontColor, anotherMonthFontColor, selectedDayFontColor;

-(id)initWithMonth:(NSDate*)date marks:(NSArray*)aMarks startDayOnSunday:(BOOL)sunday{
	if( ![super initWithFrame:CGRectZero] ) return nil;
	
	cellSize = CalendarViewBundleImage(@"calendar_date_tile.png").size;
	self.dayFont = [UIFont boldSystemFontOfSize:dateFontSize];
	
	self.todayFontColor = self.selectedDayFontColor = [UIColor whiteColor];
	self.currentMonthFontColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
	self.anotherMonthFontColor = [UIColor grayColor];
	
	firstOfPrev = -1;
	marks = [aMarks retain];
	monthDate = [date retain];
	startOnSunday = sunday;
	
	NSDateInformation info = [monthDate dateInformationWithTimeZone:CalendarTimeZone];
	firstWeekday = info.weekday;
	
	NSDate *prev = [monthDate previousMonth];
	daysInMonth = [[monthDate nextMonth] daysBetweenDate:monthDate];
	
	int row = (daysInMonth + info.weekday - 1);
	if( info.weekday == 1 && !sunday ) row = daysInMonth + 6;
	if( !sunday ) row--;
	
	row = (row / 7) + ((row % 7 == 0) ? 0 : 1);
	float h = 44 * row;
	
	NSDateInformation todayInfo = [[NSDate date] dateInformation];
	today = info.month == todayInfo.month && info.year == todayInfo.year ? todayInfo.day : -5;
	
	int preDayCnt = [prev daysBetweenDate:monthDate];
	if( firstWeekday > 1 && sunday ){
		firstOfPrev = preDayCnt - firstWeekday + 2;
		lastOfPrev = preDayCnt;
	}else if( !sunday && firstWeekday != 2 ){
		if( firstWeekday == 1 ) firstOfPrev = preDayCnt - 5;
		else firstOfPrev = preDayCnt - firstWeekday + 3;
		lastOfPrev = preDayCnt;
	}
	
	self.frame = CGRectMake(0, 1, 320, h+1);
	
	[self.selectedImageView addSubview:self.currentDay];
//	[self.selectedImageView addSubview:self.dot];
	self.multipleTouchEnabled = FALSE;
	
	return self;
}

-(void)setTarget:(id)aTarget action:(SEL)aAction{
	target = aTarget;
	action = aAction;
}

-(CGRect)rectForCellAtIndex:(int)index{
	int row = index / 7;
	int column = index % 7;
	
	return CGRectMake(column * cellSize.width, row * cellSize.height + 6, 47, 45);
}

//-(void)drawTileInRect:(CGRect)rect day:(int)day mark:(BOOL)mark font:(UIFont*)font1 font2:(UIFont*)font2{
//	NSString* str = [NSString stringWithFormat:@"%d", day];
//	
//	rect.size.height -= 2;
//	[str drawInRect:rect withFont:font1 lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
//	
//	if( mark ){
//		rect.size.height = 10;
//		rect.origin.y += 18;
//		
//		[@"•" drawInRect:rect withFont:font2 lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
//	}
//}

-(void)drawTileInRect:(CGRect)rect day:(int)day marks:(NSArray*)aMarks font:(UIFont *)font dotFont:(UIFont*)dotFont currentColor:(UIColor*)currentColor{
	NSString* str = [NSString stringWithFormat:@"%d", day];
	rect.size.height -= 2;
	if( [currentColor isEqual:self.todayFontColor] ) [[UIColor blackColor] set];
	else [[UIColor whiteColor] set];
	rect.origin.y += 1;
	[str drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	[currentColor set];
	rect.origin.y -= 1;
	[str drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	
	if( [aMarks isKindOfClass:[NSArray class]] ){
		for( int i = 0; i < aMarks.count; i++ ){
			NSCalendarDot* mark = [aMarks objectAtIndex:i];
//			CGPoint center = CGPointMake(rect.origin.x + (rect.size.width * (i + 1) / (aMarks.count + 1)), rect.origin.y + 40);
			CGPoint center = CGPointMake(rect.origin.x + (rect.size.width * (i + 1) / (aMarks.count + 1)), rect.origin.y + 40);
			CGRect dotRect = CGRectMake(center.x - rect.size.width / 2, center.y - rect.size.height / 2, rect.size.width, rect.size.height);
			font = [UIFont fontWithName:dotFont.fontName size:mark.size];
			if( ![mark.color isEqual:[UIColor clearColor]] ){
				[[UIColor whiteColor] set];
				[@"•" drawInRect:CGRectMake(dotRect.origin.x, dotRect.origin.y + 1, dotRect.size.width, dotRect.size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
				[mark.color set];
				[@"•" drawInRect:dotRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
			}
			
		}
		[currentColor set];
	}
}

-(void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage* tile = CalendarViewBundleImage(@"calendar_date_tile.png");
	CGRect r = CGRectZero;
	r.size = tile.size;
	CGContextDrawTiledImage(context, r, tile.CGImage);
	if( today > 0 ){
		int pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		int index = today + pre - 1;
		CGRect r = [self rectForCellAtIndex:index];
		r.origin.y -= 7;
		[CalendarViewBundleImage(@"calendar_today_tile.png") drawInRect:r];
	}
	
	int index = 0;
	
	UIFont* font = self.dayFont;
	UIFont* font2 = [UIFont boldSystemFontOfSize:dotFontSize];
	UIColor* color = self.anotherMonthFontColor;
	
	if( firstOfPrev > 0 ){
		[color set];
		for( int i = firstOfPrev; i <= lastOfPrev; i++ ){
			r = [self rectForCellAtIndex:index];
			[self drawTileInRect:r day:i marks:index < marks.count ? [marks objectAtIndex:index] : nil font:font dotFont:font2 currentColor:color];
//			[self drawTileInRect:r day:i mark:marks.count > 0 ? [[marks objectAtIndex:index] boolValue] : FALSE font:font font2:font2];
			index++;
		}
	}
	
	color = self.currentMonthFontColor;
	[color set];
	
	for( int i = 1; i <= daysInMonth; i++ ){
		r = [self rectForCellAtIndex:index];
		color = today == i ? self.todayFontColor : self.currentMonthFontColor; 
//		if( today == i ) [self.todayFontColor set];
		[self drawTileInRect:r day:i marks:index < marks.count ? [marks objectAtIndex:index] : nil font:font dotFont:font2 currentColor:color];
//		[self drawTileInRect:r day:i mark:marks.count > 0 ? [[marks objectAtIndex:index] boolValue] : FALSE font:font font2:font2];
//		if( today == i ) [color set];
		index++;
	}
	
	[self.anotherMonthFontColor set];
	int i = 1;
	while( index % 7 != 0 ){
		r = [self rectForCellAtIndex:index];
		[self drawTileInRect:r day:i marks:index < marks.count ? [marks objectAtIndex:index] : nil font:font dotFont:font2 currentColor:self.anotherMonthFontColor];
//		[self drawTileInRect:r day:i mark:marks.count > 0 ? [[marks objectAtIndex:index] boolValue] : FALSE font:font font2:font2];
		i++;
		index++;
	}
}

-(void)drawDotsAtSelectDay:(NSArray*)dots{
	if( [dots isKindOfClass:[NSArray class]] ){
		for( UIView* view in selectedImageView.subviews ){
			if( ![view isEqual:currentDay] ) [view removeFromSuperview];
		}
		for( int i = 0; i < dots.count; i++ ){
			NSCalendarDot* mark = [dots objectAtIndex:i];
			UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.font = [UIFont boldSystemFontOfSize:mark.size];
			label.textColor = mark.color;
			label.backgroundColor = [UIColor clearColor];
			label.text = @"•";
			if( ![mark.color isEqual:[UIColor clearColor]] ){
				label.shadowColor = [UIColor blackColor];
				label.shadowOffset = CGSizeMake(0, -1);
			}
			[label sizeToFit];
			label.center = CGPointMake(selectedImageView.frame.size.width * (i + 1) / (dots.count + 1), 37);
			[selectedImageView addSubview:label];
			[label release], label = nil;
		}
	}
}

-(void)selectDay:(int)day{
	int pre = firstOfPrev < 0 ? 0 : lastOfPrev - firstOfPrev + 1;
	
	int total = day + pre;
	int row = total / 7;
	int column = (total % 7) - 1;
	
	selectedDay = day;
	selectedPortion = 1;
	
	if( day == today ){
		self.currentDay.shadowOffset = self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = CalendarViewBundleImage(@"calendar_today_selected_tile.png");
		markWasOnToday = TRUE;
	}else if( markWasOnToday ){
		self.dot.shadowOffset = self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = CalendarViewBundleImage(@"calendar_date_selected_tile.png");
		markWasOnToday = FALSE;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d", day];
	
	[self drawDotsAtSelectDay:[marks objectAtIndex:row * 7 + column]];
	
	
//	if( marks.count > 0 ){
//		if( [[marks objectAtIndex:row * 7 + column] boolValue] ) [self.selectedImageView addSubview:self.dot];
//		else [self.dot removeFromSuperview];
//	}else [self.dot removeFromSuperview];
	
	if( column < 0 ){
		column = 6;
		row--;
	}
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column * cellSize.width);
	r.origin.y = (row * cellSize.height) - 1;
	
	self.selectedImageView.frame = r;
}

-(NSDate*)dateSelected{
	if( selectedDay < 1 || selectedPortion != 1 ) return nil;
	
	NSDateInformation info = [monthDate dateInformationWithTimeZone:CalendarTimeZone];
	info.hour = info.minute = info.second = 0;
	info.day = selectedDay;
	return [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
}

+(NSArray*)rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday{
	NSDate *firstDate, *lastDate;
	
	NSDateInformation info = [date dateInformationWithTimeZone:CalendarTimeZone];
	info.day = 1;
	info.hour = info.minute = info.second = 0;
	
	NSDate *currentMonth = [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
	info = [currentMonth dateInformationWithTimeZone:CalendarTimeZone];
	
	NSDate *previousMonth = [currentMonth previousMonth];
	NSDate *nextMonth = [currentMonth nextMonth];
	
	if( info.weekday > 1 && sunday ){
		NSDateInformation info2 = [previousMonth dateInformationWithTimeZone:CalendarTimeZone];
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];
		info2.day = preDayCnt - info.weekday + 2;
		firstDate = [NSDate dateFromDateInformation:info2 timeZone:CalendarTimeZone];
	}else if( !sunday && info.weekday != 2 ){
		NSDateInformation info2 = [previousMonth dateInformationWithTimeZone:CalendarTimeZone];
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];
		if( info.weekday == 1 ) info2.day = preDayCnt - 5;
		else info2.day = preDayCnt - info.weekday + 3;
		firstDate = [NSDate dateFromDateInformation:info2 timeZone:CalendarTimeZone];
	}else firstDate = currentMonth;
	
	int daysInMonth = [currentMonth daysBetweenDate:nextMonth];
	info.day = daysInMonth;
	NSDate *lastInMonth = [NSDate dateFromDateInformation:info timeZone:CalendarTimeZone];
	NSDateInformation lastDateInfo = [lastInMonth dateInformationWithTimeZone:CalendarTimeZone];
	
	if( lastDateInfo.weekday < 7 && sunday ){
		lastDateInfo.day = 7 - lastDateInfo.weekday;
		lastDateInfo.month++;
		lastDateInfo.weekday = 0;
		if( lastDateInfo.month > 12 ){
			lastDateInfo.month = 1;
			lastDateInfo.year++;
		}
		lastDate = [NSDate dateFromDateInformation:lastDateInfo timeZone:CalendarTimeZone];
	}else if( !sunday && lastDateInfo.weekday != 1 ){
		lastDateInfo.day = 8 - lastDateInfo.weekday;
		lastDateInfo.month++;
		if( lastDateInfo.month > 12 ){
			lastDateInfo.month = 1;
			lastDateInfo.year++;
		}
		lastDate = [NSDate dateFromDateInformation:lastDateInfo timeZone:CalendarTimeZone];
	}else lastDate = lastInMonth;
	
	return [NSArray arrayWithObjects:firstDate, lastDate, nil];
}

-(void)reactToTouch:(UITouch*)touch down:(BOOL)down{
	CGPoint p = [touch locationInView:self];
	if( p.y > self.bounds.size.height || p.y < 0 ) return;
	
	int column = fmodf(p.x, self.size.width) / cellSize.width, row = p.y / cellSize.height;
	
	int day = 1, portion = 0;
	if( row == (int)(self.bounds.size.height / cellSize.height) ) row--;
	
	int first = firstWeekday - 1;
	if( !startOnSunday && first == 0 ) first = 7;
	if( !startOnSunday ) first--;
	
	if( row == 0 && column < first ) day = firstOfPrev + column;
	else{
		portion = 1;
		day = row * 7 + column - firstWeekday + 2;
		if( !startOnSunday ) day++;
		if( !startOnSunday && first == 6 ) day -= 7;
	}
	if( portion > 0 && day > daysInMonth ){
		portion = 2;
		day = day - daysInMonth;
	}
	
	if( portion != 1 ){
		self.selectedImageView.image = CalendarViewBundleImage(@"calendar_date_tile_gray.png");
		markWasOnToday = TRUE;
	}else if( portion == 1 && day == today ){
		self.currentDay.shadowOffset = self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = CalendarViewBundleImage(@"calendar_today_selected_tile.png");
		markWasOnToday = TRUE;
	}else if( markWasOnToday ){
		self.dot.shadowOffset = self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = CalendarViewBundleImage(@"calendar_date_selected_tile.png");
		markWasOnToday = FALSE;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d", day];
	
	[self drawDotsAtSelectDay:[marks objectAtIndex:row * 7 + column]];
	
//	if( marks.count > 0 ){
//		if( [[marks objectAtIndex:row * 7 + column] boolValue] ) [self.selectedImageView addSubview:self.dot];
//		else [self.dot removeFromSuperview];
//	}else [self.dot removeFromSuperview];
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = column * cellSize.width;
	r.origin.y = (row * cellSize.height) - 1;
	self.selectedImageView.frame = r;
	
//	if( day == selectedDay && selectedPortion == portion ) return;
	
	if( portion == 1 ){
		selectedDay = day;
		selectedPortion = portion;
		[target performSelector:action withObject:[NSArray arrayWithObject:[NSNumber numberWithInt:day]]];
	}else if( down ){
		[target performSelector:action withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:day], [NSNumber numberWithInt:portion], nil]];
		selectedDay = day;
		selectedPortion = portion;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:FALSE];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//	[self reactToTouch:[touches anyObject] down:FALSE];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:TRUE];
}

-(UILabel*)currentDay{
	if( !currentDay ){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y -= 2;
		currentDay = [[UILabel alloc] initWithFrame:r];
		currentDay.text = @"1";
		currentDay.textColor = self.todayFontColor;
		currentDay.backgroundColor = [UIColor clearColor];
		currentDay.font = self.dayFont;
		currentDay.textAlignment = UITextAlignmentCenter;
		currentDay.shadowColor = [UIColor darkGrayColor];
		currentDay.shadowOffset = CGSizeMake(0, -1);
	}
	return currentDay;
}

-(UILabel*)dot{
	if( !dot ){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y += 29;
		r.size.height -= 31;
		dot = [[UILabel alloc] initWithFrame:r];
		
		dot.text = @"•";
		dot.textColor = [UIColor whiteColor];
		dot.backgroundColor = [UIColor clearColor];
		dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
		dot.textAlignment = UITextAlignmentCenter;
		dot.shadowColor = [UIColor darkGrayColor];
		dot.shadowOffset = CGSizeMake(0, -1);
	}
	return dot;
}

-(UIImageView*)selectedImageView{
	if( !selectedImageView ){
		selectedImageView = [[UIImageView alloc] initWithImage:CalendarViewBundleImage(@"calendar_date_selected_tile.png")];
	}
	return selectedImageView;
}

-(void)setDayFont:(UIFont*)font{
	[dayFont release], dayFont = nil;
	dayFont = [font retain];
	currentDay.font = dayFont;
	[self setNeedsLayout];
}

-(void)setTodayFontColor:(UIColor*)aColor{
	[todayFontColor release], todayFontColor = nil;
	todayFontColor = [aColor retain];
	[self setNeedsLayout];
}

-(void)setCurrentMonthFontColor:(UIColor*)aColor{
	[currentMonthFontColor release], currentMonthFontColor = nil;
	currentMonthFontColor = [aColor retain];
	[self setNeedsLayout];
}

-(void)setAnotherMonthFontColor:(UIColor*)aColor{
	[anotherMonthFontColor release], anotherMonthFontColor = nil;
	anotherMonthFontColor = [aColor retain];
	[self setNeedsLayout];
}

-(void)setSelectedDayFontColor:(UIColor*)aColor{
	[selectedDayFontColor release], selectedDayFontColor = nil;
	selectedDayFontColor = [aColor retain];
	currentDay.textColor = selectedDayFontColor;
}

#pragma mark Memory Management

-(void)dealloc{
	[currentDay release], currentDay = nil;
	[dot release], dot = nil;
	[selectedImageView release], selectedImageView = nil;
	[marks release], marks = nil;
	[monthDate release], monthDate = nil;
	
	[dayFont release], dayFont = nil;
	[todayFontColor release], todayFontColor = nil;
	[currentMonthFontColor release], currentMonthFontColor = nil;
	[anotherMonthFontColor release], anotherMonthFontColor = nil;
	[selectedDayFontColor release], selectedDayFontColor = nil;
	[super dealloc];
}

@end

@interface UICalendarMonthView (Private)

@property (readonly) UIScrollView *tileBox;

@end

@implementation UICalendarMonthView

@synthesize delegate, dataSource;
@synthesize weekLabels;
@synthesize dayFont;
@synthesize todayFontColor, currentMonthFontColor, anotherMonthFontColor, selectedDayFontColor;

-(id)init{
	self = [self initWithSundayAsFirst:TRUE];
	return self;
}

-(id)initWithSundayAsFirst:(BOOL)aSunday{
	if( !(self = [super initWithFrame:CGRectZero]) ) return nil;
	
	self.backgroundColor = [UIColor grayColor];
	
	sunday = aSunday;
	
	cellSize = CalendarViewBundleImage(@"calendar_date_tile.png").size;
	self.dayFont = [UIFont boldSystemFontOfSize:dateFontSize];
	self.todayFontColor = self.selectedDayFontColor = [UIColor whiteColor];
	self.currentMonthFontColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
	self.anotherMonthFontColor = [UIColor grayColor];
	
	currentTile = [[[UICalendarMonthTiles alloc] initWithMonth:[[NSDate date] firstOfMonth] marks:nil startDayOnSunday:sunday] autorelease];
	currentTile.dayFont = self.dayFont;
	currentTile.todayFontColor = self.todayFontColor;
	currentTile.selectedDayFontColor = self.selectedDayFontColor;
	currentTile.currentMonthFontColor = self.currentMonthFontColor;
	currentTile.anotherMonthFontColor = self.anotherMonthFontColor;
	
	[currentTile setTarget:self action:@selector(tile:)];
	
	CGRect r = CGRectMake(0, 0, self.tileBox.bounds.size.width, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y);
	
	self.frame = r;
	
	[currentTile retain];
	
	[self addSubview:self.topBackground];
	[self.tileBox addSubview:currentTile];
	[self addSubview:self.tileBox];
	
//	NSDate *date = [NSDate date];
//	self.monthYear.text = [NSString stringWithFormat:@"%@", [date monthString]];
//	self.monthYear.text = [NSString stringWithFormat:@"%@ %@", [date monthString], [date yearString]];
	[self addSubview:self.monthYear];
	
	[self addSubview:self.leftArrow];
	[self addSubview:self.rightArrow];
	[self addSubview:self.shadow];
	self.shadow.frame = CGRectMake(0, self.frame.size.height - self.shadow.frame.size.height + 21, self.shadow.frame.size.width, self.shadow.frame.size.height);
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"eee"];
	[formatter setTimeZone:CalendarTimeZone];
	
	NSDateInformation sund;
	sund.day = 5;
	sund.month = 12;
	sund.year = 2010;
	sund.hour = sund.minute = sund.second = sund.weekday = 0;
	
	NSTimeZone* tz = CalendarTimeZone;
	NSString* sun = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 6;
	NSString* mon = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 7;
	NSString* tue = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 8;
	NSString* wed = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 9;
	NSString* thu = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 10;
	NSString* fri = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 11;
	NSString* sat = [formatter stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	[formatter release], formatter = nil;
	
	NSArray *array = nil;
	if( sunday ) array = [NSArray arrayWithObjects:sun, mon, tue, wed, thu, fri, sat, nil];
	else array = [NSArray arrayWithObjects:mon, tue, wed, thu, fri, sat, sun, nil];
	
	NSMutableArray* _weekLabels = [NSMutableArray array];
	int i = 0;
	for( NSString* text in array ){
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(cellSize.width * i, 79, cellSize.width, 15)];
		[self addSubview:label];
		label.text = text;
		label.textAlignment = UITextAlignmentCenter;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.font = [UIFont systemFontOfSize:11];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
		[_weekLabels addObject:label];
		i++;
		[label release], label = nil;
	}
	[weekLabels release], weekLabels = nil;
	weekLabels = [[NSArray alloc] initWithArray:_weekLabels];
	
	return self;
}

-(NSDate*)dateForMonthChange:(UIView*)sender{
	BOOL isNext = (sender.tag == 1);
	NSDate* nextMonth = isNext ? [currentTile.monthDate nextMonth] : [currentTile.monthDate previousMonth];
	
	NSDateInformation nextInfo = [nextMonth dateInformationWithTimeZone:CalendarTimeZone];
	
	return [NSDate dateFromDateInformation:nextInfo];
}

-(void)changeMonthAnimation:(UIView*)sender{
	BOOL isNext = (sender.tag == 1);
	NSDate* nextMonth = isNext ? [currentTile.monthDate nextMonth] : [currentTile.monthDate previousMonth];
	
//	NSDateInformation nextInfo = [nextMonth dateInformationWithTimeZone:CalendarTimeZone];
	
//	NSDate* localNextMonth = [NSDate dateFromDateInformation:nextInfo];
	
	NSArray* dates = [UICalendarMonthTiles rangeOfDatesInMonthGrid:nextMonth startOnSunday:sunday];
	[delegate calendarMonthView:self dotsWillChangeFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	
	dates = [NSDate datesFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	NSMutableArray* array = [NSMutableArray array];
	for( int i = 0; i < dates.count; i++ ){
		NSArray* dots = [dataSource calendarMonthView:self dotsFromDate:[dates objectAtIndex:i]];
		if( dots ) [array addObject:dots];
		else [array addObject:[NSNull null]];
	}
	
//	NSArray* array = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	
	UICalendarMonthTiles* newTile = [[UICalendarMonthTiles alloc] initWithMonth:nextMonth marks:array startDayOnSunday:sunday];
	newTile.dayFont = self.dayFont;
	newTile.todayFontColor = self.todayFontColor;
	newTile.selectedDayFontColor = self.selectedDayFontColor;
	newTile.currentMonthFontColor = self.currentMonthFontColor;
	newTile.anotherMonthFontColor = self.anotherMonthFontColor;
	
	[newTile setTarget:self action:@selector(tile:)];
	
	int overlap = 0;
	
	if( isNext ) overlap = [newTile.monthDate isEqualToDate:[dates objectAtIndex:0]] ? 0 : cellSize.height;
	else overlap = [currentTile.monthDate compare:[dates lastObject]] != NSOrderedDescending ? cellSize.height : 0;
	
	float y = isNext ? currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap + 2;
	
	newTile.frame = CGRectMake(0, y, newTile.frame.size.width, newTile.frame.size.height);
	newTile.alpha = 0;
	[self.tileBox addSubview:newTile];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	newTile.alpha = 1;
	[UIView commitAnimations];
	
	self.userInteractionEnabled = FALSE;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.4];
	if( isNext ){
		currentTile.frame = CGRectMake(0, -1 * currentTile.bounds.size.height + overlap + 2, currentTile.frame.size.width, currentTile.frame.size.height);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height + self.tileBox.frame.origin.y);
		self.shadow.frame = CGRectMake(0, self.frame.size.height - self.shadow.frame.size.height + 21, self.shadow.frame.size.width, self.shadow.frame.size.height);
	}else{
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height + self.tileBox.frame.origin.y);
		currentTile.frame = CGRectMake(0, newTile.frame.size.height - overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		self.shadow.frame = CGRectMake(0, self.frame.size.height - self.shadow.frame.size.height + 21, self.shadow.frame.size.width, self.shadow.frame.size.height);
	}
	
	[UIView commitAnimations];
	
	oldTile = currentTile;
	currentTile = newTile;
	
//	monthYear.text = [NSString stringWithFormat:@"%@ %@", [localNextMonth monthString], [localNextMonth yearString]];
//	monthYear.text = [NSString stringWithFormat:@"%@", [localNextMonth monthString]];
}

-(void)changeMonth:(UIButton*)sender{
	NSDate* newDate = [self dateForMonthChange:sender];
	if( [delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![delegate calendarMonthView:self monthShouldChange:newDate animated:TRUE] ){
		return;
	}
	
	if( [delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ){
		[delegate calendarMonthView:self monthWillChange:newDate animated:TRUE];
	}
	
	[self changeMonthAnimation:sender];
	if( [delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)] ){
		[delegate calendarMonthView:self monthDidChange:currentTile.monthDate animated:TRUE];
	}
}

-(void)animationEnded{
	self.userInteractionEnabled = TRUE;
	[oldTile removeFromSuperview];
	[oldTile release], oldTile = nil;
}

-(NSDate*)dateSelected{
	return [currentTile dateSelected];
}

-(NSDate*)monthDate{
	return [currentTile monthDate];
}

-(void)selectDate:(NSDate*)date{
	NSDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
	NSDate* month = [date firstOfMonth];
	if( [month isEqualToDate:[currentTile monthDate]] ){
		[currentTile selectDay:info.day];
		return;
	}else{
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![delegate calendarMonthView:self monthShouldChange:month animated:TRUE] ){
			return;
		}
		
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ){
			[delegate calendarMonthView:self monthWillChange:month animated:TRUE];
		}
		
		NSArray* dates = [UICalendarMonthTiles rangeOfDatesInMonthGrid:month startOnSunday:sunday];
		[delegate calendarMonthView:self dotsWillChangeFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
		
		dates = [NSDate datesFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
		NSMutableArray* data = [NSMutableArray array];
		for( int i = 0; i < dates.count; i++ ){
			NSArray* dots = [dataSource calendarMonthView:self dotsFromDate:[dates objectAtIndex:i]];
			if( dots ) [data addObject:dots];
			else [data addObject:[NSNull null]];
		}
//		NSArray* data = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
		
		UICalendarMonthTiles* newTile = [[UICalendarMonthTiles alloc] initWithMonth:month marks:data startDayOnSunday:sunday];
		newTile.dayFont = self.dayFont;
		newTile.todayFontColor = self.todayFontColor;
		newTile.selectedDayFontColor = self.selectedDayFontColor;
		newTile.currentMonthFontColor = self.currentMonthFontColor;
		newTile.anotherMonthFontColor = self.anotherMonthFontColor;
		[newTile setTarget:self action:@selector(tile:)];
		[currentTile removeFromSuperview];
		[currentTile release], currentTile = nil;
		currentTile = newTile;
		[self.tileBox addSubview:currentTile];
//		self.tileBox.frame = CGRectMake(0, cellSize.height, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(0, 95, newTile.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height + self.tileBox.frame.origin.y);
		self.shadow.frame = CGRectMake(0, self.frame.size.height - self.shadow.frame.size.height + 21, self.shadow.frame.size.width, self.shadow.frame.size.height);
//		self.monthYear.text = [NSString stringWithFormat:@"%@", [date monthString]];
//		self.monthYear.text = [NSString stringWithFormat:@"%@ %@", [date monthString], [date yearString]];
		[currentTile selectDay:info.day];
		
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)] ){
			[delegate calendarMonthView:self monthDidChange:date animated:FALSE];
		}
	}
}

-(void)reload{
	NSArray* dates = [UICalendarMonthTiles rangeOfDatesInMonthGrid:[currentTile monthDate] startOnSunday:sunday];
	[delegate calendarMonthView:self dotsWillChangeFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	
	dates = [NSDate datesFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	NSMutableArray* array = [NSMutableArray array];
	for( int i = 0; i < dates.count; i++ ){
		NSArray* dots = [dataSource calendarMonthView:self dotsFromDate:[dates objectAtIndex:i]];
		if( dots ) [array addObject:dots];
		else [array addObject:[NSNull null]];
	}
//	NSArray* array = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	
	UICalendarMonthTiles* refresh = [[[UICalendarMonthTiles alloc] initWithMonth:[currentTile monthDate] marks:array startDayOnSunday:sunday] autorelease];
	refresh.dayFont = self.dayFont;
	refresh.todayFontColor = self.todayFontColor;
	refresh.selectedDayFontColor = self.selectedDayFontColor;
	refresh.currentMonthFontColor = self.currentMonthFontColor;
	refresh.anotherMonthFontColor = self.anotherMonthFontColor;
	[refresh setTarget:self action:@selector(tile:)];
	
	[self.tileBox addSubview:refresh];
	[currentTile removeFromSuperview];
	[currentTile release], currentTile = nil;
	currentTile = [refresh retain];
}

-(void)tile:(NSArray*)array{
	if( array.count < 2 ){
		if( [delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)] ){
			[delegate calendarMonthView:self didSelectDate:[self dateSelected]];
		}
	}else{
		int direction = [[array lastObject] intValue];
		UIButton* button = direction > 1 ? self.rightArrow : self.leftArrow;
		
		NSDate* newMonth = [self dateForMonthChange:button];
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![delegate calendarMonthView:self monthShouldChange:newMonth animated:TRUE] ){
			return;
		}
		
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ){
			[delegate calendarMonthView:self monthWillChange:newMonth animated:TRUE];
		}
		
		[self changeMonthAnimation:button];
		
		int day = [[array objectAtIndex:0] intValue];
		
		NSDateInformation info = [[currentTile monthDate] dateInformationWithTimeZone:CalendarTimeZone];
		info.day = day;
		NSDate* dateForMonth = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		[currentTile selectDay:day];
		
		if( [delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)] ){
			[delegate calendarMonthView:self didSelectDate:dateForMonth];
		}
		
		if( [delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)] ){
			[delegate calendarMonthView:self monthDidChange:dateForMonth animated:TRUE];
		}
	}
}

-(UIImageView*)topBackground{
	if( !topBackground ){
		topBackground = [[UIImageView alloc] initWithImage:CalendarViewBundleImage(@"calendar_top_bar.png")];
		topBackground.contentMode = UIViewContentModeBottom;
	}
	return topBackground;
}

-(UILabel*)monthYear{
	if( !monthYear ){
		monthYear = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.tileBox.frame.size.width, 38)];
		monthYear.textAlignment = UITextAlignmentCenter;
		monthYear.backgroundColor = [UIColor clearColor];
		monthYear.font = [UIFont boldSystemFontOfSize:22];
		monthYear.textColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
	}
	return monthYear;
}

-(UIButton*)leftArrow{
	if( !leftArrow ){
		leftArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		leftArrow.tag = 0;
		[leftArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		[leftArrow setImage:CalendarViewBundleImage(@"calendar_arrow_left.png") forState:UIControlStateNormal];
		[leftArrow scaleViewWithSize:CGSizeMake(40, 40)];
		leftArrow.center = CGPointMake(20, leftArrow.frame.size.height + 30);
	}
	return leftArrow;
}

-(UIButton*)rightArrow{
	if( !rightArrow ){
		rightArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		rightArrow.tag = 1;
		[rightArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		[rightArrow setImage:CalendarViewBundleImage(@"calendar_arrow_right.png") forState:UIControlStateNormal];
		[rightArrow scaleViewWithSize:CGSizeMake(40, 40)];
		rightArrow.center = CGPointMake(self.frame.size.width - 20, rightArrow.frame.size.height + 30);
	}
	return rightArrow;
}

-(UIScrollView*)tileBox{
	if( !tileBox ){
		tileBox = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, 320, currentTile.frame.size.height)];
	}
	return tileBox;
}

-(UIImageView*)shadow{
	if( !shadow ){
		shadow = [[UIImageView alloc] initWithImage:CalendarViewBundleImage(@"calendar_shadow.png")];
	}
	return shadow;
}

-(void)setDayFont:(UIFont*)aDayFont{
	[dayFont release], dayFont = nil;
	dayFont = [aDayFont retain];
	currentTile.dayFont = dayFont;
}

-(void)setTodayFontColor:(UIColor*)aColor{
	[todayFontColor release], todayFontColor = nil;
	todayFontColor = [aColor retain];
	currentTile.todayFontColor = todayFontColor;
}

-(void)setCurrentMonthFontColor:(UIColor*)aColor{
	[currentMonthFontColor release], currentMonthFontColor = nil;
	currentMonthFontColor = [aColor retain];
	currentTile.currentMonthFontColor = currentMonthFontColor;
}

-(void)setAnotherMonthFontColor:(UIColor*)aColor{
	[anotherMonthFontColor release], anotherMonthFontColor = nil;
	anotherMonthFontColor = [aColor retain];
	currentTile.anotherMonthFontColor = anotherMonthFontColor;
}

-(void)setSelectedDayFontColor:(UIColor*)aColor{
	[selectedDayFontColor release], selectedDayFontColor = nil;
	selectedDayFontColor = [aColor retain];
	currentTile.selectedDayFontColor = selectedDayFontColor;
}

#pragma mark Memory Management

-(void)dealloc{
	[shadow release], shadow = nil;
	[topBackground release], topBackground = nil;
	[leftArrow release], leftArrow = nil;
	[monthYear release], monthYear = nil;
	[weekLabels release], weekLabels = nil;
	[rightArrow release], rightArrow = nil;
	[tileBox release], tileBox = nil;
	[currentTile release], currentTile = nil;
	
	[dayFont release], dayFont = nil;
	[todayFontColor release], todayFontColor = nil;
	[currentMonthFontColor release], currentMonthFontColor = nil;
	[anotherMonthFontColor release], anotherMonthFontColor = nil;
	[selectedDayFontColor release], selectedDayFontColor = nil;
	[super dealloc];
}

@end