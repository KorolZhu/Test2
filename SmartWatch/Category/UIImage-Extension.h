//
//  UIImage-Extension.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByColorizing:(UIColor *)theColor;
- (UIImage *)convertImageToGrayScale:(UIColor *)theColor;

/*
 用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。
 如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作会出问题，
 所以，在对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为UIImageOrientaionUp。
 */
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end


