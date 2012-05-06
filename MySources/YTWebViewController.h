#import <UIKit/UIKit.h>

@interface YTWebViewController : UIViewController<UIWebViewDelegate>{
	IBOutlet UIWebView* _webView;
	
	NSURL* _url;
	
	NSTimeInterval _timeoutInterval;
}

@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, copy) NSURL* url;

@property (nonatomic, assign) NSTimeInterval timeoutInterval; //Default 60.0f

-(void)loadUrl:(NSURL*)url;

@end