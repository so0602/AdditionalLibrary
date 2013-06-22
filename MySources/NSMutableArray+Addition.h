#import "NSArray+Addition.h"

@interface NSMutableArray (Addition)

-(void)addNilObject:(id)obj;
-(void)addNilObjectsFromArray:(NSArray *)otherArray;

#pragma mark - Filtering

-(void)filterWithMatch:(NSString*)match;
-(void)filterWithMatch:(NSString*)match inclusive:(BOOL)inclusive;

-(void)filterWithIn:(NSArray*)objects;
-(void)filterWithIn:(NSArray*)objects inclusive:(BOOL)inclusive;

-(void)filterWithContains:(NSString*)contains;
-(void)filterWithContains:(NSString*)contains inclusive:(BOOL)inclusive;
-(void)filterWithContains:(NSString*)contains filteringOption:(FilteringOption)option;
-(void)filterWithContains:(NSString*)contains filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive;

/*
 like
 e.g.: image.png ==> filter equal to 'image.png' objects
 e.g.: *image.png* ==> filter contains 'image.png' objects, same as filterWithContains:
 e.g.: image-\\d{3}\\.png ==> filter ignore 3 digits objects
 */
-(void)filterWithLike:(NSString*)like;
-(void)filterWithLike:(NSString*)like inclusive:(BOOL)inclusive;
-(void)filterWithLike:(NSString*)like filteringOption:(FilteringOption)option;
-(void)filterWithLike:(NSString*)like filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive;

@end