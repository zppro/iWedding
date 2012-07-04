//
//  ZPSplasherController.m
//  iWedding
//
//  Created by 钟 平 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZPSplasherController.h"

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
    [self.view addSubview:_backImage];
    [_backImage behindMe];
} 
 

@end
