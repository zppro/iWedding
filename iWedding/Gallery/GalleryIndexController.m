//
//  GalleryIndexController.m
//  iWedding
//
//  Created by 钟 平 on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GalleryIndexController.h"

#define cellWidth 240/2.0f
#define cellHeight 180/2.0f
#define cellSplitWidth 25.f
#define cellSplitHeight 25.f

@interface GalleryIndexController ()<TileDelegate, TileWallDelegate>
@property (nonatomic, retain) TileWall* tileWall;
@property (nonatomic, retain) NSArray* photoList;
@property (nonatomic, retain) UIImage* defaultBackgroundImage;
@end

@implementation GalleryIndexController
@synthesize tileWall = _tileWall;
@synthesize photoList = _photoList;
@synthesize defaultBackgroundImage;

- (void)dealloc {
    [_tileWall release];
    [_photoList release]; 
    self.defaultBackgroundImage = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.defaultBackgroundImage = MF_PngOfDefaultSkin(@"Tiles/bg.png"); //Default Cell BackgroundImage
    
    UIButton *goingUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goingUpBtn setFrame:CGRectMake(12 / 2.0 + 85 / 2.0, 1464 / 2.0, 60 / 2.0, 60 / 2.0)];
    [goingUpBtn setImage:MF_PngOfDefaultSkin(@"Common/Common_GoingUpBtn.png") forState:UIControlStateNormal];
    [goingUpBtn addTarget:self action:@selector(doGoingUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goingUpBtn];
    
    [self setupCatalog];
    [self createTileWall];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark data
- (void) setupCatalog {
    self.photoList = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0009.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0010.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0011.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0013.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0021.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0022.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0025.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0026.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0028.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0029.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0031.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0032.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0035.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0038.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0040.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0041.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0042.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0043.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0044.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0046.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0052.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0053.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0059.jpg", @"image",nil], 
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0060.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0062.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0064.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0065.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0069.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0062.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0073.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0074.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0076.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0078.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0079.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0090.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0093.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0098.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0099.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0107.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0109.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0127.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0128.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0131.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0132.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0134.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0137.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0139.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0142.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0143.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0147.jpg", @"image",nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Gallery/DPP_0148.jpg", @"image",nil],
                        nil];
    
}

#pragma mark action

- (void)doGoingUp:(id)sender {   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tile

- (void)createTileWall {
    if (_tileWall != nil) {
        [_tileWall removeFromSuperview]; 
    }
    
    _tileWall = [[TileWall alloc] initWithOrigin:CGPointMake(104 / 2.0 + 5, 142 / 2.0 - 12/ 2.0)];
    _tileWall.blockSplitWidth = 10;
    _tileWall.tileWallDelegate = self;
    [self.containerView addSubview:_tileWall];
    _tileWall.tileBlocks = [self createTileBlocks];  
    [_tileWall refresh];
    
    
}

- (NSMutableArray*)createTileBlocks { 
    int blockCount = ([_photoList count] - 1)/ 30;
    NSMutableArray *tileBlocks = [NSMutableArray array];
    for (int i = 0; i <= blockCount; i++) {
        TileBlock *tileBlock = [[TileBlock alloc] initWithWall:self.tileWall withGird:CCGGridMake(5, 6) andCellSize:(CGSize) CGSizeMake(cellWidth, cellHeight) andCellSplitSize:CGSizeMake(cellSplitWidth, cellSplitHeight)]; 
        tileBlock.tiles = [self createTilesInBlockIndex:i];
        [tileBlocks addObject:tileBlock];
        [tileBlock release];
    } 
    return tileBlocks;
}


- (NSMutableArray*)createTilesInBlockIndex:(int)blockIndex {
    NSUInteger len = (blockIndex + 1) * 30 < [_photoList count] ? 30 : ([_photoList count] - blockIndex * 30);
    
    NSRange r = NSMakeRange(blockIndex * 30, len);
    NSArray *catalogInBlock = [_photoList subarrayWithRange:r];
    
    __block int i = 0; 
    return  [NSMutableArray arrayWithArray:[catalogInBlock map:^id(id obj) {
        int locationFromX = (i / 6)+1;
        int locationFromY = (i % 6)+1; 
        NSDictionary *catalogInfo = (NSDictionary *)obj;
        Tile *tile = [[[Tile alloc] initWithLocation:CCGGridLocationMake(locationFromX, locationFromY) andDefaultBackgroundImage:self.defaultBackgroundImage] autorelease]; 
        tile.showMode = TileShowModeIconBigTextSmall;
        tile.delegate = self;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.07f * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            tile.backgroundImage = MF_PngOfDefaultSkin([catalogInfo objectForKey:@"image"]); 
        });
          
        i++;
        return tile;
    }]];
}



#pragma mark -Tile Delegate
- (void)tileTapped:(Tile *)tile { 
    //NSDictionary *catalogInfo = [_catalogList objectAtIndex:((TileBlock *)[tile superview]).indexInTileWall * 12 + tile.indexInTileBlock];
}

#pragma mark -TileWall Delegate
- (void)tileWall:(TileWall *)tileWall scrollFrom:(TileBlock *)fromTileBlock to:(TileBlock *) toTileBlock {
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [fromTileBlock.tiles each:^(id sender) {
            Tile *tile = (Tile*)sender;
            [tile restore];
        }]; 
        
        __block int i = 0;
        [toTileBlock.tiles each:^(id sender) {
            __block Tile *tile = (Tile*)sender; 
            double delayInSeconds = i * 0.07f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                int indexImage = (toTileBlock.indexInTileWall*30+tile.indexInTileBlock);
                NSDictionary *catalogInfo = [_photoList objectAtIndex:indexImage];
                tile.backgroundImage = MF_PngOfDefaultSkin([catalogInfo objectForKey:@"image"]);
            }); 
            i++;
        }];
    });
    
}

@end
