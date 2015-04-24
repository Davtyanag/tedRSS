//
//  DetailVideoViewController.m
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "VideoViewController.h"
#import "VideoCell.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
static NSString * const kTitleElementName = @"title";
static NSString * const kLinkElementName = @"link";
static NSString * const kURLElementName = @"url";
static NSString * const kItemElementName = @"item";
static NSString * const kEnclosureElementName = @"enclosure";
static NSString * const kImageURLElementName = @"itunes:image";
@interface DetailVideoViewController ()<UITableViewDelegate,UITableViewDataSource,VideoCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    UITableView* tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:tableView];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    self.navigationItem.title=@"Description";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat height=[[UIScreen mainScreen] bounds].size.height;
    CGFloat titleHeight=[self heightOfTextForString:self.video.title andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    CGFloat descriptionHeight=[self heightOfTextForString:self.video.descriptionText andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    return height/3+titleHeight+descriptionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat titleHeight=[self heightOfTextForString:self.video.title andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    CGFloat descriptionHeight=[self heightOfTextForString:self.video.descriptionText andFontSize:15 maxSize:CGSizeMake(width-40, CGFLOAT_MAX)];
    static NSString* const identifier = @"videoCellIdentifier";
#pragma mark - Create Cell
    CGFloat height=[self heightReturner:indexPath]-titleHeight-descriptionHeight;
    VideoCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    CGRect titleRect=CGRectMake(15, 10, width-30, titleHeight);
    CGRect imageRect=CGRectMake(15,titleHeight, width-30,height-5);
    CGRect borderViewRect=CGRectMake(10, 0, width-20, height+titleHeight+descriptionHeight);
    CGRect descriptionRect=CGRectMake(10, height+titleHeight+5, width-20, descriptionHeight);
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
#pragma mark - Title Label
        UILabel* descrtiptionLabel=[[UILabel alloc] initWithFrame:titleRect];
        descrtiptionLabel.numberOfLines=0;
        descrtiptionLabel.textAlignment=NSTextAlignmentCenter;
        [descrtiptionLabel setFont:[UIFont systemFontOfSize:15.f]];
        [cell addSubview:descrtiptionLabel];
        cell.descrtiptionLabel=descrtiptionLabel;
        
#pragma mark - Border View
        UIView* view=[[UIView alloc] initWithFrame:borderViewRect];
        [view setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:view];
        cell.borderView=view;
    }
    
#pragma mark - Video Setting
    cell.video=self.video;
    cell.delegate=self;
#pragma mark - Title Label Setting
    cell.titleLabel.frame=titleRect;
    cell.titleLabel.text=self.video.title;
#pragma mark - Descrtiption Label Setting
    cell.descrtiptionLabel.frame=descriptionRect;
    cell.descrtiptionLabel.text=self.video.descriptionText;
    
#pragma mark - Video Image View Changing
    [cell.videoView setFrame:imageRect];
    [cell.videoView sd_setImageWithURL:[NSURL URLWithString:self.video.imageURL ]  placeholderImage:[UIImage imageNamed:@"video_default_icon.png"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


@end
