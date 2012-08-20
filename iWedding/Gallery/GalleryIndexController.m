//
//  GalleryIndexController.m
//  iWedding
//
//  Created by 钟 平 on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GalleryIndexController.h"
#import "GalleryScrollView.h"

#define cellWidth 240/2.0f
#define cellHeight 180/2.0f
#define cellSplitWidth 25.f
#define cellSplitHeight 25.f 
#define rows 6
#define cols 6

@interface GalleryIndexController ()<TileDelegate, TileWallDelegate,UIScrollViewDelegate,DDPageControlDelegate>{
    BOOL pageControlUsed;
    int numberPerScreen;
    int actualPage;
}
@property (nonatomic, retain) TileWall* tileWall;
@property (nonatomic, retain) NSArray* photoList;
@property (nonatomic, retain) UIImage* defaultBackgroundImage;
@property (nonatomic, retain) GalleryScrollView *bigPictureOfScroll;
@property (nonatomic, retain) DDPageControl  *pageControl;
@end

@implementation GalleryIndexController
@synthesize tileWall = _tileWall;
@synthesize photoList = _photoList;
@synthesize defaultBackgroundImage;
@synthesize bigPictureOfScroll;
@synthesize pageControl;

- (void)dealloc {
    [_tileWall release];
    [_photoList release]; 
    self.defaultBackgroundImage = nil;
    self.bigPictureOfScroll = nil;
    self.pageControl = nil;
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
    numberPerScreen = 5;
    
    UIButton *indexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexBtn setFrame:CGRectMake(self.view.size.height - 60 / 2.0 - 62 / 2.0, 
                                    1090 / 2.0 + 60 / 2.0 + 50 / 2.0, 60 / 2.0, 60 / 2.0)];
    [indexBtn setImage:MF_PngOfDefaultSkin(@"Common/Common_IndexMode.png") forState:UIControlStateNormal];
    [indexBtn addTarget:self action:@selector(doIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:indexBtn];
    
    UIButton *goingUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goingUpBtn setFrame:CGRectMake(self.view.size.height - 60 / 2.0 - 62 / 2.0, 
                                    1090 / 2.0 + 60 / 2.0 + 50 / 2.0 + 60 / 2.0 + 50 / 2.0, 60 / 2.0, 60 / 2.0)];
    
    [goingUpBtn setImage:MF_PngOfDefaultSkin(@"Common/Common_GoingUpBtn.png") forState:UIControlStateNormal];
    [goingUpBtn addTarget:self action:@selector(doGoingUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goingUpBtn];
     
    bigPictureOfScroll = [[GalleryScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.f, 768.f)];
    bigPictureOfScroll.backgroundColor = [UIColor clearColor];
    bigPictureOfScroll.userInteractionEnabled = YES;
    bigPictureOfScroll.showsVerticalScrollIndicator = NO;
    bigPictureOfScroll.showsHorizontalScrollIndicator = NO;
    bigPictureOfScroll.pagingEnabled = YES;
    bigPictureOfScroll.delegate = self; 
    bigPictureOfScroll.scrollsToTop = NO;
    bigPictureOfScroll.delaysContentTouches = NO;
    bigPictureOfScroll.bounces = NO;
    bigPictureOfScroll.canCancelContentTouches = YES;
    bigPictureOfScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:bigPictureOfScroll];
     
    //滚动大图指示栏
    pageControl = [[DDPageControl alloc] init];
    [pageControl addTarget:self action:@selector(pageTo:) forControlEvents:UIControlEventValueChanged];
    [pageControl setOnColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.9f alpha: 1.0f]] ;
    pageControl.delegate = self;
    pageControl.enabled = NO;
    
    [self.containerView addSubview:pageControl]; 
     
    [self setupCatalog];
    [self createTileWall];
    
    
    [_tileWall frontMe];
    [self ChangeUIByData];
    
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
    
    _tileWall = [[TileWall alloc] initWithOrigin:CGPointMake(104 / 2.0 + 5, 90 / 2.0 - 12/ 2.0)];
    _tileWall.blockSplitWidth = 10;
    _tileWall.tileWallDelegate = self;
    //_tileWall.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:_tileWall];
    _tileWall.tileBlocks = [self createTileBlocks];  
    [_tileWall refresh];
    
    
}

- (NSMutableArray*)createTileBlocks { 
    int blockCount = ([_photoList count] - 1)/ (rows * cols);
    NSMutableArray *tileBlocks = [NSMutableArray array];
    for (int i = 0; i <= blockCount; i++) {
        TileBlock *tileBlock = [[TileBlock alloc] initWithWall:self.tileWall withGird:CCGGridMake(rows, cols) andCellSize:(CGSize) CGSizeMake(cellWidth, cellHeight) andCellSplitSize:CGSizeMake(cellSplitWidth, cellSplitHeight)]; 
        tileBlock.tiles = [self createTilesInBlockIndex:i];
        [tileBlocks addObject:tileBlock];
        [tileBlock release];
    } 
    return tileBlocks;
}


- (NSMutableArray*)createTilesInBlockIndex:(int)blockIndex {
    NSUInteger len = (blockIndex + 1) * (rows * cols) < [_photoList count] ? (rows * cols) : ([_photoList count] - blockIndex * (rows * cols));
    
    NSRange r = NSMakeRange(blockIndex * 35, len);
    NSArray *catalogInBlock = [_photoList subarrayWithRange:r];
    
    __block int i = 0; 
    return  [NSMutableArray arrayWithArray:[catalogInBlock map:^id(id obj) {
        int locationFromX = (i / cols)+1;
        int locationFromY = (i % cols)+1; 
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


- (void)ChangeUIByData {

    
    if([self.photoList count] % numberPerScreen == 0){
        pageControl.numberOfPages = [self.photoList count]/numberPerScreen;
    }
    else{
        pageControl.numberOfPages = [self.photoList count]/numberPerScreen + 1;
    }  
    pageControl.frame = CGRectMake(([super containerView].width - pageControl.numberOfPages * 18)/2.0 - 50.f, 1492.0f/2.0f - 42 / 2.0, pageControl.numberOfPages* numberPerScreen * 18 , 24);
    
    bigPictureOfScroll.contentSize = CGSizeMake(bigPictureOfScroll.width * [self.photoList count], bigPictureOfScroll.height);
    
    
    [bigPictureOfScroll.subviews each:^(id sender){ 
        [sender removeFromSuperview];
    }];
    
    
    int total = [self.photoList count];
    __block int i = 0;
    [self.photoList each:^void(id obj){
        //FramesInfo* fi = (FramesInfo*)obj;
        //DebugLog(@"Data include  %@ %@",fi.JournalItemName ,fi.JournalItemDescription);
        
        UIImageView *bigPictureOfFrame = makeImageView(i*bigPictureOfScroll.width, 0.0f, bigPictureOfScroll.width, bigPictureOfScroll.height);
        bigPictureOfFrame.tag = 1000+i;
        bigPictureOfFrame.userInteractionEnabled = YES;
        DebugLog(@"bigPictureOfFrame %d:%@",i,NSStringFromCGRect(bigPictureOfFrame.frame));
        bigPictureOfFrame.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if(total <=1){
            NSDictionary *frameInfo = [self.photoList objectAtIndex:i];
            
            //针对只有一张图片的情形
            bigPictureOfFrame.image = MF_PngOfDefaultSkin( [frameInfo objectForKey:@"image"]);
            
            UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)] autorelease]; 
            swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;         
            [bigPictureOfFrame addGestureRecognizer:swipeRightGestureRecognizer];
            
            UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)] autorelease]; 
            swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;         
            [bigPictureOfFrame addGestureRecognizer:swipeLeftGestureRecognizer];
            
        }
        [bigPictureOfScroll addSubview:bigPictureOfFrame];   
        
        i++;
    }]; 
    bigPictureOfScroll.contentOffset = CGPointMake(pageControl.currentPage * bigPictureOfScroll.width, 0.0f);
    pageControl.hidden = YES;
    //[self jumpToCurrentFrame];
}

- (void)loadBigPicturesToImageViews:(NSNumber *)indexObj {
     
    if(pageControlUsed){
        return;
    }
    
    pageControlUsed = YES;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //检测index是否合法
    int total = [self.photoList count];
    if(total > 0){ //0->1
        int index = [indexObj intValue];
        
        if(index >= total){
            index = total - 1; 
        }
        
        int lowerDecrease = 1;
        int upperIncrease = 1;
        
        if(IS_IPAD_1){
            lowerDecrease = 0;
            upperIncrease = 0;
            DebugLog(@"iPad 1,Load just one image");
        }
        //DebugLog(@"lowerDecrease:%d,upperIncrease:%d",lowerDecrease,upperIncrease);
        
        int lowerOffset = index - lowerDecrease;
        int upperOffset = index + upperIncrease;
        
        DebugLog(@"lowerOffset:%d,upperOffset:%d",lowerOffset,upperOffset);
        
        NSMutableArray *indexArrayToLoad = [NSMutableArray arrayWithCapacity:1+lowerDecrease+upperIncrease];
        for(int lower = index-1; lower>=lowerOffset ;lower--){
            if(lower<0){
                //[indexArrayToLoad addObject:NI(-1)];
                break;
            }
            else{
                [indexArrayToLoad insertObject:NI(lower) atIndex:0];
            }
        } 
        [indexArrayToLoad addObject:NI(index)];
        for(int upper = index+1; upper<=upperOffset ;upper++){
            if(upper > (total - 1)){
                //[indexArrayToLoad addObject:NI(9999)];
                break;
            }
            else{
                [indexArrayToLoad addObject:NI (upper)];
            }
        }
        
        //DebugLog(@"Prepare to clear unused image.....");
        int __block i=0;
        
        [self.photoList each:^(id sender) {
            if (i<lowerOffset || i>upperOffset) {
                //DebugLog(@"  Clear Image %d",i);
                UIImageView *toRelease=(UIImageView *)[bigPictureOfScroll viewWithTag:1000+i];
                
                if ([toRelease.subviews count]>0) {
                    //DebugLog(@"    Subviews Count=%d",toRelease.subviews.count);
                    
                    for(UIView *subview in [toRelease subviews]) {
                        [subview removeFromSuperview];
                    }
                    //DebugLog(@"    释放文字层图片资源。");
                    //TextLayerView *temp = [toRelease.subviews objectAtIndex:0];
                    //temp=nil;
                }                        
                toRelease.image = nil;
            }
            else {
                DebugLog(@"  Skip clear image %d",i);
            }
            i++;
        }];
        //DebugLog(@"Unused image cleared.");
        
        //DebugLog(@"%@",indexArrayToLoad);
        
        //NSDictionary *currentFrameInfo = [self.photoList objectAtIndex:index];
        //DebugLog(@"FrameInfo %@",currentFrameInfo);
        
        [indexArrayToLoad each:^(id sender) {
            int current = [(NSNumber*)sender intValue]; 
            NSDictionary *frameInfo = [self.photoList objectAtIndex:current];
            UIImageView * bigPicture = (UIImageView *)[bigPictureOfScroll viewWithTag:1000+current];
            if(bigPicture.image == nil){
                DebugLog(@"Display No.%d , Load %d Image %@",index,current,[frameInfo objectForKey:@"image"]);
                bigPicture.image = MF_PngOfDefaultSkin([frameInfo objectForKey:@"image"]); 
            } 
             
        }];
    }
    [pool release];
    pageControlUsed = NO; 
}

#pragma mark -Tile Delegate
- (void)tileTapped:(Tile *)tile {  
    _tileWall.hidden = YES;
    int index = ((TileBlock *)[tile superview]).indexInTileWall * (rows * cols) + tile.indexInTileBlock;
    pageControl.hidden = NO;
    bigPictureOfScroll.hidden = NO;
    pageControl.currentPage = index / numberPerScreen; 
    DebugLog(@"tileTapped:%d",index);
    bigPictureOfScroll.contentOffset = CGPointMake(index * bigPictureOfScroll.width, 0.0f);
    [NSThread detachNewThreadSelector:@selector(loadBigPicturesToImageViews:) toTarget:self withObject:NI(index)];
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
                int indexImage = (toTileBlock.indexInTileWall*(rows * cols) +tile.indexInTileBlock);
                NSDictionary *catalogInfo = [_photoList objectAtIndex:indexImage];
                tile.backgroundImage = MF_PngOfDefaultSkin([catalogInfo objectForKey:@"image"]);
            }); 
            i++;
        }];
    });
    
}



#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; 
{
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    } 
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1; 
    if(actualPage == page){
        return;
    }
    else{
        [NSThread detachNewThreadSelector:@selector(loadBigPicturesToImageViews:) toTarget:self withObject:NI(page)];
        actualPage = page;
    }
    pageControl.currentPage = page/numberPerScreen;  
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{  
    pageControlUsed = NO;  
}


#pragma mark -DDPageControlDelegate
- (void)dDPageControl:(DDPageControl*)theDDPageControl currentPageChangedFrom:(NSUInteger)oldPage to:(NSUInteger)newPage{
    DebugLog(@"pageControl newpage =%d",newPage);
    //[NSThread detachNewThreadSelector:@selector(loadBigPicturesToImageViews:) toTarget:self withObject:NI(newPage*numberPerScreen)];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{ 
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if([gestureRecognizer.view class]== [UIImageView class]){
            if(pageControl.currentPage <= 0){ 
                dispatch_async(dispatch_get_main_queue(),^{ 
                    [self showWaitViewWithTitle:NSLocalizedString(@"已经到达第一页", nil) andCloseDelay:1.f];
                });
            }
        }
    }
    else if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if([gestureRecognizer.view class]== [UIImageView class]){ 
            if(pageControl.currentPage >= [self.photoList count]-1){
                dispatch_async(dispatch_get_main_queue(),^{ 
                    [self showWaitViewWithTitle:NSLocalizedString(@"已经到达最后一页", nil) andCloseDelay:1.f];
                });
            }
        }
    }
}

- (void)doIndex:(id)sender {
    
    bigPictureOfScroll.hidden = YES;
    pageControl.hidden = YES;
    _tileWall.hidden = NO;
}
@end
