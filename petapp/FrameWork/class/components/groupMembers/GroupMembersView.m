//
//  GroupMembersView.m
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupMembersView.h"

#import "ImageDownloadedView.h"

@interface GroupMembersView()<UIScrollViewDelegate>

@end

@implementation GroupMembersView

- (id)initWithFrame:(CGRect)frame{
    frame.size.height=[GroupMembersView height];
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, frame.size.width, 25.0f)];
        titleLabel.numberOfLines=1;
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.numberOfLines=1;
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.font=[UIFont boldSystemFontOfSize:18.0f];
        [self addSubview:titleLabel];
        [titleLabel release];

        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 35.0f, frame.size.width, 50.0f)];
        scrollView.delegate=self;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        [self addSubview:scrollView];
        
        [scrollView release];
        
    }
    return self;
}

+(float)height{
    return 95.0f;
}

-(void)title:(NSString*)title{
    titleLabel.text=title;
}

-(void)setImages:(NSArray*)array{
    float offset=2.0f;
    float left=0.0f;
    float size=scrollView.frame.size.height;
    for(NSString* url in array){
        ImageDownloadedView* imageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(left, 0.0f, size, size)];
        [imageView setUrl:url];
        [scrollView addSubview:imageView];
        [imageView release];
        left+=size+offset;
    }
    
    scrollView.contentSize=CGSizeMake(left, scrollView.frame.size.height);
}

@end
