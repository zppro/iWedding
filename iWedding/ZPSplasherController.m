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
@property (nonatomic, retain) UIImageView* brideRole;
@end

@implementation ZPSplasherController
@synthesize backImage = _backImage;
@synthesize brideRole = _brideRole;
- (void)dealloc {
    [_backImage release]; 
    [_brideRole release];
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
    [_backImage release];
    
    UITapGestureRecognizer *aTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_backImage addGestureRecognizer:aTapGesture];
    [aTapGesture setNumberOfTouchesRequired:1];
    [aTapGesture setNumberOfTapsRequired:1];
    [aTapGesture release];
    
    _brideRole = [[UIImageView alloc] initWithFrame:CGRectMake(1024-350/4.f - 120.f, 768-450/4.f - 50.f, 350/4.f, 450/4.f)];
    
    NSArray* arrayWithImages = [[NSMutableArray alloc] initWithObjects:
                       MF_PngOfDefaultSkin(@"Common/bride01.png"),
                       MF_PngOfDefaultSkin(@"Common/bride02.png"),
//                       MF_PngOfDefaultSkin(@"Common/bride03.png"),
//                       MF_PngOfDefaultSkin(@"Common/bride04.png"),
//                       MF_PngOfDefaultSkin(@"Common/bride05.png"),
//                       MF_PngOfDefaultSkin(@"Common/bride06.png"),
                       nil];
    _brideRole.animationImages = arrayWithImages;
    _brideRole.animationDuration = 1.f;
    _brideRole.animationRepeatCount = 0;
    [self.view addSubview:_brideRole];
    [_brideRole release];
    
    
    
} 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_brideRole startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_brideRole stopAnimating];
}
 
- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    HomeController *homeController = [[HomeController alloc] init];
    [self.navigationController pushViewController:homeController animated:YES];
    [homeController release];
    
}
@end
