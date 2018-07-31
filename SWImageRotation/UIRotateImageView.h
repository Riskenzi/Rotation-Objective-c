//
//  UIRotateImageView.h
//  RotateDemo
//
//  Created by SurpriseWave on 13/05/15.
//  Copyright (c) 2015 SurpriseWave. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

@interface UIRotateImageView : UIImageView

@property (nonatomic) CGFloat imageWidth;
@property (nonatomic) CGFloat imageHeight;

- (void)setFrameToFitImage;


- (void)rotateAtPosition:(CGFloat)radians;

- (UIImage *)finalImage;

@end
