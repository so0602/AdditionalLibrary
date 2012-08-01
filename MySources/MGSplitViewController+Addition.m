#import "MGSplitViewController+Addition.h"

@implementation MGSplitViewController (Addition)

-(UIBarButtonItem*)barButtonItem{
	if( !_barButtonItem ){
		_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Master", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showMasterPopover:)];
	}
	return _barButtonItem;
}

-(UIPopoverController*)hiddenPopoverController{
	if( !_hiddenPopoverController ){
		_hiddenPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.masterViewController];
	}
	return _hiddenPopoverController;
}

@end