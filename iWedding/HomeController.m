//
//  HomeController.m
//  iWedding
//
//  Created by 钟 平 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define cellWidth 412.0f/2.0f
#define cellHeight 412.0f/2.0f
#define cellSplitWidth -5
#define cellSplitHeight -5

#import "HomeController.h"
#import "GalleryIndexController.h"

@interface HomeController ()<TileDelegate, TileWallDelegate>
@property (nonatomic, retain) TileWall* tileWall;
@property (nonatomic, retain) NSArray* catalogList;
@property (nonatomic, retain) UIImage* defaultBackgroundImage;
@end

@implementation HomeController
@synthesize tileWall = _tileWall;
@synthesize catalogList = _catalogList;
@synthesize defaultBackgroundImage;

- (void)dealloc {
    [_tileWall release];
    [_catalogList release]; 
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

#pragma mark data
- (void) setupCatalog {
    self.catalogList = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"公主新娘",@"title",@"Tiles/princess.png", @"image",nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:@"骑士新郎",@"title",@"Tiles/knight.png", @"image",nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"相册",@"title",@"Tiles/gallery.png", @"image",nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:@"亲",@"title",@"Tiles/gallery1.png", @"image",nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:@"友",@"title",@"Tiles/gallery2.png", @"image",nil], 
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
    int blockCount = ([_catalogList count] - 1)/ 12;
    NSMutableArray *tileBlocks = [NSMutableArray array];
    for (int i = 0; i <= blockCount; i++) {
        TileBlock *tileBlock = [[TileBlock alloc] initWithWall:self.tileWall withGird:CCGGridMake(3, 4) andCellSize:(CGSize) CGSizeMake(cellWidth, cellHeight) andCellSplitSize:CGSizeMake(cellSplitWidth, cellSplitHeight)]; 
        tileBlock.tiles = [self createTilesInBlockIndex:i];
        [tileBlocks addObject:tileBlock];
        [tileBlock release];
    } 
    return tileBlocks;
}


- (NSMutableArray*)createTilesInBlockIndex:(int)blockIndex {
    NSUInteger len = (blockIndex + 1) * 12 < [_catalogList count] ? 12 : ([_catalogList count] - blockIndex * 12);
    
    NSRange r = NSMakeRange(blockIndex * 12, len);
    NSArray *catalogInBlock = [_catalogList subarrayWithRange:r];
    
    __block int i = 0; 
    return  [NSMutableArray arrayWithArray:[catalogInBlock map:^id(id obj) {
        int locationFromX = (i / 4)+1;
        int locationFromY = (i % 4)+1; 
        NSDictionary *catalogInfo = (NSDictionary *)obj;
        Tile *tile = [[[Tile alloc] initWithLocation:CCGGridLocationMake(locationFromX, locationFromY) andDefaultBackgroundImage:self.defaultBackgroundImage] autorelease]; 
        tile.showMode = TileShowModeIconBigTextSmall;
        tile.delegate = self;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.07f * NSEC_PER_SEC);
      
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            tile.backgroundImage = MF_PngOfDefaultSkin([catalogInfo objectForKey:@"image"]); 
        });
         
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 201 - 46 / 2.0, 196, 46 / 2.0)];
        [imageView setImage:MF_PngOfDefaultSkin(@"Tiles/title_bg.png")];
        [tile addSubview:imageView];
        [imageView release];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 196, 23)];
        [title setTextAlignment:UITextAlignmentCenter];
        [title setTextColor:[UIColor whiteColor]];
        
        [title setText:[catalogInfo objectForKey:@"title"]]; 
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setBackgroundColor:[UIColor clearColor]];
        [imageView addSubview:title];
        [title release];
        
        i++;
        return tile;
    }]];
}



#pragma mark -Tile Delegate
- (void)tileTapped:(Tile *)tile { 
    NSDictionary *catalogInfo = [_catalogList objectAtIndex:((TileBlock *)[tile superview]).indexInTileWall * 12 + tile.indexInTileBlock];
    NSString *titleOfCatalog = [catalogInfo objectForKey:@"title"];
    if([titleOfCatalog  isEqualToString:@"公主新娘"]){
        
    }
    else if([titleOfCatalog  isEqualToString:@"骑士新郎"]){
        
    }
    else if([titleOfCatalog  isEqualToString:@"相册"]){
        GalleryIndexController *galleryIndexController = [[[GalleryIndexController alloc] init] autorelease];
        [self.navigationController pushViewController:galleryIndexController animated:YES];
    } 
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
                int indexImage = (toTileBlock.indexInTileWall*12+tile.indexInTileBlock);
                NSDictionary *catalogInfo = [_catalogList objectAtIndex:indexImage];
                tile.backgroundImage = MF_APng([catalogInfo objectForKey:@"image"]); 
            }); 
            i++;
        }];
    });
    
}


@end
