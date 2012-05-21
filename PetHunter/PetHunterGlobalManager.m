#import "PetHunterGlobalManager.h"

#import "PetHunterActionInput.h"
#import "PetHunterBattleInput.h"
#import "PetHunterChallengeInput.h"
#import "PetHunterChallengeGiftInput.h"
#import "PetHunterFriendInput.h"
#import "PetHunterFriendGiftInput.h"
#import "PetHunterItemList.h"
#import "PetHunterLoginInput.h"
#import "PetHunterMapListInput.h"
#import "PetHunterMissionInput.h"
#import "PetHunterMissionDetailInput.h"
#import "PetHunterMissionCompleteInput.h"
#import "PetHunterSpecialBattleInput.h"
#import "PetHunterUseItemInput.h"

#import "PetHunterAction.h"
#import "PetHunterBattle.h"
#import "PetHunterChallenge.h"
#import "PetHunterChallengeGift.h"
#import "PetHunterFriend.h"
#import "PetHunterFriendGift.h"
#import "PetHunterItemListInput.h"
#import "PetHunterMapList.h"
#import "PetHunterMission.h"
#import "PetHunterMissionDetail.h"
#import "PetHunterSpecialBattle.h"
#import "PetHunterUseItem.h"

static NSString* UD_Accounts = @"UD_Accounts";
static NSString* UD_AutoUpdateAction = @"UD_AutoUpdateAction";

static PetHunterGlobalManager* defaultManager = nil;

ASIHTTPRequest* PHRequest(RequestType tag, NSDictionary* postData);

@interface PetHunterGlobalManager ()<ASIHTTPRequestDelegate>

@property (nonatomic, retain, readwrite) NSArray<PetHunterAccount>* accounts;
@property (nonatomic, retain, readwrite) PetHunterAccount* selectedAccount;
@property (nonatomic, retain) PetHunterAccount* loggingInAccount;

@property (nonatomic, retain) UILabel* actionLabel;
@property (nonatomic, retain) UILabel* latestUpdateActionLabel;

@property (nonatomic, retain) NSMutableArray* friends;
-(ASIHTTPRequest*)friends:(NSUInteger)page;

@property (nonatomic, retain) NSMutableArray* friendGiftRequests;
@property (nonatomic, retain) NSMutableArray* friendGifts;
-(void)removeFriendGiftRequest:(ASIHTTPRequest*)request;

@property (nonatomic, retain) NSMutableArray* challenges;
@property (nonatomic, retain) NSMutableArray* battles;

@property (nonatomic, retain) NSMutableArray* items;
-(ASIHTTPRequest*)items:(NSUInteger)page;
@property (nonatomic, retain) NSMutableArray* useItemRequests;
@property (nonatomic, retain) NSMutableArray* useItems;
-(void)removeUseItemRequest:(ASIHTTPRequest*)request;

@end

@implementation PetHunterGlobalManager

+(id)defaultManager{
	if( !defaultManager ){
		defaultManager = [[self alloc] init];
	}
	return defaultManager;
}

-(NSArray<PetHunterAccount>*)accounts{
	if( !_accounts ){
		NSData* data = ObjectForKeyFromUserDefaults(UD_Accounts);
		_accounts = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
	}
	return _accounts;
}

-(void)addAccount:(PetHunterAccount*)account override:(BOOL)override{
	if( account.name.length == 0 || account.password.length == 0 ){
		return;
	}
	
	NSMutableArray* accounts = [NSMutableArray array];
	if( self.accounts.count ){
		[accounts addObjectsFromArray:self.accounts];
	}
	
	NSInteger index = [accounts indexOfObject:account];
	if( index == NSNotFound ){
		[accounts addObject:account];
	}else{
		if( override ){
			YTLogF();
			[accounts replaceObjectAtIndex:index withObject:account];
		}else{
			YTLogF();
			self.selectedAccount = [accounts objectAtIndex:index];
		}
	}
	
	self.accounts = [NSArray arrayWithArray:accounts];
	
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.accounts];
	SetObjectToUserDefaults(data, UD_Accounts);
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isAutoUpdateAction{
	return self.selectedAccount.autoUpdateAction;
}
-(void)setAutoUpdateAction:(BOOL)autoUpdateAction{
	self.selectedAccount.autoUpdateAction = autoUpdateAction;
	[self addAccount:self.selectedAccount override:TRUE];
}

-(BOOL)isAutoBattle{
	return self.selectedAccount.autoBattle;
}
-(void)setAutoBattle:(BOOL)autoBattle{
	self.selectedAccount.autoBattle = autoBattle;
	[self addAccount:self.selectedAccount override:TRUE];
}

-(NSInteger)autoNormalBattleMap{
	return self.selectedAccount.autoNormalBattleMap;
}
-(void)setAutoNormalBattleMap:(NSInteger)autoNormalBattleMap{
	self.selectedAccount.autoNormalBattleMap = autoNormalBattleMap;
	[self addAccount:self.selectedAccount override:TRUE];
}

-(NSInteger)autoSpecialBattleMap{
	return self.selectedAccount.autoSpecialBattleMap;
}
-(void)setAutoSpecialBattleMap:(NSInteger)autoSpecialBattleMap{
	self.selectedAccount.autoSpecialBattleMap = autoSpecialBattleMap;
	[self addAccount:self.selectedAccount override:TRUE];
}

-(BOOL)isAutoChallenge{
	return self.selectedAccount.autoChallenge;
}
-(void)setAutoChallenge:(BOOL)autoChallenge{
	self.selectedAccount.autoChallenge = autoChallenge;
	[self addAccount:self.selectedAccount override:TRUE];
}

-(ASIHTTPRequest*)loginWithUid:(NSString*)uid password:(NSString*)password{
	PetHunterLoginInput* dataSource = [PetHunterLoginInput dataSourceWithDictionary:nil];
	dataSource.uid = uid;
	dataSource.password = password;
	
	self.loggingInAccount = [PetHunterAccount dataSourceWithDictionary:nil];
	self.loggingInAccount.name = uid;
	self.loggingInAccount.password = password;
	
	NSDictionary* dictionary = dataSource.postData;
	NSString* path = [DocumentPath() stringByAppendingPathComponent:@"TEMP"];
	[dictionary writeToFile:path atomically:TRUE];
	NSData* data = [NSData dataWithContentsOfFile:path];
	NSLog(@"data: %@", [data description]);
	ASIHTTPRequest* request = PHRequest(RequestType_Login, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(ASIHTTPRequest*)showMissionList{
	PetHunterMissionInput* dataSource = [PetHunterMissionInput dataSourceWithDictionary:nil];
	
	ASIHTTPRequest* request = PHRequest(RequestType_Mission, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(ASIHTTPRequest*)missionDetail:(NSString*)missionId{
	PetHunterMissionDetailInput* dataSource = [PetHunterMissionDetailInput dataSourceWithDictionary:nil];
	dataSource.gid = missionId;
	
	ASIHTTPRequest* request = PHRequest(RequestType_MissionDetail, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(ASIHTTPRequest*)missionComplete:(NSString*)missionId ttype:(NSString*)ttype{
	PetHunterMissionCompleteInput* dataSource = [PetHunterMissionCompleteInput dataSourceWithDictionary:nil];
	dataSource.gid = missionId;
	dataSource.ttype = ttype;
	
	ASIHTTPRequest* request = PHRequest(RequestType_MissionComplete, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(ASIHTTPRequest*)action:(UILabel*)actionLabel latestUpdateAction:(UILabel*)latestUpdateActionLabel{
	PetHunterActionInput* dataSource = [PetHunterActionInput dataSourceWithDictionary:nil];
	
	self.actionLabel = actionLabel;
	self.latestUpdateActionLabel = latestUpdateActionLabel;
	
	ASIHTTPRequest* request = PHRequest(RequestType_Action, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(void)friendList{
	[self friends:1];
}

-(void)friendGifts:(NSArray*)friends{
	if( friends.count == 0 ){
		[UIAlertView showAlertViewWithTitle:ApplicationName() message:@"沒有禮物。" cancelButtonTitle:@"確定"];
		self.friendGifts = nil;
		return;
	}
	
	self.friendGifts = [NSMutableArray array];
	self.friendGiftRequests = [NSMutableArray array];
	[friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PetHunterFriend* friend = obj;
		
		PetHunterFriendGiftInput* dataSource = [PetHunterFriendGiftInput dataSourceWithDictionary:nil];
		dataSource.gid = friend.ID;
		
		ASIHTTPRequest* request = PHRequest(RequestType_FriendsGift, dataSource.postData);
		[request performSelector:@selector(startAsynchronous) withObject:nil afterDelay:0.1 * (idx + 1)];
		[self.friendGiftRequests addObject:request];
	}];
}

-(ASIHTTPRequest*)challengeGift{
	PetHunterChallengeGiftInput* dataSource = [PetHunterChallengeGiftInput dataSourceWithDictionary:nil];
	ASIHTTPRequest* request = PHRequest(RequestType_ChallengeGift, dataSource.postData);
	[request startAsynchronous];
	[self.friendGiftRequests addObject:request];
	return request;
}

-(ASIHTTPRequest*)challenge{
	PetHunterChallengeInput* dataSource = [PetHunterChallengeInput dataSourceWithDictionary:nil];
	ASIHTTPRequest* request = PHRequest(RequestType_Challenge, dataSource.postData);
	[request startAsynchronous];
	return request;
}

-(ASIHTTPRequest*)specialBattle{
	PetHunterSpecialBattleInput* dataSource = [PetHunterSpecialBattleInput dataSourceWithDictionary:nil];
	dataSource.hid = [NSString stringWithFormat:@"%d", self.autoSpecialBattleMap];
	ASIHTTPRequest* request = PHRequest(RequestType_SpecialBattle, dataSource.postData);
	[request startAsynchronous];
	return request;
}

-(ASIHTTPRequest*)battle{
	PetHunterBattleInput* dataSource = [PetHunterBattleInput dataSourceWithDictionary:nil];
	dataSource.hid = [NSString stringWithFormat:@"%d", self.autoNormalBattleMap];
	ASIHTTPRequest* request = PHRequest(RequestType_Battle, dataSource.postData);
	[request startAsynchronous];
	return request;
}

-(void)itemList{
	[self items:1];
}

-(void)useItem:(PetHunterItem*)item useAll:(BOOL)useAll{
	self.useItemRequests = [NSMutableArray array];
	self.useItems = [NSMutableArray array];
	for( int i = 0; i < [item.count intValue]; i++ ){
		PetHunterUseItemInput* dataSource = [PetHunterUseItemInput dataSourceWithDictionary:nil];
		dataSource.index = item.ID;
		dataSource.index1 = @"0";
		ASIHTTPRequest* request = PHRequest(RequestType_UseItem, dataSource.postData);
		[self.useItemRequests addObject:request];
		[request performSelector:@selector(startAsynchronous) withObject:nil afterDelay:0.1 * (i + 1)];
		if( !useAll ) break;
	}
}

#pragma mark - Private Functions

-(ASIHTTPRequest*)friends:(NSUInteger)page{
	if( page == 1 ){
		self.friends = [NSMutableArray array];
	}
	PetHunterFriendInput* dataSource = [PetHunterFriendInput dataSourceWithDictionary:nil];
	
	dataSource.page = [NSString stringWithFormat:@"%d", page];
	
	ASIHTTPRequest* request = PHRequest(RequestType_Friends, dataSource.postData);
	[request startAsynchronous];
	
	return request;
}

-(void)removeFriendGiftRequest:(ASIHTTPRequest*)request{
	[self.friendGiftRequests removeObject:request];
	
	if( self.friendGiftRequests.count == 0 ){
		PostNotification(FriendGiftsDidSuccessNotification, self.friendGifts);
		self.friendGifts = nil;
	}
}

-(ASIHTTPRequest*)items:(NSUInteger)page{
	if( page == 1 ){
		self.items = [NSMutableArray array];
	}
	PetHunterItemListInput* dataSource = [PetHunterItemListInput dataSourceWithDictionary:nil];
	
	dataSource.page = [NSString stringWithFormat:@"%d", page];
	
	ASIHTTPRequest* request = PHRequest(RequestType_ItemList, dataSource.postData);
	[request startAsynchronous];

	return request;
}

-(void)removeUseItemRequest:(ASIHTTPRequest*)request{
	[self.useItemRequests removeObject:request];
	
	if( self.useItemRequests.count == 0 ){
		PostNotification(UseItemDidSuccessNotification, self.useItems);
		self.useItems = nil;
	}
}

#pragma mark - ASIHTTPRequestDelegate

-(void)requestStarted:(ASIHTTPRequest *)request{
	if( self.selectedAccount && self.autoUpdateAction && request.tag == RequestType_Action){
		SharedApplication().networkActivityIndicatorVisible = TRUE;
	}else{
		[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack networkIndicator:TRUE];
	}
	
	if( [request isKindOfClass:ASIFormDataRequest.class] ){
		NSLog(@"request: %@", ((ASIFormDataRequest*)request).urlForGetMethod);
	}
}

-(void)requestFinished:(ASIHTTPRequest *)request{
	[SVProgressHUD dismiss];
	SharedApplication().networkActivityIndicatorVisible = FALSE;
	
	switch( request.tag ){
		case RequestType_Login:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count != 2 ){
				[self requestFailed:request];
			}else{
				NSString* name = [array objectAtIndex:1];
				if( [self.loggingInAccount.name isEqualToString:name] ){
					self.selectedAccount = self.loggingInAccount;
					[self addAccount:self.loggingInAccount override:FALSE];
					PostNotification(LoginDidSuccessNotification, name);
				}else{
					[self requestFailed:request];
				}
			}
			self.loggingInAccount = nil;
			break;
		}
		case RequestType_Mission:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			NSMutableArray* missions = [NSMutableArray array];
			[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
				if( idx != 0 ){
					PetHunterMission* mission = [PetHunterMission dataSourceWithDictionary:nil];
					mission.resultString = obj;
					[missions addObject:mission];
				}
			}];
			if( missions.count == 0 ) missions = nil;
			PostNotification(MissionListDidSuccessNotification, missions);
			break;
		}
		case RequestType_MissionDetail:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count == 2 ){
				PetHunterMissionDetail* dataSource = [PetHunterMissionDetail dataSourceWithDictionary:nil];
				dataSource.resultString = [array objectAtIndex:1];
				PostNotification(MissionDetailDidSuccessNotification, dataSource);
			}else{
				[self requestFailed:request];
			}
			break;
		}
		case RequestType_MissionComplete:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count == 2 ){
				NSString* result = [array objectAtIndex:1];
				if( [result isEqualToString:@"ok"] ){
					PostNotification(MissionCompleteDidSuccessNotification, nil);
				}else{
					[self requestFailed:request];
				}
			}else{
				[self requestFailed:request];
			}
			break;
		}
		case RequestType_Action:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count == 2 ){
				PetHunterAction* dataSource = [PetHunterAction dataSourceWithDictionary:nil];
				dataSource.resultString = [array objectAtIndex:1];
				self.actionLabel.text = [NSString stringWithFormat:@"狩獵值 %@/%@ 擂台值 %@/%@", dataSource.hunting, dataSource.maxHunting, dataSource.challenge, dataSource.maxChallenge];
				
				NSDateFormatter* dateFormatter = [NSDateFormatter dateFormatterWithDateFormat:@"HH:mm:ss"];
				self.latestUpdateActionLabel.text = [dateFormatter stringFromDate:[NSDate date]];
				
			}else{
				[self requestFailed:request];
			}
			break;
		}
		case RequestType_Friends:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count > 2 ){
				NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, array.count - 2)];
				array = [array objectsAtIndexes:indexSet];
				NSMutableArray* friends = [NSMutableArray array];
				[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
					PetHunterFriend* dataSource = [PetHunterFriend dataSourceWithDictionary:nil];
					dataSource.resultString = obj;
					[friends addObject:dataSource];
				}];
				[self.friends addObjectsFromArray:friends];
				if( friends.count == 6 ){
					[self friends:self.friends.count / 6 + 1];
				}else{
					PostNotification(FriendListDidSuccessNotification, self.friends);
					self.friends = nil;
				}
			}else{
				PostNotification(FriendListDidSuccessNotification, self.friends);
				self.friends = nil;
			}
			break;
		}
		case RequestType_FriendsGift:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count == 2 ){
				PetHunterFriendGift* dataSource = [PetHunterFriendGift dataSourceWithDictionary:nil];
				dataSource.resultString = [array objectAtIndex:1];
				
				[self.friendGifts addObject:dataSource];
			}
			[self removeFriendGiftRequest:request];
			break;
		}
		case RequestType_ChallengeGift:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count == 2 ){
				PetHunterChallengeGift* dataSource = [PetHunterChallengeGift dataSourceWithDictionary:nil];
				dataSource.resultString = [array objectAtIndex:1];
				PostNotification(ChallengeGiftDidSuccessNotification, dataSource);
			}else{
				[self requestFailed:request];
			}
			break;
		}
		case RequestType_Challenge:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			PetHunterChallenge* dataSource = [PetHunterChallenge dataSourceWithDictionary:nil];
			if( array.count > 5 ){
				NSString* string = [array objectAtIndex:1];
				dataSource.actionCount = string;
				string = [array objectAtIndex:2];
				dataSource.maxActionCount = string;
				string = [array objectAtIndex:3];
				dataSource.challengeCount = string;
				string = [array objectAtIndex:4];
				dataSource.maxChallengeCount = string;
			}
			
			if( !self.challenges ) self.challenges = [NSMutableArray array];
			[self.challenges addObject:dataSource];
			
			if( self.autoChallenge && [dataSource.challengeCount intValue] != 0 ){	
				[self challenge];
			}else{
				NSString* string = [array objectAtIndex:5];
				if( [string rangeOfString:@":"].length != 0 ){
					[self.challenges removeObject:dataSource];
				}
				PostNotification(ChallengeDidSuccessNotification, self.challenges);
				self.challenges = nil;
			}
			break;
		}
		case RequestType_SpecialBattle: case RequestType_Battle:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			PetHunterBattle* dataSource = [PetHunterBattle dataSourceWithDictionary:nil];
			if( array.count >= 6 ){
				dataSource.actionCount = [array objectAtIndex:1];
				dataSource.maxActionCount = [array objectAtIndex:2];
				dataSource.challengeCount = [array objectAtIndex:3];
				dataSource.maxChallengeCount = [array objectAtIndex:4];
				dataSource.resultString = [array objectAtIndex:5];
			}
			if( array.count >= 7 ){
				dataSource.bonus = [array objectAtIndex:6];
			}
			if( !self.battles ){
				self.battles = [NSMutableArray array];
			}
			[self.battles addObject:dataSource];
			
			if( [dataSource.exp intValue] == 0 && [dataSource.actionCount intValue] == 0 ){
				NSString* string = [array objectAtIndex:5];
				if( [string rangeOfString:@":"].length != 0 ){
					[self.battles removeObject:dataSource];
				}
				PostNotification(BattleDidSuccessNotification, self.battles);
				self.battles = nil;
			}else{
				if( [dataSource.boost intValue] == 100 && [dataSource.actionCount intValue] >= 5 ){
					[self specialBattle];
				}else if( [dataSource.actionCount intValue] > 5 ){
					[self battle];
				}else{
					NSString* string = [array objectAtIndex:5];
					if( [string rangeOfString:@":"].length != 0 ){
						[self.battles removeObject:dataSource];
					}
					PostNotification(BattleDidSuccessNotification, self.battles);
					self.battles = nil;
				}
			}
			break;
		}
		case RequestType_ItemList:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count > 2 ){
				NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, array.count - 2)];
				array = [array objectsAtIndexes:indexSet];
				NSMutableArray* items = [NSMutableArray array];
				[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
					PetHunterItem* dataSource = [PetHunterItem dataSourceWithDictionary:nil];
					dataSource.resultString = obj;
					[items addObject:dataSource];
				}];
				[self.items addObjectsFromArray:items];
				if( items.count == 9 ){
					[self items:self.items.count / 9 + 1];
				}else{
					PostNotification(ItemListDidSuccessNotification, self.items);
					self.items = nil;
				}
			}else{
				PostNotification(ItemListDidSuccessNotification, self.items);
				self.items = nil;
			}
			break;
		}
		case RequestType_UseItem:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count >= 2 ){
				PetHunterUseItem* dataSource = [PetHunterUseItem dataSourceWithDictionary:nil];
				dataSource.resultString = [array objectAtIndex:1];
				
				[self.useItems addObject:dataSource];
			}
			[self removeUseItemRequest:request];
			break;
		}
	}
}

-(void)requestFailed:(ASIHTTPRequest *)request{
	[SVProgressHUD dismiss];
	SharedApplication().networkActivityIndicatorVisible = FALSE;
	
	switch( request.tag ){
		case RequestType_Login:
			self.loggingInAccount = nil;
			PostNotification(LoginDidFailNotification, request.responseString);
			break;
		case RequestType_Mission:
			PostNotification(MissionListDidFailNotification, request.responseString);
			break;
		case RequestType_MissionDetail:
			PostNotification(MissionDetailDidFailNotification, request.responseString);
			break;
		case RequestType_MissionComplete:
			PostNotification(MissionCompleteDidFailNotification, request.responseString);
			break;
		case RequestType_Action:
			PostNotification(ActionDidFailNotification, request.responseString);
			break;
		case RequestType_Friends:
			PostNotification(FriendListDidFailNotification, request.responseString);
			break;
		case RequestType_FriendsGift:
//			PostNotification(FriendGiftsDidFailNotification, request.responseString);
			[self removeFriendGiftRequest:request];
			break;
		case RequestType_ChallengeGift:
			PostNotification(ChallengeGiftDidFailNotification, request.responseString);
			break;
		case RequestType_Challenge:
			PostNotification(ChallengeDidFailNotification, request.responseString);
			break;
		case RequestType_SpecialBattle: case RequestType_Battle:
			PostNotification(BattleDidFailNotification, request.responseString);
			break;
		case RequestType_ItemList:
			PostNotification(ItemListDidFailNotification, request.responseString);
			break;
		case RequestType_UseItem:
//			PostNotification(UseItemDidFailNotification, request.responseString);
			[self removeUseItemRequests:request];
			break;
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_accounts release];
	[_selectedAccount release];
	[_loggingInAccount release];
	[_actionLabel release];
	[_latestUpdateActionLabel release];
	[_friends release];
	[_friendGiftRequests release];
	[_friendGifts release];
	[_challenges release];
	[_battles release];
	[_items release];
	[_useItemRequests release];
	[_useItems release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize accounts = _accounts;
@synthesize selectedAccount = _selectedAccount;
@synthesize loggingInAccount = _loggingInAccount;
@synthesize actionLabel = _actionLabel;
@synthesize latestUpdateActionLabel = _latestUpdateActionLabel;
@synthesize friends = _friends;
@synthesize friendGiftRequests = _friendGiftRequests;
@synthesize friendGifts = _friendGifts;
@synthesize challenges = _challenges;
@synthesize battles = _battles;
@synthesize items = _items;
@synthesize useItemRequests = _useItemRequests;
@synthesize useItems = _useItems;

@end
	
PetHunterGlobalManager* PHManager(void){
	return (PetHunterGlobalManager*)[PetHunterGlobalManager defaultManager];
}

ASIHTTPRequest* PHRequest(RequestType tag, NSDictionary* postData){
	NSURL* domain = [NSURL URLWithString:Domain];
	ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:domain];
	[request addPostValues:postData];
	request.tag = tag;
	request.delegate = PHManager();
	return request;
}