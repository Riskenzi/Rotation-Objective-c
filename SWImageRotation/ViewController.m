//
//  ViewController.m
//  RotateDemo
//
//  Created by SurpriseWave on 02/05/15.
//  Copyright (c) 2015 SurpriseWave. All rights reserved.
//

#import "ViewController.h"
#import "UIRotateImageView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIRotateImageView *imgvPhoto;

@end

@implementation ViewController

@synthesize imgvPhoto;

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareViews];
}

#pragma mark - Views Methods
- (void)prepareViews
{
    NSUInteger index = arc4random_uniform(3) + 1;
    
    NSString *imageName = [NSString stringWithFormat:@"image%@.jpg", @(index)];
    
    imgvPhoto.image = [UIImage imageNamed:imageName];

    [self adjustPossition];
}


- (void)adjustPossition
{
    CGAffineTransform saveState = imgvPhoto.transform;
    
    imgvPhoto.transform = CGAffineTransformIdentity;
    
    [imgvPhoto setFrameToFitImage];

    
    imgvPhoto.transform = saveState;
}

#pragma mark - Event Methods
- (IBAction)btnRotateRightTap:(UIButton *)sender
{
    [imgvPhoto rotateAtPosition:kRotateRight];
    
    [self adjustPossition];
}

- (IBAction)btnOkTap:(UIButton *)sender
{
    UIImage *imgFinal = [imgvPhoto finalImage];
    
    UIImageWriteToSavedPhotosAlbum(imgFinal, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - Other Methods
- (void)               image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rotation"
                                                    message:@"Image Saved Successfully."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
