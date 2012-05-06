#import "MFMailComposeViewController+Addition.h"

@implementation MFMailComposeViewController (Addition)

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate{
	return [MFMailComposeViewController mailComposeViewControllerWithDelegate:delegate subject:nil message:nil isHTML:FALSE attachments:nil];
}

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject{
	return [MFMailComposeViewController mailComposeViewControllerWithDelegate:delegate subject:subject message:nil isHTML:FALSE attachments:nil];
}

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject message:(NSString*)message isHTML:(BOOL)isHTML{
	return [MFMailComposeViewController mailComposeViewControllerWithDelegate:delegate subject:subject message:message isHTML:isHTML attachments:nil];
}

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate subject:(NSString*)subject message:(NSString*)message isHTML:(BOOL)isHTML attachments:(NSArray<YTMFMailAttachment>*)attachments{
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;
	
	if( subject ) [controller setSubject:subject];
	if( message ) [controller setMessageBody:message isHTML:isHTML];
	if( attachments ){
		for( id<YTMFMailAttachment> attachment in attachments ){
			[controller addAttachmentData:[attachment attachment] mimeType:[attachment mimeType] fileName:[attachment filename]];
		}
	}
	return [controller autorelease];
}

+(id)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate dataSource:(id<YTMFMailDataSource>)dataSource{
	return [MFMailComposeViewController mailComposeViewControllerWithDelegate:delegate subject:[dataSource subject] message:[dataSource messageBody] isHTML:[dataSource isHTML] attachments:(NSArray<YTMFMailAttachment>*)[dataSource attachments]];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTMFMailAttachment

@implementation YTMFMailAttachment

@synthesize attachment = _attachment;
@synthesize mimeType = _mimeType;
@synthesize filename = _filename;

#pragma mark Memory Management

-(void)dealloc{
	self.attachment = nil;
	self.mimeType = nil;
	self.filename = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTMFMailDataSource

@implementation YTMFMailDataSource

@synthesize subject = _subject;
@synthesize messageBody = _messageBody;
@synthesize isHTML = _isHTML;
@synthesize attachments = _attachments;

#pragma mark Memory Management

-(void)dealloc{
	self.subject = nil;
	self.messageBody = nil;
	self.isHTML = FALSE;
	self.attachments = nil;
	
	[super dealloc];
}

@end