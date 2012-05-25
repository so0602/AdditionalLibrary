#import "YTKeychain.h"

@interface YTKeychain ()

@property (nonatomic, copy) NSString* serviceName;

@end

@implementation YTKeychain

+(id)keychain{
	return [self keychainWithServiceName:nil];
}

-(id)initWithServiceName:(NSString*)serviceName{
	if( self = [super init] ){
		if( !serviceName ){
			serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
		}
		self.serviceName = serviceName;
	}
	return self;
}

+(id)keychainWithServiceName:(NSString*)serviceName{
	return [[[self alloc] initWithServiceName:serviceName] autorelease];
}

-(NSMutableDictionary*)newSearchDictionary:(NSString*)identifier{
	NSMutableDictionary* searchDictionary = [[NSMutableDictionary alloc] init];
	
	[searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
	NSData* encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
	[searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
	[searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
	[searchDictionary setObject:self.serviceName forKey:(id)kSecAttrService];
	
	return searchDictionary;
}

-(NSData*)searchKeychainCopyMatching:(NSString*)identifier{
	NSMutableDictionary* searchDictionary = [self newSearchDictionary:identifier];
	
	[searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	[searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSData* result = nil;
	OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef*)&result);
	[searchDictionary release];
	return result;
}

-(BOOL)createKeychainValue:(NSString*)password forIdentifier:(NSString*)identifier{
	NSMutableDictionary* searchDictionary = [self newSearchDictionary:identifier];
	
	NSData* passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
	[searchDictionary setObject:passwordData forKey:(id)kSecValueData];
	
	OSStatus status = SecItemAdd((CFDictionaryRef)searchDictionary, NULL);
	[searchDictionary release];
	
	return status == errSecSuccess;
}

-(BOOL)updateKeychainValue:(NSString*)password forIdentifier:(NSString*)identifier{
	NSMutableDictionary* searchDictionary = [self newSearchDictionary:identifier];
	NSMutableDictionary* updateDictionary = [[NSMutableDictionary alloc] init];
	
	NSData* passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
	[updateDictionary setObject:passwordData forKey:(id)kSecValueData];
	
	OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary, (CFDictionaryRef)updateDictionary);
	
	[searchDictionary release];
	[updateDictionary release];
	
	return status == errSecSuccess;
}

-(void)deleteKeychainValue:(NSString*)identifier{
	NSMutableDictionary* searchDictionary = [self newSearchDictionary:identifier];
	
	SecItemDelete((CFDictionaryRef)searchDictionary);
	[searchDictionary release];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_serviceName release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize serviceName = _serviceName;

@end