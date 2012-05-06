#import "NSCalendarDot.h"

@class UICalendarMonthTiles;
@protocol UICalendarMonthViewDelegate, UICalendarMonthViewDataSource;

@interface UICalendarMonthView : UIView{
	UICalendarMonthTiles *currentTile, *oldTile;
	UIButton *leftArrow, *rightArrow;
	UIImageView *topBackground, *shadow;
	UILabel *monthYear;
	UIFont* dayFont;
	UIColor *todayFontColor, *currentMonthFontColor, *anotherMonthFontColor, *selectedDayFontColor;
	NSArray* weekLabels;
	
	UIScrollView *tileBox;
	BOOL sunday;
	
	NSObject<UICalendarMonthViewDelegate>* delegate;
	NSObject<UICalendarMonthViewDataSource>* dataSource;
	
	CGSize cellSize;
}

-(id)initWithSundayAsFirst:(BOOL)aSunday;

@property (nonatomic, assign) NSObject<UICalendarMonthViewDelegate>* delegate;
@property (nonatomic, assign) NSObject<UICalendarMonthViewDataSource>* dataSource;

@property (readonly) UIImageView *topBackground;
@property (readonly) UILabel *monthYear;
@property (readonly) NSArray* weekLabels;
@property (readonly) UIButton *leftArrow;
@property (readonly) UIButton *rightArrow;
@property (readonly) UIImageView *shadow;

@property (nonatomic, retain) UIFont* dayFont;
@property (nonatomic, retain) UIColor *todayFontColor, *currentMonthFontColor, *anotherMonthFontColor, *selectedDayFontColor;

-(NSDate*)dateSelected;
-(NSDate*)monthDate;
-(void)selectDate:(NSDate*)date;
-(void)reload;

@end

@protocol UICalendarMonthViewDelegate

-(void)calendarMonthView:(UICalendarMonthView*)monthView dotsWillChangeFromDate:(NSDate*)start toDate:(NSDate*)end;

@optional
-(void)calendarMonthView:(UICalendarMonthView*)monthView didSelectDate:(NSDate*)date;
-(BOOL)calendarMonthView:(UICalendarMonthView*)monthView monthShouldChange:(NSDate*)month animated:(BOOL)animated;
-(void)calendarMonthView:(UICalendarMonthView*)monthView monthWillChange:(NSDate*)month animated:(BOOL)animated;
-(void)calendarMonthView:(UICalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated;
@end

@protocol UICalendarMonthViewDataSource
//-(NSArray*)calendarMonthView:(UICalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate;
-(NSArray*)calendarMonthView:(UICalendarMonthView*)monthView dotsFromDate:(NSDate*)date;
@end