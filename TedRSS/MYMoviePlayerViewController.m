//
//  MYMoviePlayerViewController.m
//  Смотри&Бери
//
//  Created by svatorus on 27.06.14.
//  Copyright (c) 2014 svatorus. All rights reserved.
//

#import "MYMoviePlayerViewController.h"

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MYMoviePlayerViewController ()

@end

@implementation MYMoviePlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    // Do any additional setup after loading the view.
}


- (void) playbackStateChanged:(NSNotification*) notification {
    
    [self performSelector:@selector(callDelegateMethodWithKey:) withObject:@"VIDEO_ENDED_INTERACTION"];
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void) viewDidDisappear:(BOOL)animated{
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}





- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return UIInterfaceOrientationPortrait;
    
}
- (void) callDelegateMethodWithKey: (NSString *) key {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.moviePlayer stop];
    
    
    //[self dismissMoviePlayerViewControllerAnimated];
    
}




@end
