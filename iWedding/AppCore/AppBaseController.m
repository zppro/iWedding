//
//  AppBaseController.m
//  iWedding
//
//  Created by 钟 平 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppBaseController.h"

@interface AppBaseController ()
@property (nonatomic, retain) UIImageView* leftImage;
@end

@implementation AppBaseController
@synthesize containerView = _containerView;
@synthesize leftImage = _leftImage;

- (void)dealloc {
    [_containerView release];
    [_leftImage release]; 
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view. 
    self.view.backgroundColor = [UIColor whiteColor];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58 / 2.0, 1536 / 2.0)];
    [_leftImage setImage:MF_PngOfDefaultSkin(@"Common/Common_LeftLine.png")];
    [self.view addSubview:_leftImage];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(58 / 2.0, 0, 1024 - 58 / 2.0, 768)];
    [_containerView setUserInteractionEnabled:YES];
    [_containerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_containerView];
    
    self.waitView = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.waitView setFrame:CGRectMake(0, 0, 1024, 768)];
    self.waitView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // setting navigation bar hidden
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
