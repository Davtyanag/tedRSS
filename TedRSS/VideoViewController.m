//
//  ViewController.m
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailVideoViewController.h"
#import "MYMoviePlayerViewController.h"
#import "RSSObject.h"

@interface VideoViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,VideoCellDelegate>
@property (strong,nonatomic) NSString* element;
@property (strong,nonatomic) NSMutableString* titleVideo;
@property (strong,nonatomic) NSMutableString* imageVideo;
@property (strong,nonatomic) NSMutableString* descriptionVideo;
@property (strong,nonatomic) NSMutableString* linkVideo;
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) UITableView *tableView;
@property(retain,nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) NSMutableArray *videosArray;

@end

#pragma mark - Parser constants
static NSString * const kTitleElementName = @"title";
static NSString * const kURLElementName = @"url";
static NSString * const kItemElementName = @"item";
static NSString * const kEnclosureElementName = @"enclosure";
static NSString * const kImageURLElementName = @"itunes:image";
static NSString * const kDescriptionElementName = @"description";



@implementation VideoViewController
#pragma  mark - Interface Orientations
- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma  mark - VideoCellDelegate
- (void) playVideo:(RSSObject*) video{
    NSURL *url=[NSURL URLWithString:video.videoURL];
    MYMoviePlayerViewController *movieController = [[MYMoviePlayerViewController alloc] init];
    movieController.video=video;
    [movieController.moviePlayer setContentURL:url];
    movieController.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
    [self presentMoviePlayerViewControllerAnimated:movieController];
    
}

#pragma mark - Height Returner
-(CGFloat)heightOfTextForString:(NSString *)aString andFontSize:(CGFloat )fontSize maxSize:(CGSize)aSize
{
    
    CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                              options: NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                           attributes: [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize]
                                                                                   forKey:NSFontAttributeName]
                                              context: nil].size;
    
    return ceilf(sizeOfText.height);
}

-(CGFloat) heightReturner:(NSIndexPath *)indexPath{
    RSSObject* video=[self.videosArray objectAtIndex:indexPath.section];
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat height=[[UIScreen mainScreen] bounds].size.height;
    CGFloat titleHeight=[self heightOfTextForString:video.title andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    return height/3+titleHeight;
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailVideoViewController* detailController=[[DetailVideoViewController alloc] init];
    detailController.video=[self.videosArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:detailController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightReturner:indexPath];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.videosArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RSSObject* video=[self.videosArray objectAtIndex:indexPath.section];
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat titleHeight=[self heightOfTextForString:video.title andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    static NSString* const identifier = @"videoCellIdentifier";
#pragma mark - Create Cell
    CGFloat height=[self heightReturner:indexPath]-titleHeight;
    VideoCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    CGRect titleRect=CGRectMake(15, 10, width-30, titleHeight);
    CGRect imageRect=CGRectMake(15,titleHeight, width-30,height-5);
    CGRect borderViewRect=CGRectMake(10, 0, width-20, height+titleHeight);
    if(!cell){
        cell=[[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
#pragma mark - Title Label
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:titleRect];
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [cell addSubview:titleLabel];
        cell.titleLabel=titleLabel;
        //[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
#pragma mark - Video Image View
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:imageRect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(playVideo:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        cell.videoView=imageView;
        
#pragma mark - Border View
        UIView* view=[[UIView alloc] initWithFrame:borderViewRect];
        [view setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:view];
        cell.borderView=view;
    }
    
#pragma mark - Video Setting
    cell.video=video;
    cell.delegate=self;
#pragma mark - Title Label Changing
    cell.titleLabel.frame=titleRect;
    cell.titleLabel.text=video.title ;
    
#pragma mark - Video Image View Changing
    [cell.videoView setFrame:imageRect];
    [cell.videoView sd_setImageWithURL:[NSURL URLWithString:video.imageURL]  placeholderImage:[UIImage imageNamed:@"video_default_icon.png"]];
    [cell.videoView layoutIfNeeded];
#pragma mark - Border View
    
    cell.borderView.frame=borderViewRect;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.borderView.bounds];
    cell.borderView.layer.masksToBounds = NO;
    cell.borderView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.borderView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    cell.borderView.layer.shadowOpacity = 0.2f;
    cell.borderView.layer.shadowPath = shadowPath.CGPath;
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - UITableView
    UITableView* tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:tableView];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
#pragma mark - RSS Parser Init
    self.videosArray=[[NSMutableArray alloc] init];
    NSURL *rssURL = [NSURL URLWithString:@"http://www.ted.com/themes/rss/id/6"];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.parser parse];
    [refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ParseRSS
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.element = elementName;
    if ([self.element isEqualToString:kItemElementName]) {
        
        self.titleVideo   = [[NSMutableString alloc] init];
        self.linkVideo    = [[NSMutableString alloc] init];
        self.imageVideo=[[NSMutableString alloc]init];
        self.descriptionVideo=[[NSMutableString alloc]init];
    }
    
    if ([elementName isEqualToString:kImageURLElementName]) {
        [self.imageVideo appendString:[attributeDict objectForKey:kURLElementName]];
    }
    if ([elementName isEqualToString:kEnclosureElementName]) {
        [self.linkVideo appendString:[attributeDict objectForKey:kURLElementName]];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.element isEqualToString:kTitleElementName]) {
        [self.titleVideo appendString:string];
    }else if([self.element isEqualToString:kDescriptionElementName]){
        [self.descriptionVideo appendString:string];
    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kItemElementName]) {
        
        RSSObject* object=[[RSSObject alloc] initWithTitle:self.titleVideo image:self.imageVideo descriptionText:self.descriptionVideo videoURL:self.linkVideo];
        [self.videosArray addObject:object];
        
    }
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}



@end
