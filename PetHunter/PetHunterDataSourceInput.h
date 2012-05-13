#import "YTDataSource.h"

@protocol PetHunterDataSourceInput<YTDataSource>

@property (nonatomic, retain) NSString* uid;
@property (nonatomic, retain, readonly) NSString* time;
@property (nonatomic, retain, readonly) NSString* method;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain, readonly) NSString* type;
@property (nonatomic, retain, readonly) NSString* showId;

@property (nonatomic, retain, readonly) NSMutableDictionary* postData;

@end

@interface PetHunterDataSourceInput : YTDataSource<PetHunterDataSourceInput>

@end

extern NSString* PetHunterDataSourceInput_Uid;
extern NSString* PetHunterDataSourceInput_Time;
extern NSString* PetHunterDataSourceInput_Method;
extern NSString* PetHunterDataSourceInput_Password;
extern NSString* PetHunterDataSourceInput_Type;
extern NSString* PetHunterDataSourceInput_ShowId;