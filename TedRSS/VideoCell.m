//
//  VideoCell.m
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import "VideoCell.h"



@implementation VideoCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)playVideo:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(playVideo:)]) {
        
        [_delegate performSelector:@selector(playVideo:) withObject:self.video];
    }
}
@end
