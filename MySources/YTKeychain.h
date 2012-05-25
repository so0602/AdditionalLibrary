#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface YTKeychain : NSObject{
@private
	NSString* _serviceName;
}

+(id)keychain;

-(id)initWithServiceName:(NSString*)serviceName; // default: your bundle id
+(id)keychainWithServiceName:(NSString*)serviceName; // default: your bundle id

-(NSMutableDictionary*)newSearchDictionary:(NSString*)identifier;
-(NSData*)searchKeychainCopyMatching:(NSString*)identifier;
-(BOOL)createKeychainValue:(NSString*)password forIdentifier:(NSString*)identifier;
-(BOOL)updateKeychainValue:(NSString*)password forIdentifier:(NSString*)identifier;
-(void)deleteKeychainValue:(NSString*)identifier;

@end