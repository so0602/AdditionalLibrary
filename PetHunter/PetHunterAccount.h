#import "YTDataSource.h"

#import "PetHunterPickerTitle.h"

@protocol PetHunterAccount<YTDataSource, PetHunterPickerTitle>

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, assign) BOOL autoUpdateAction;
@property (nonatomic, assign) BOOL autoBattle;
@property (nonatomic, assign) NSInteger autoNormalBattleMap;
@property (nonatomic, assign) NSInteger autoSpecialBattleMap;
@property (nonatomic, assign) BOOL autoChallenge;

@end

@interface PetHunterAccount : YTDataSource<PetHunterAccount>

@end

extern NSString* PetHunterAccount_Name;
extern NSString* PetHunterAccount_Password;
extern NSString* PetHunterAccount_AutoUpdateAction;
extern NSString* PetHunterAccount_AutoBattle;
extern NSString* PetHunterAccount_AutoNormalBattleMap;
extern NSString* PetHunterAccount_AutoSpecialBattleMap;
extern NSString* PetHunterAccount_AutoChallenge;