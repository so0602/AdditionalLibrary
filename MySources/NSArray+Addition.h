#import <Foundation/Foundation.h>

typedef enum{
	FilteringOption_None = 0,
	FilteringOption_Case = 1,
	FilteringOption_Diacritic = 1 << 1,
}FilteringOption;

@interface NSArray (Addition)

-(id)firstObject;

-(id)lastSecondObject;

#pragma mark - Filtering

-(NSArray*)filteredArrayWithMatch:(NSString*)match;
-(NSArray*)filteredArrayWithMatch:(NSString*)match inclusive:(BOOL)inclusive;

-(NSArray*)filteredArrayWithIn:(NSArray*)objects;
-(NSArray*)filteredArrayWithIn:(NSArray*)objects inclusive:(BOOL)inclusive;

-(NSArray*)filteredArrayWithContains:(NSString*)contains;
-(NSArray*)filteredArrayWithContains:(NSString*)contains inclusive:(BOOL)inclusive;
-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option;
-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive;

/*
 like
 e.g.: image.png ==> filter equal to 'image.png' objects
 e.g.: *image.png* ==> filter contains 'image.png' objects, same as filteredArrayWithContains:
 e.g.: image-\\d{3}\\.png ==> filter ignore 3 digits objects
 */
-(NSArray*)filteredArrayWithLike:(NSString*)like;
-(NSArray*)filteredArrayWithLike:(NSString*)like inclusive:(BOOL)inclusive;
-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option;
-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive;

@end