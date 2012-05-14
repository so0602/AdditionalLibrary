#import "PetHunterGlobalManager.h"

#import "PetHunterLoginInput.h"
#import "PetHunterMissionInput.h"
#import "PetHunterMissionDetailInput.h"
#import "PetHunterMissionCompleteInput.h"

#import "PetHunterMission.h"
#import "PetHunterMissionDetail.h"

static NSString* UD_Accounts = @"UD_Accounts";

static PetHunterGlobalManager* defaultManager = nil;

ASIHTTPRequest* PHRequest(RequestType tag, NSDictionary* postData);

@interface PetHunterGlobalManager ()<ASIHTTPRequestDelegate>

@property (nonatomic, retain, readwrite) NSArray<PetHunterAccount>* accounts;
@property (nonatomic, retain, readwrite) PetHunterAccount* selectedAccount;
@property (nonatomic, retain) PetHunterAccount* loggingInAccount;

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
-(void)addAccount:(PetHunterAccount*)account{
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
		[accounts replaceObjectAtIndex:index withObject:account];
	}
	
	self.accounts = [NSArray arrayWithArray:accounts];
	
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.accounts];
	SetObjectToUserDefaults(data, UD_Accounts);
}

-(ASIHTTPRequest*)loginWithUid:(NSString*)uid password:(NSString*)password{
	PetHunterLoginInput* dataSource = [PetHunterLoginInput dataSourceWithDictionary:nil];
	dataSource.uid = uid;
	dataSource.password = password;
	
	self.loggingInAccount = [PetHunterAccount dataSourceWithDictionary:nil];
	self.loggingInAccount.name = uid;
	self.loggingInAccount.password = password;
	
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

#pragma mark - ASIHTTPRequestDelegate

-(void)requestStarted:(ASIHTTPRequest *)request{
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack networkIndicator:TRUE];
	
	if( [request isKindOfClass:ASIFormDataRequest.class] ){
		NSLog(@"request: %@", ((ASIFormDataRequest*)request).urlForGetMethod);
	}
}

-(void)requestFinished:(ASIHTTPRequest *)request{
	[SVProgressHUD dismiss];
	
	switch( request.tag ){
		case RequestType_Login:
		{
			NSArray* array = [request.responseString componentsSeparatedByString:@"	"];
			if( array.count != 2 ){
				[self requestFailed:request];
			}else{
				NSString* name = [array objectAtIndex:1];
				if( [self.loggingInAccount.name isEqualToString:name] ){
					PostNotification(LoginDidSuccessNotification, name);
					self.selectedAccount = self.loggingInAccount;
					[self addAccount:self.loggingInAccount];
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
	}
}

-(void)requestFailed:(ASIHTTPRequest *)request{
	[SVProgressHUD dismiss];
	
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
			PostNotification(MissionCompleteDidSuccessNotification, request.responseString);
			break;
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_accounts release];
	[_selectedAccount release];
	[_loggingInAccount release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize accounts = _accounts;
@synthesize selectedAccount = _selectedAccount;
@synthesize loggingInAccount = _loggingInAccount;

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