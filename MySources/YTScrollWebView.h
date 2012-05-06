#import <UIKit/UIKit.h>

@class YTScrollWebView;

@protocol YTScrollWebViewDelegate<NSObject>

-(void)webViewDidScroll:(YTScrollWebView*)webView;

@end

@interface YTScrollWebView : UIWebView{
@private
	id<YTScrollWebViewDelegate> _scrollViewDelegate;
}

@property (nonatomic, retain) id<YTScrollWebViewDelegate> scrollViewDelegate;

@end