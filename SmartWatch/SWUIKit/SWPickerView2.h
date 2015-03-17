//
//  SWPickerView2.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "AMBlurView.h"

@class SWPickerView2;

@protocol SWPickerView2Delegate <NSObject>

@optional
- (void)pickerView2DidCancel:(SWPickerView2 *)pickerView;
- (void)pickerView2:(SWPickerView2 *)pickerView didFinishedWithValue1:(NSString *)value value2:(NSString *)value2;

@end

@interface SWPickerView2 : AMBlurView

@property (nonatomic,strong) NSArray *dataSource1;
@property (nonatomic,strong) NSString *titleSuffix1;

@property (nonatomic,strong) NSArray *dataSource2;
@property (nonatomic,strong) NSString *titleSuffix2;

@property (nonatomic,weak) id<SWPickerView2Delegate> delegate;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)showFromView:(UIView *)view;
- (void)hideFromView:(UIView *)view;

@end
