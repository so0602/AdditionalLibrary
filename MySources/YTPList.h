#import "YTDefineValues.h"

@interface YTPList : NSObject{
@private
	NSMutableDictionary* _dictionary;
	NSString* _path;
	BOOL _autoSave; //Default TRUE
}

-(id)initWithPath:(NSString*)path;
-(id)initWithPath:(NSString*)path autoSave:(BOOL)autoSave;

-(void)setObject:(NSObject*)obj forKey:(id)key;
-(id)objectForKey:(id)key;
-(void)removeObjectForKey:(id)key;
-(void)removeAllObjects;

-(void)save;

@property (nonatomic, assign) BOOL autoSave;
@property (nonatomic, readonly) NSArray* allKeys;
@property (nonatomic, readonly) NSArray* allValues;

@end