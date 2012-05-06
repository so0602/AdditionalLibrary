#import "UIWebView+Addition.h"

static NSString* youTubeFormat = @"<html><head><body style=\"margin:0\"><embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed></body></html>";

#define youTubeUrl(url) [NSString stringWithFormat:youTubeFormat, (url), self.width, self.height]

@implementation UIWebView (Addition)

-(void)loadYouTubeUrl:(NSString*)url{
	[self loadHTMLString:youTubeUrl(url) baseURL:nil];
}

@end