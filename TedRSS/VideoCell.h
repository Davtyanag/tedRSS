//
//  VideoCell.h
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSObject.h"
@protocol VideoCellDelegate <NSObject>
- (void) playVideo: (RSSObject *) video;
@end
@interface VideoCell : UITableViewCell
@property (nonatomic,weak) UIImageView *videoView;
@property (nonatomic,weak) UIView *borderView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *descrtiptionLabel;
@property (nonatomic,retain) RSSObject* video;
@property (nonatomic, assign)id <VideoCellDelegate> delegate;

@end
