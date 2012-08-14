//
//  GalleryIndexController.h
//  iWedding
//
//  Created by 钟 平 on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppBaseController.h"

typedef enum {
    GalleryShowMode_Index,
    GalleryShowMode_FullScreen
}GalleryShowMode;

@interface GalleryIndexController : AppBaseController{
    GalleryShowMode _GalleryShowMode;
}

@end
