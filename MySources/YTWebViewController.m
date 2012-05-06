#import "YTWebViewController.h"

@implementation YTWebViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
	[super viewDidLoad];
	
	if( !self.webView ){
		self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
		self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.webView.delegate = self;
	}
	
	if( !self.webView.superview ){
		[self.view addSubview:self.webView];
	}
	
	[self loadUrl:self.url];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}

#pragma mark - Override Functions

-(id)init{
	if( self = [super init] ){
		self.timeoutInterval = 60.0f;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		self.timeoutInterval = 60.0f;
	}
	return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
		self.timeoutInterval = 60.0f;
	}
	return self;
}

-(void)loadUrl:(NSURL *)url{
	if( !self.webView ) return;
	
	self.url = url;
	
	NSURLRequest* request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.timeoutInterval];
	[self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	return TRUE;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
	
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	
}

#pragma mark - Memory Management

-(void)dealloc{
	[_webView release];
	[_url release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize webView = _webView;
@synthesize url = _url;
@synthesize timeoutInterval = _timeoutInterval;

@end