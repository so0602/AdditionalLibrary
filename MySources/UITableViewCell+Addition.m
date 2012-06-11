#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)

+(id)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
	return [cell autorelease];
}

+(id)cell{
	return [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] lastObject];
}

+(NSString*)reuseIdentifier{
	return [[self cell] reuseIdentifier];
}

+(CGFloat)cellHeight{
	return [[self cell] height];
}

-(void)didSelect{
	UITableView* tableView = (UITableView*)self.superview;
	if( ![tableView isKindOfClass:[UITableView class]] ) return;
	
	if( RespondsToSelector(tableView.delegate, @selector(tableView:didSelectRowAtIndexPath:)) ){
		[tableView.delegate tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForCell:self]];
	}
}

-(UIImage*)backgroundImage{
	if( ![self.backgroundView isKindOfClass:[UIImageView class]] ) return nil;
	
	return ((UIImageView*)self.backgroundView).image;
}

-(void)setBackgroundImage:(UIImage*)image{
	if( ![self.backgroundView isKindOfClass:[UIImageView class]] ) return;
	
	((UIImageView*)self.backgroundView).image = image;
}

@end