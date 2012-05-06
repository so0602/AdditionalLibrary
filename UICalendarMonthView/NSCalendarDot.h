@interface NSCalendarDot : NSObject{
	UIColor* color;
	float size;
}

@property (nonatomic, retain) UIColor* color;
@property (nonatomic, assign) float size;

-(id)initWithColor:(UIColor*)aColor size:(float)aSize;
+(NSCalendarDot*)dotWithColor:(UIColor*)aColor size:(float)aSize;

@end