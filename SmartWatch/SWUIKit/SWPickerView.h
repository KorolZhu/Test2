//
//  SWPickerView.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "AMBlurView.h"

@class SWPickerView;

@protocol SWPickerViewDelegate <NSObject>

@optional
- (void)pickerViewDidCancel:(SWPickerView *)pickerView;
- (void)pickerView:(SWPickerView *)pickerView didFinished:(NSString *)value;

@end

@interface SWPickerView : AMBlurView

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSString *titleSuffix;
@property (nonatomic,weak) id<SWPickerViewDelegate> delegate;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)showFromView:(UIView *)view;
- (void)hideFromView:(UIView *)view;

@end
