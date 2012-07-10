//
//  ZPSplasherController.m
//  iWedding
//
//  Created by 钟 平 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZPSplasherController.h"
#import "HomeController.h"

@interface ZPSplasherController ()
@property (nonatomic, retain) UIImageView* backImage;
@end

@implementation ZPSplasherController
@synthesize backImage = _backImage;

- (void)dealloc {
    [_backImage release]; 
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [_backImage setImage:MF_PngOfDefaultSkin(@"Common/Splasher.png")];
    _backImage.userInteractionEnabled = true;
    [self.view addSubview:_backImage];
    
    UITapGestureRecognizer *aTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_backImage addGestureRecognizer:aTapGesture];
    [aTapGesture setNumberOfTouchesRequired:1];
    [aTapGesture setNumberOfTapsRequired:1];
    [aTapGesture release];
    
} 
 
- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    HomeController *homeController = [[HomeController alloc] init];
    [self.navigationController pushViewController:homeController animated:YES];
    [homeController release];
    
}
@end
