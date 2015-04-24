//
//  MYMoviePlayerViewController.h
//  Смотри&Бери
//
//  Created by svatorus on 27.06.14.
//  Copyright (c) 2014 svatorus. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RSSObject.h"
@interface MYMoviePlayerViewController : MPMoviePlayerViewController{
   
}
@property (retain,nonatomic) RSSObject* video;


@end
