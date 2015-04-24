//
//  DetailVideoViewController.h
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import "VideoViewController.h"
#import "RSSObject.h"
@interface DetailVideoViewController : VideoViewController
@property (retain,nonatomic) RSSObject* video;
@end
