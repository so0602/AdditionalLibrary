#import <Foundation/Foundation.h>

#import "PetHunterAccount.h"

@interface PetHunterGlobalManager : NSObject

+(id)defaultManager;

@property (nonatomic, retain, readonly) NSArray<PetHunterAccount>* accounts;
-(void)addAccount:(PetHunterAccount*)account;

@property (nonatomic, retain, readonly) PetHunterAccount* selectedAccount;

-(ASIHTTPRequest*)loginWithUid:(NSString*)uid password:(NSString*)password;
-(ASIHTTPRequest*)showMissionList;
-(ASIHTTPRequest*)missionDetail:(NSString*)missionId;
-(ASIHTTPRequest*)missionComplete:(NSString*)missionId ttype:(NSString*)ttype;


@end

PetHunterGlobalManager* PHManager(void);