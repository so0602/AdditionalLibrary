#import <Foundation/Foundation.h>

@protocol YTDataSource<NSObject, NSCoding>

@property (nonatomic, retain, readonly) NSDictionary* data;

@end

@interface YTDataSource : NSObject<YTDataSource>{
	NSMutableDictionary* _data;
}

-(id)initWithDictionary:(NSDictionary*)data;
+(id)dataSource;
+(id)dataSourceWithDictionary:(NSDictionary*)data;

+(NSArray*)arrayWithDictionaries:(NSArray*)data;

-(void)modify:(NSDictionary*)dictionary; // Clean all value, & Insert all values from dictionary
-(void)insert:(NSDictionary*)dictionary; // Insert & modify all values from dictionary

@end