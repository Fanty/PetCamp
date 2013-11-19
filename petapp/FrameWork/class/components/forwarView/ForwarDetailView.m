//
//  ForwarDetailView.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ForwarDetailView.h"
#import "Utils.h"
#import "GTGZUtils.h"
#import "ImageDownloadedView.h"
@implementation ForwarDetailView

- (id)initWithFrame:(CGRect)frame{
    frame.size.height=([Utils isIPad]?150.0f:70.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[GTGZUtils colorConvertFromString:@"#e2e2e2"];
        
        if([Utils isIPad]){
            headView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 160.0f, 120.0f)];
            
            nameView=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+15.0f, 0.0f, frame.size.width-CGRectGetMaxX(headView.frame)-15.0f, 60.0f)];
            contentView=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+15.0f, 60.0f, frame.size.width-CGRectGetMaxX(headView.frame)-15.0f, 0.0f)];

        }
        else{
            headView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 75.0f, 55.0f)];
            
            nameView=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+5.0f, 0.0f, frame.size.width-CGRectGetMaxX(headView.frame)-10.0f, 30.0f)];
            contentView=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame)+5.0f, 30.0f, frame.size.width-CGRectGetMaxX(headView.frame)-10.0f, 0.0f)];

        }
        
        
        [self addSubview:headView];
        [headView release];
        
        nameView.numberOfLines=1;
        [nameView theme:@"forward_name"];
        [self addSubview:nameView];
        [nameView release];
        
        contentView.numberOfLines=0;
        [contentView theme:@"forward_content"];
        [self addSubview:contentView];
        [contentView release];

        
    }
    return self;
}

-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name content:(NSString*)content{
    [headView setUrl:headerUrl];
    nameView.text=[NSString stringWithFormat:@"@%@",name];
    contentView.text=content;
    [contentView sizeToFit];
    CGRect rect=contentView.frame;
    float height=([Utils isIPad]?(self.frame.size.height-60.0f-15.0f):(self.frame.size.height-30.0f-5.0f));
    if(rect.size.height>height){
        rect.size.height=height;
        contentView.frame=rect;
    }
}

@end
