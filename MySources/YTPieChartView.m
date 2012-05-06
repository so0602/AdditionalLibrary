#import "YTPieChartView.h"

@interface SliceLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic, assign) double startAngle;
@property (nonatomic, assign) double endAngle;
@property (nonatomic, assign) BOOL isSelected;
-(void)createArcAnimationForKey:(NSString*)key fromValue:(NSNumber*)from toValue:(NSNumber*)to delegate:(id)delegate;

@end

@implementation SliceLayer

-(void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to delegate:(id)delegate{
	CABasicAnimation* arcAnimation = [CABasicAnimation animationWithKeyPath:key];
	NSNumber* currentAngle = [self.presentationLayer valueForKey:key];
	if( !currentAngle ) currentAngle = from;
	arcAnimation.fromValue = currentAngle;
	arcAnimation.toValue = to;
	arcAnimation.delegate = delegate;
	arcAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
	[self addAnimation:arcAnimation forKey:key];
	[self setValue:to forKey:key];
}

#pragma mark - UIView Override

-(NSString*)description{
	return [NSString stringWithFormat:@"value: %f, percentage: =%0.0f, start: %d, end: %d",
			_value, _percentage, _startAngle / M_PI * 180, _endAngle / M_PI * 180];
}

+(BOOL)needsDisplayForKey:(NSString *)key{
	if( [key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"] ){
		return TRUE;
	}else{
		return [super needsDisplayForKey:key];
	}
}

-(id)initWithLayer:(id)layer{
	if( self = [super initWithLayer:layer] ){
		if( [layer isKindOfClass:SliceLayer.class] ){
			SliceLayer* sliceLayer = (SliceLayer*)layer;
			self.startAngle = sliceLayer.startAngle;
			self.endAngle = sliceLayer.endAngle;
		}
	}
	return self;
}

#pragma mark - Memory Management

-(void)dealloc{
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize value = _value;
@synthesize percentage = _percentage;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize isSelected = _isSelected;

@end

@interface YTPieChartView ()

-(void)setSliceSelectedAtIndex:(NSInteger)index;
-(void)setSliceDeselectedAtIndex:(NSInteger)index;

-(void)updateTimerFired:(NSTimer*)timer;
-(SliceLayer*)createSliceLayer;
//-(CGSize)sizeThatFitsString:(NSString*)string;
-(void)updateLabelForLayer:(SliceLayer*)pieLayer value:(CGFloat)value;
-(void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection;
-(NSInteger)getCurrentSelectedOnTouch:(CGPoint)point;

@property (nonatomic, assign) NSInteger selectedSliceIndex;
@property (nonatomic, retain) UIView* pieView;
@property (nonatomic, retain) NSTimer* animationTimer;
@property (nonatomic, retain) NSMutableArray* animations;

@end

@implementation YTPieChartView

static NSUInteger kDefaultSliceZOrder = 100;

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle){
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, center.x, center.y);
	
	CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
	CGPathCloseSubpath(path);
	
	return path;
}

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		self.backgroundColor = UIColor.clearColor;
		self.pieView = [[[UIView alloc] initWithFrame:frame] autorelease];
		[self addSubview:self.pieView];
		
		_selectedSliceIndex = -1;
		_animations = [[NSMutableArray alloc] init];
		
		_animationSpeed = 0.5;
		_startPieAngle = M_PI_2 * 3;
		_selectedSliceStroke = 3.0;
		
		self.pieRadius = MIN(frame.size.width / 2, frame.size.height / 2) - 10;
		self.pieCenter = CGPointMake(frame.size.width / 2, frame.size.height);
		self.labelFont = [UIFont boldSystemFontOfSize:MAX((int)self.pieRadius / 10, 5)];
		_labelRadius = self.pieRadius / 2;
		_selectedSliceOffsetRadius = MAX(10, self.pieRadius / 10);
		
		_showLabel = TRUE;
		_showPercentage = TRUE;
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame center:(CGPoint)center radius:(CGFloat)radius{
	if( self = [super initWithFrame:frame] ){
		self.pieCenter = center;
		self.pieRadius = radius;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		self.backgroundColor = UIColor.clearColor;
		self.pieView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
		[self addSubview:self.pieView];
		
		_selectedSliceIndex = -1;
		_animations = [[NSMutableArray alloc] init];
		
		_animationSpeed = 0.5;
		_startPieAngle = M_PI_2 * 3;
		_selectedSliceStroke = 3.0;
		
		CGRect frame = self.layer.bounds;
		self.pieRadius = MIN(frame.size.width / 2, frame.size.height / 2) - 10;
		self.pieCenter = CGPointMake(frame.size.width / 2, frame.size.height);
		self.labelFont = [UIFont boldSystemFontOfSize:MAX((int)self.pieRadius / 10, 5)];
		_labelRadius = self.pieRadius / 2;
		_selectedSliceOffsetRadius = MAX(10, self.pieRadius / 10);
		
		_showLabel = TRUE;
		_showPercentage = TRUE;
	}
	return self;
}

-(void)reloadData{
	if( !self.dataSource && !self.animationTimer ){
		CALayer* parentLayer = self.pieView.layer;
		NSArray* sliceLayers = parentLayer.sublayers;
		
		_selectedSliceIndex = -1;
		[sliceLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			SliceLayer* layer = (SliceLayer*)obj;
			if( layer.isSelected ){
				[self setSliceDeselectedAtIndex:idx];
			}
		}];
		
		double startToAngle = 0.0;
		double endToAngle = startToAngle;
		
		NSUInteger sliceCount = [self.dataSource numberOfSlicesInPieChartView:self];
		
		double sum = 0.0;
		double values[sliceCount];
		for( int index = 0; index < sliceCount; index++ ){
			values[index] = [self.dataSource pieChartView:self valueForSliceAtIndex:index];
			sum += values[index];
		}
		
		double angles[sliceCount];
		for( int index = 0; index < sliceCount; index++ ){
			double div;
			if( sum == 0 ) div = 0;
			else div = values[index] / sum;
			angles[index] = M_PI * 2 * div;
		}
		
		[CATransaction begin];
		[CATransaction setAnimationDuration:self.animationSpeed];
		
		self.pieView.userInteractionEnabled = FALSE;
		
		__block NSMutableArray* layersToRemove = nil;
		[CATransaction setCompletionBlock:^{
			[layersToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
				[obj removeFromSuperlayer];
			}];
			[layersToRemove removeAllObjects];
			
			for( SliceLayer* layer in self.pieView.layer.sublayers ){
				layer.zPosition = kDefaultSliceZOrder;
			}
			
			self.pieView.userInteractionEnabled = TRUE;
		}];
		
		BOOL isOnStart = (sliceLayers.count == 0 && sliceCount);
		NSInteger diff = sliceCount - sliceLayers.count;
		layersToRemove = [NSMutableArray arrayWithArray:sliceLayers];
		
		BOOL isOnEnd = (sliceLayers.count && (sliceCount == 0 || sum <= 0));
		if( isOnEnd ){
			for( SliceLayer* layer in self.pieView.layer.sublayers ){
				[self updateLabelForLayer:layer value:0];
				[layer createArcAnimationForKey:@"startAngle" fromValue:[NSNumber numberWithDouble:_startPieAngle] toValue:[NSNumber numberWithDouble:_startPieAngle] delegate:self];
				[layer createArcAnimationForKey:@"endAngle" fromValue:[NSNumber numberWithDouble:_startPieAngle] toValue:[NSNumber numberWithDouble:_startPieAngle] delegate:self];
			}
			[CATransaction commit];
			return;
		}
		
		for( int index = 0; index < sliceCount; index++ ){
			SliceLayer* layer;
			double angle = angles[index];
			endToAngle += angle;
			double startFromAngle = _startPieAngle + startToAngle;
			double endFromAngle = _startPieAngle + endToAngle;
			
			if( index >= sliceLayers.count ){
				layer = [self createSliceLayer];
				if( isOnStart ) startFromAngle = endFromAngle = _startPieAngle;
				[parentLayer addSublayer:layer];
				diff--;
			}else{
				SliceLayer* oneLayer = [sliceLayers objectAtIndex:index];
				if( diff == 0 || oneLayer.value == (CGFloat)values[index] ){
					layer = oneLayer;
					[layersToRemove removeObject:layer];
				}else if( diff > 0 ){
					layer = [self createSliceLayer];
					[parentLayer insertSublayer:layer atIndex:index];
					diff--;
				}else if( diff < 0 ){
					while( diff < 0 ){
						[oneLayer removeFromSuperlayer];
						[parentLayer addSublayer:oneLayer];
						diff++;
						oneLayer = [sliceLayers objectAtIndex:index];
						if( oneLayer.value == (CGFloat)values[index] || diff == 0 ){
							layer = oneLayer;
							[layersToRemove removeObject:layer];
							break;
						}
					}
				}
			}
			
			layer.value = values[index];
			layer.percentage = sum ? layer.value / sum : 0;
			UIColor* color = nil;
			if( [self.dataSource respondsToSelector:@selector(pieChartView:colorForSliceAtIndex:)] ){
				color = [self.dataSource pieChartView:self colorForSliceAtIndex:index];
			}
			
			if( !color ){
				color = [UIColor colorWithHue:((index / 8 % 20) / 20.0 + 0.02) saturation:(index % 8 + 3) / 10.0 brightness:91 / 100.0 alpha:1];
			}
			
			layer.fillColor = color.CGColor;
			[self updateLabelForLayer:layer value:values[index]];
			[layer createArcAnimationForKey:@"startAngle" fromValue:[NSNumber numberWithDouble:startFromAngle] toValue:[NSNumber numberWithDouble:startToAngle + _startPieAngle] delegate:self];
			[layer createArcAnimationForKey:@"endAngle" fromValue:[NSNumber numberWithDouble:endFromAngle] toValue:[NSNumber numberWithDouble:endToAngle + _startPieAngle] delegate:self];
			startToAngle = endToAngle;
		}
		[CATransaction setDisableActions:TRUE];
		for( SliceLayer* layer in layersToRemove ){
			layer.fillColor = self.backgroundColor.CGColor;
			layer.delegate = nil;
			layer.zPosition = 0;
			CATextLayer* textLayer = [layer.sublayers objectAtIndex:0];
			textLayer.hidden = TRUE;
		}
		[CATransaction setDisableActions:FALSE];
		[CATransaction commit];
	}
}

-(void)setPieCenter:(CGPoint)pieCenter{
	self.pieView.center = pieCenter;
	_pieCenter = CGPointMake(self.pieView.frame.size.width / 2, self.pieView.frame.size.height / 2);
}

-(void)setPieRadius:(CGFloat)pieRadius{
	_pieRadius = pieRadius;
	CGRect frame = CGRectMake(self.pieCenter.x - pieRadius, self.pieCenter.y - pieRadius, pieRadius * 2, pieRadius * 2);
	_pieCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
	self.pieView.frame = frame;
	self.pieView.layer.cornerRadius = _pieRadius;
}

-(void)setPieBackgroundColor:(UIColor *)color{
	self.pieView.backgroundColor = color;
}

-(void)setShowPercentage:(BOOL)showPercentage{
	_showPercentage = showPercentage;
	for( SliceLayer* layer in self.pieView.layer.sublayers ){
		CATextLayer* textLayer = [layer.sublayers objectAtIndex:0];
		textLayer.hidden = !self.showLabel;
		if( !self.showLabel ) return;
		NSString* label = [NSString stringWithFormat:@"%0.0f", _showPercentage ? layer.percentage * 100 : layer.value];
		CGSize size = [label sizeWithFont:self.labelFont];
		if( M_PI * 2 * self.labelRadius * layer.percentage < MAX(size.width, size.height) ){
			textLayer.string = @"";
		}else{
			textLayer.string = label;
			textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
		}
	}
}

#pragma mark - Private Functions

-(void)setSliceSelectedAtIndex:(NSInteger)index{
	if( self.selectedSliceOffsetRadius <= 0 ){
		return;
	}
	SliceLayer* layer = [self.pieView.layer.sublayers objectAtIndex:index];
	if( layer ){
		CGPoint currPos = layer.position;
		double middleAngle = (layer.startAngle + layer.endAngle) / 2.0;
		CGPoint newPos = CGPointMake(currPos.x + self.selectedSliceOffsetRadius * cos(middleAngle), currPos.y + self.selectedSliceOffsetRadius * sin(middleAngle));
		layer.position = newPos;
		layer.isSelected = TRUE;
	}
}

-(void)setSliceDeselectedAtIndex:(NSInteger)index{
	if( self.selectedSliceOffsetRadius <= 0 ){
		return;
	}
	SliceLayer* layer = [self.pieView.layer.sublayers objectAtIndex:index];
	if( layer ){
		layer.position = CGPointZero;
		layer.isSelected = FALSE;
	}
}

-(void)updateTimerFired:(NSTimer *)timer{
	CALayer* parentlayer = self.pieView.layer;
	NSArray* pieLayers = parentlayer.sublayers;
	
	[pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		SliceLayer* layer = (SliceLayer*)obj;
		NSNumber* presentationLayerStartAngle = [layer.presentationLayer valueForKey:@"startAngle"];
		CGFloat interpolatedStartAngle = presentationLayerStartAngle.doubleValue;
		NSNumber* presentationLayerEndAngle = [layer.presentationLayer valueForKey:@"endAngle"];
		CGFloat interpolatedEndAngle = presentationLayerEndAngle.doubleValue;
		
		CGPathRef path = CGPathCreateArc(self.pieCenter, self.pieRadius, interpolatedStartAngle, interpolatedEndAngle);
		layer.path = path;
		CFRelease(path);
		
		{
			CALayer* labelLayer = [layer.sublayers objectAtIndex:0];
			CGFloat interpolatedMidAngle = (interpolatedEndAngle + interpolatedStartAngle) / 2;
			[CATransaction setDisableActions:TRUE];
			labelLayer.position = CGPointMake(self.pieCenter.x + (self.labelRadius * cos(interpolatedMidAngle)), self.pieCenter.y + (self.labelRadius * sin(interpolatedMidAngle)));
			[CATransaction setDisableActions:FALSE];
		}
	}];
}

-(SliceLayer*)createSliceLayer{
	SliceLayer* pieLayer = SliceLayer.layer;
	pieLayer.zPosition = 0;
	pieLayer.strokeColor = NULL;
	CATextLayer* textLayer = CATextLayer.layer;
	CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)self.labelFont.fontName);
	textLayer.font = font;
	CFRelease(font);
	textLayer.fontSize = self.labelFont.pointSize;
	textLayer.anchorPoint = CGPointMake(0.5, 0.5);
	textLayer.alignmentMode = kCAAlignmentCenter;
	textLayer.backgroundColor = UIColor.clearColor.CGColor;
	CGSize size = [@"0" sizeWithFont:self.labelFont];
	
	[CATransaction setDisableActions:TRUE];
	textLayer.frame = CGRectMake(0, 0, size.width, size.height);
	textLayer.position = CGPointMake(self.pieCenter.x + (self.labelRadius * cos(0)), self.pieCenter.y + (self.labelRadius * sin(0)));
	[CATransaction setDisableActions:FALSE];
	
	[pieLayer addSublayer:textLayer];
	
	return pieLayer;
}

-(void)updateLabelForLayer:(SliceLayer *)pieLayer value:(CGFloat)value{
	CATextLayer* textLayer = [pieLayer.sublayers objectAtIndex:0];
	textLayer.hidden = !self.showLabel;
	if( !self.showLabel ) return;
	
	NSString* label;
	label = [NSString stringWithFormat:@"%0.0f", self.showPercentage ? pieLayer.percentage * 100 : value];
	CGSize size = [label sizeWithFont:self.labelFont];
	
	[CATransaction setDisableActions:TRUE];
	if( M_PI * 2 * self.labelRadius * pieLayer.percentage < MAX(size.width, size.height) || value <= 0 ){
		textLayer.string = @"";
	}else{
		textLayer.string = label;
		textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
	}
	[CATransaction setDisableActions:FALSE];
}

-(void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection{
	if( previousSelection != newSelection ){
		if( previousSelection != -1 && [self.delegate respondsToSelector:@selector(pieChartView:willDeselectSliceAtIndex:)] ){
			[self.delegate pieChartView:self willDeselectSliceAtIndex:previousSelection];
		}
		
		self.selectedSliceIndex = newSelection;
		
		if( newSelection != -1 ){
			if( [self.delegate respondsToSelector:@selector(pieChartView:willSelectSliceAtIndex:)] ){
				[self.delegate pieChartView:self willSelectSliceAtIndex:newSelection];
			}
			if( previousSelection != -1 && [self.delegate respondsToSelector:@selector(pieChartView:didDeselectSliceAtIndex:)] ){
				[self.delegate pieChartView:self didDeselectSliceAtIndex:previousSelection];
			}
			if( [self.delegate respondsToSelector:@selector(pieChartView:didSelectSliceAtIndex:)] ){
				[self.delegate pieChartView:self didSelectSliceAtIndex:newSelection];
			}
		}
		
		if( previousSelection != 1 ){
			[self setSliceSelectedAtIndex:previousSelection];
			if( [self.delegate respondsToSelector:@selector(pieChartView:didDeselectSliceAtIndex:)] ){
				[self.delegate pieChartView:self didDeselectSliceAtIndex:previousSelection];
			}
		}
	}else if( newSelection != -1 ){
		SliceLayer* layer = [self.pieView.layer.sublayers objectAtIndex:newSelection];
		if( self.selectedSliceOffsetRadius > 0 && layer ){
			if( layer.isSelected ){
				if( [self.delegate respondsToSelector:@selector(pieChartView:willDeselectSliceAtIndex:)] ){
					[self.delegate pieChartView:self willDeselectSliceAtIndex:newSelection];
				}
				[self setSliceSelectedAtIndex:newSelection];
				if( newSelection != -1 && [self.delegate respondsToSelector:@selector(pieChartView:didDeselectSliceAtIndex:)] ){
					[self.delegate pieChartView:self didDeselectSliceAtIndex:newSelection];
				}
			}else{
				if( [self.delegate respondsToSelector:@selector(pieChartView:willSelectSliceAtIndex:)] ){
					[self.delegate pieChartView:self willSelectSliceAtIndex:newSelection];
				}
				[self setSliceSelectedAtIndex:newSelection];
				if( newSelection != -1 && [self.delegate respondsToSelector:@selector(pieChartView:didSelectSliceAtIndex:)] ){
					[self.delegate pieChartView:self didSelectSliceAtIndex:newSelection];
				}
			}
		}
	}
}

-(NSInteger)getCurrentSelectedOnTouch:(CGPoint)point{
	__block NSUInteger selectedIndex = -1;
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	CALayer* parentLayer = self.pieView.layer;
	NSArray* pieLayers = parentLayer.sublayers;
	
	[pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		SliceLayer* pieLayer = (SliceLayer*)obj;
		CGPathRef path = pieLayer.path;
		
		if( CGPathContainsPoint(path, &transform, point, 0)){
			pieLayer.lineWidth = self.selectedSliceStroke;
			pieLayer.strokeColor = UIColor.whiteColor.CGColor;
			pieLayer.lineJoin = kCALineJoinBevel;
			pieLayer.zPosition = MAXFLOAT;
			selectedIndex = idx;
		}else{
			pieLayer.zPosition = kDefaultSliceZOrder;
			pieLayer.lineWidth = 0.0;
		}
	}];
	return selectedIndex;
}

#pragma mark - CAAnimation

-(void)animationDidStart:(CAAnimation *)anim{
	if( !self.animationTimer ){
		static float timeInterval = 1.0 / 60.0;
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:TRUE];
	}
	
	[self.animations addObject:anim];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	[self.animations removeObject:anim];
	
	if( self.animations.count == 0 ){
		[self.animationTimer invalidate];
		self.animationTimer = nil;
	}
}

#pragma mark - Touch Handing (Selection Notification)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = touches.anyObject;
	CGPoint point = [touch locationInView:self.pieView];
	[self getCurrentSelectedOnTouch:point];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = touches.anyObject;
	CGPoint point = [touch locationInView:self.pieView];
	NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
	[self notifyDelegateOfSelectionChangeFrom:self.selectedSliceIndex to:selectedIndex];
	[self touchesCancelled:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	CALayer* parentLayer = self.pieView.layer;
	NSArray* pieLayers = parentLayer.sublayers;
	
	for( SliceLayer* pieLayer in pieLayers ){
		pieLayer.zPosition = kDefaultSliceZOrder;
		pieLayer.lineWidth = 0.0;
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_dataSource release];
	[_delegate release];
	[_labelFont release];
	
	[_pieView release];
	[_animationTimer invalidate];
	[_animationTimer release];
	[_animations release];
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize startPieAngle = _startPieAngle;
@synthesize animationSpeed = _animationSpeed;
@synthesize pieCenter = _pieCenter;
@synthesize pieRadius = _pieRadius;
@synthesize showLabel = _showLabel;
@synthesize labelFont = _labelFont;
@synthesize labelRadius = _labelRadius;
@synthesize selectedSliceStroke = _selectedSliceStroke;
@synthesize selectedSliceOffsetRadius = _selectedSliceOffsetRadius;
@synthesize showPercentage = _showPercentage;

@synthesize selectedSliceIndex = _selectedSliceIndex;
@synthesize pieView = _pieView;
@synthesize animationTimer = _animationTimer;
@synthesize animations = _animations;

@end