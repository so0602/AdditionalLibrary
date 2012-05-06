#import "YTDefineValues.h"

@protocol YTMFMailAttachment, YTMFMailDataSource;

@interface MFMailComposeViewController (Addition)

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate;
+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject;
+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject message:(NSString*)message isHTML:(BOOL)isHTML;
+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject message:(NSString*)message isHTML:(BOOL)isHTML attachments:(NSArray<YTMFMailAttachment>*)attachments;

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate dataSource:(id<YTMFMailDataSource>)dataSource;

@end

@protocol YTMFMailAttachment

-(NSData*)attachment;
-(NSString*)mimeType;
-(NSString*)filename;

@end

@interface YTMFMailAttachment : NSObject<YTMFMailAttachment>{
@private
	NSData* _attachment;
	NSString* _mimeType;
	NSString* _filename;
}

@property (nonatomic, retain) NSData* attachment;
@property (nonatomic, retain) NSString* mimeType;
@property (nonatomic, retain) NSString* filename;

@end

@protocol YTMFMailDataSource

-(NSString*)subject;
-(NSString*)messageBody;
-(BOOL)isHTML;
-(NSArray*)attachments;

@end

@interface YTMFMailDataSource : NSObject<YTMFMailDataSource>{
@private
	NSString* _subject;
	NSString* _messageBody;
	BOOL _isHTML;
	NSArray* _attachments;
}

@property (nonatomic, retain) NSString* subject;
@property (nonatomic, retain) NSString* messageBody;
@property (nonatomic, assign) BOOL isHTML;
@property (nonatomic, retain) NSArray* attachments;

@end