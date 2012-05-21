#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PetHunterAccount.h"
#import "PetHunterItem.h"

@interface PetHunterGlobalManager : NSObject

+(id)defaultManager;

@property (nonatomic, retain, readonly) NSArray<PetHunterAccount>* accounts;
-(void)addAccount:(PetHunterAccount*)account override:(BOOL)override;

@property (nonatomic, retain, readonly) PetHunterAccount* selectedAccount;

@property (nonatomic, assign, getter=isAutoUpdateAction) BOOL autoUpdateAction;
@property (nonatomic, assign, getter=isAutoBattle) BOOL autoBattle;
@property (nonatomic, assign) NSInteger autoNormalBattleMap;
@property (nonatomic, assign) NSInteger autoSpecialBattleMap;
@property (nonatomic, assign, getter=isAutoChallenge) BOOL autoChallenge;

-(ASIHTTPRequest*)loginWithUid:(NSString*)uid password:(NSString*)password;
-(ASIHTTPRequest*)showMissionList;
-(ASIHTTPRequest*)missionDetail:(NSString*)missionId;
-(ASIHTTPRequest*)missionComplete:(NSString*)missionId ttype:(NSString*)ttype;
-(ASIHTTPRequest*)action:(UILabel*)actionLabel latestUpdateAction:(UILabel*)latestUpdateActionLabel;
-(void)friendList;
-(void)friendGifts:(NSArray*)friends;
-(ASIHTTPRequest*)challengeGift;
-(ASIHTTPRequest*)challenge;
-(ASIHTTPRequest*)specialBattle;
-(ASIHTTPRequest*)battle;
-(void)itemList;
-(void)useItem:(PetHunterItem*)item useAll:(BOOL)useAll;

@end

PetHunterGlobalManager* PHManager(void);