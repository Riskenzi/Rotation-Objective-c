//
//  UIRotateImageView.m
//  RotateDemo
//
//  Created by SurpriseWave on 13/05/15.
//  Copyright (c) 2015 SurpriseWave. All rights reserved.
//

#import "UIRotateImageView.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface UIRotateImageView()

@property (nonatomic) CGFloat diagonal;
@property (nonatomic) CGFloat rotationAngle;

@end

@implementation UIRotateImageView

@synthesize diagonal, imageHeight, imageWidth, rotationAngle;

#pragma mark - UIImageView Methods
- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
  [self setFrameToFitImage];
}

#pragma mark - Helper Methods
- (void)calculateDiagonal
{
    CGRect rect = self.frame;
    
    CGFloat seuareWidth  = CGRectGetWidth(rect) * CGRectGetWidth(rect);
    CGFloat seuareheight = CGRectGetHeight(rect) * CGRectGetHeight(rect);
    
    diagonal = sqrtf( seuareWidth + seuareheight );
}

- (void)setFrameToFitImage
{
    self.frame = self.superview.bounds;
    
    float widthRatio  = self.bounds.size.width / self.image.size.width;
    float heightRatio = self.bounds.size.height / self.image.size.height;
    float scale       = MIN(widthRatio, heightRatio);
    
    imageWidth  = scale * self.image.size.width;
    imageHeight = scale * self.image.size.height;
    
    self.frame  = CGRectMake(0, 0, imageWidth, imageHeight);
    self.center = CGPointMake(CGRectGetWidth(self.superview.frame) / 2.0 , CGRectGetHeight(self.superview.frame) / 2.0);
    
    [self calculateDiagonal];
}

- (CGFloat)calculateScaleForAngle:(CGFloat)angle
{
    CGFloat minSideLength = MIN(imageWidth, imageHeight);
    
    angle = ABS(angle);
    
    CGFloat width = ((diagonal - minSideLength) / 45) * angle + minSideLength;
    
    CGFloat adjustment = 0;
    
    if(angle <= 22.5)
    {
        adjustment = (angle / 150);
    }
    else
    {
        adjustment = ((45 - angle) / 150);
    }
    
    CGFloat scale = (width / minSideLength) + adjustment;
    
    return scale;
}

#pragma mark - Rotation Methods
- (void)rotateAtPosition:(CGFloat)radians
{
    CIImage *imgToRotate = [CIImage imageWithCGImage:self.image.CGImage];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    
    CIImage *rotatedImage = [imgToRotate imageByApplyingTransform:transform];
    
    CGRect extent = [rotatedImage extent];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    UIImage *finalImage = [UIImage imageWithCGImage:[context createCGImage:rotatedImage fromRect:extent]];
    
    self.image = finalImage;
}

- (UIImage *)finalImage
{
    CGSize size = CGSizeMake(self.image.size.width, self.image.size.height);
    
    CGFloat scale = [self calculateScaleForAngle:rotationAngle];
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height );
    CGContextRotateCTM(context, degreesToRadians(rotationAngle));
    CGContextScaleCTM(context, scale, scale);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);
    
    [self.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
