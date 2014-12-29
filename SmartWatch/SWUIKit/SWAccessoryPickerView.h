//
//  SWAccessoryPickerView.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/29.
//
//

#import <UIKit/UIKit.h>

@class SWAccessoryPickerView;
@class CBPeripheral;

@protocol SWAccessoryPickerViewDelegate <NSObject>

- (void)accessoryPickerView:(SWAccessoryPickerView *)pickerView didSelectPeripheral:(CBPeripheral *)peripheral;
- (void)accessoryPickerViewDidCancel:(SWAccessoryPickerView *)pickerView;

@end

@interface SWAccessoryPickerView : UIView

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) id<SWAccessoryPickerViewDelegate> delegate;
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

- (void)show;
- (void)hide;

@end
