//
//  SWCircleProgressView.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/23.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SWCircleProgressViewStyle) {
    SWCircleProgressViewStyleLarge,
    SWCircleProgressViewStyleSmall,
};

@interface SWCircleProgressView : UIView

@property (nonatomic)float progress;
@property (nonatomic,strong)NSString *topDesc;
@property (nonatomic,strong)NSString *bottomDesc;
@property (nonatomic,strong)NSString *valueString;
@property (nonatomic,strong)UIImage *backImage;
@property (nonatomic)SWCircleProgressViewStyle style;

@end
