#import "YTDataSource.h"

#import "PetHunterPickerTitle.h"

@protocol PetHunterAccount<YTDataSource, PetHunterPickerTitle>

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* password;

@end

@interface PetHunterAccount : YTDataSource<PetHunterAccount>

@end

extern NSString* PetHunterAccount_Name;
extern NSString* PetHunterAccount_Password;