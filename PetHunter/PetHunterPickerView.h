#import <UIKit/UIKit.h>

#import "PetHunterPickerTitle.h"

@class PetHunterPickerView;

@protocol PetHunterPickerViewDelegate<NSObject>

@optional
-(void)cancelButtonDidClick:(PetHunterPickerView*)pickerView;
-(void)confirmButtonDidClick:(PetHunterPickerView*)pickerView selectedTitle:(id<PetHunterPickerTitle>)selectedTitle;

//-(void)pickerViewDidShow:(PetHunterPickerView*)pickerView;
//-(void)pickerViewDidDismiss:(PetHunterPickerView*)pickerView;

@end

@interface PetHunterPickerView : UIView

@property (nonatomic, retain) id<PetHunterPickerViewDelegate> delegate;

@property (nonatomic, retain) UIView* targetView;

-(void)reloadData:(NSArray<PetHunterPickerTitle>*)titles;
//-(void)reloadData:(NSArray<PetHunterPickerTitle>*)titles maxComponents:(NSInteger)maxComponents;

-(void)show;
-(void)dismiss;

@end