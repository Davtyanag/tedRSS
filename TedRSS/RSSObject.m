//
//  RSSObject.m
//  TedRSS
//
//  Created by Arman on 24.04.15.
//  Copyright (c) 2015 Mancho. All rights reserved.
//

#import "RSSObject.h"


@implementation RSSObject

-(RSSObject*) initWithTitle:(NSMutableString*) title
                      image:(NSMutableString*) image
            descriptionText:(NSMutableString*) descriptionText
                   videoURL:(NSMutableString*)videoURL{
    RSSObject* object=[[RSSObject alloc] init];
    object.title=title;
    object.imageURL=image;
    object.descriptionText=descriptionText;
    object.videoURL=videoURL;
    return object;
}
@end
