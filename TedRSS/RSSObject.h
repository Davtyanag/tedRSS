//
//  RSSObject.h
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWFeedItem.h>
@interface RSSObject : NSObject
-(RSSObject*) initWithTitle:(NSMutableString*) title
                      image:(NSMutableString*) image
                descriptionText:(NSMutableString*) descriptionText
                       videoURL:(NSMutableString*)videoURL;

@property (nonatomic, copy) NSMutableString *title;
@property (nonatomic, copy) NSMutableString *imageURL;
@property (nonatomic, copy) NSMutableString *videoURL;
@property (nonatomic, copy) NSMutableString *descriptionText;

@end
