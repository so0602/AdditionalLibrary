#import "PetHunterPickerView.h"

@interface PetHunterPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSArray<PetHunterPickerTitle>* titles;

@property (nonatomic, readonly) IBOutlet UIPickerView* pickerView;
@property (nonatomic, readonly) IBOutlet UIBarButtonItem* cancelButton;
@property (nonatomic, readonly) IBOutlet UIBarButtonItem* confirmButton;

@property (nonatomic, retain) UIPopoverController* popoverController;

@property (nonatomic, getter=isOpen) BOOL open;
@property (nonatomic, assign) NSInteger maxComponents;

@end

@implementation PetHunterPickerView

-(void)reloadData:(NSArray<PetHunterPickerTitle>*)titles{
	[self reloadData:titles maxComponents:1];
}

-(void)reloadData:(NSArray<PetHunterPickerTitle>*)titles maxComponents:(NSInteger)maxComponents{
	self.titles = titles;
	self.maxComponents = maxComponents;
	[self.pickerView reloadAllComponents];
}

-(void)show{
	if( IsIPad() ){
		
	}else{
		UIView* superview = KeyWindow().rootViewController.view;
		UIView* view = [[[UIView alloc] initWithFrame:superview.bounds] autorelease];
		view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
		[superview addSubview:view];
		
		if( !self.superview ){
			self.y = view.height;
			[view addSubview:self];
			view.alpha = 0.0;
			[YTAnimation showView:view duration:0.3];
		}else if( !self.isOpen ){
			view.alpha = 0.0;
			[YTAnimation showView:view duration:0.3];
			self.y = view.height;
		}
		
		[YTAnimation moveView:self toPoint:CGPointMake(0, view.height - self.height) duration:0.3];
	}
}

-(void)dismiss{
	if( IsIPad() ){
		
	}else{
		[YTAnimation hiddenView:self.superview duration:0.3];
		[YTAnimation moveView:self toPoint:CGPointMake(0, self.superview.height) duration:0.3 delegate:self.superview stopSelector:@selector(removeFromSuperview)];
	}
}

#pragma mark - Override Functions

-(void)click:(id)sender{
	[super click:sender];
	
	if( [self.cancelButton isEqual:sender] ){
		if( RespondsToSelector(self.delegate, @selector(cancelButtonDidClick:)) ){
			[self.delegate cancelButtonDidClick:self];
		}else{
			[self dismiss];
		}
	}else if( [self.confirmButton isEqual:sender] ){
		if( RespondsToSelector(self.delegate, @selector(confirmButtonDidClick:selectedTitle:)) ){
			NSInteger index = [self.pickerView selectedRowInComponent:0];
			PetHunterPickerTitle* title = [self.titles objectAtIndex:index];
			[self.delegate confirmButtonDidClick:self selectedTitle:title];
		}else{
			[self dismiss];
		}
	}
}

#pragma mark - Private Functions

-(BOOL)isOpen{
	return self.maxY < self.superview.height;
}

#pragma mark - UIView

-(id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		
	}
	return self;
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return self.maxComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if( component == 0 ) return self.titles.count;
	
	NSInteger index = [pickerView selectedRowInComponent:0];
	if( index == -1 ) index = 0;
	
	PetHunterPickerTitle* title = [self.titles objectAtIndex:index];
	for( int i = 1; i < component; i++ ){
		NSInteger index = [pickerView selectedRowInComponent:i];
		if( index == -1 ) index = 0;
		
		if( !title ){
			title = [self.titles objectAtIndex:index];
		}else{
			title = [title.subtitles objectAtIndex:index];
		}
	}
	return title.subtitles.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if( component == 0 ){
		PetHunterPickerTitle* title = [self.titles objectAtIndex:row];
		return title.title;
	}
	
	NSInteger index = [pickerView selectedRowInComponent:0];
	if( index == -1 ) index = 0;
	
	PetHunterPickerTitle* title = [self.titles objectAtIndex:index];
	for( int i = 1; i < component; i++ ){
		NSInteger index = [pickerView selectedRowInComponent:i];
		if( index == -1 ) index = 0;
		
		if( !title ){
			title = [self.titles objectAtIndex:index];
		}else{
			title = [title.subtitles objectAtIndex:index];
		}
	}
	title = [title.subtitles objectAtIndex:row];
	return title.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	for( int i = 1; i < self.maxComponents - 1; i++ ){
		[pickerView reloadComponent:i];
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_delegate release];
	[_targetView release];
	
	[_titles release];
	
	[_pickerView release];
	[_cancelButton release];
	[_confirmButton release];
	
	[_popoverController release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize delegate = _delegate;
@synthesize targetView = _targetView;

@synthesize titles = _titles;

@synthesize pickerView = _pickerView;
@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;

@synthesize popoverController = _popoverController;

@synthesize open = _open;
@synthesize maxComponents = _maxComponents;

@end