//
//  PetNewsDetailHeader.m
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsDetailHeader.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"

#define HEADER_IMAGE_SIZE  55.0f
#define IPAD_HEADER_IMAGE_SIZE 75.0f

#define OFFSET   15.0f

#define IPAD_OFFSET  30.0f

@implementation PetNewsDetailHeader

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        float size = [Utils isIPad]?IPAD_HEADER_IMAGE_SIZE:HEADER_IMAGE_SIZE;
        
        if([Utils isIPad])
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(IPAD_OFFSET, IPAD_OFFSET, size, size)];
        else
            headerImage=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(OFFSET, OFFSET, size, size)];


        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, CGRectGetMaxY(headerImage.frame)+15.0f, 150.0f, 0.0f)];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"petnewsdetail_title"];
        
        commentImage=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"comment.png"]];
        
        commentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.numberOfLines=1;
        [commentLabel theme:@"petcell_smalltip"];
        
        
        favImage=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"fav.png"]];
        
        favLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        favLabel.numberOfLines=1;
        [favLabel theme:@"petcell_smalltip"];

        

        dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame)+10.0f, 0.0f, 150.0f, 0.0f)];
        dateLabel.numberOfLines=1;
        [dateLabel theme:@"petcell_smalltip"];

        if([Utils isIPad])
            contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(IPAD_OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-IPAD_OFFSET*2.0f, 0.0f)];
        else
            contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(OFFSET, CGRectGetMaxY(headerImage.frame)+15.0f, frame.size.width-OFFSET*2.0f, 0.0f)];
                
        contentLabel.numberOfLines=0;
        [contentLabel theme:@"petnewsdetail_content"];                
        
        [self addSubview:headerImage];
        [self addSubview:nameLabel];
        [self addSubview:commentImage];
        [self addSubview:commentLabel];
        [self addSubview:favImage];
        [self addSubview:favLabel];

        [self addSubview:dateLabel];
        [self addSubview:contentLabel];
        
        
        [headerImage release];
        [nameLabel release];
        [commentImage release];
        [commentLabel release];
        [favImage release];
        [favLabel release];

        [dateLabel release];
        [contentLabel release];
        
    }
    return self;
}

-(void)headerImageUrl:(NSString*)headerImageUrl name:(NSString*)name date:(NSDate*)date content:(NSString*)content comment:(int)comment favior:(int)favior{
    [headerImage setUrl:headerImageUrl];
    
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    dateLabel.text=[NSString stringWithFormat:lang(@"pet_date"),[formatter stringFromDate:date]];
    [formatter release];
    
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];
    favLabel.text=[NSString stringWithFormat:@"%d",favior];

    
    [dateLabel sizeToFit];

    nameLabel.text=name;
    [nameLabel sizeToFit];
    
    contentLabel.text=content;
    [contentLabel sizeToFit];
    
    float h=nameLabel.frame.size.height+10.0f+dateLabel.frame.size.height;
    
    CGRect rect=nameLabel.frame;
    rect.origin.y=CGRectGetMinY(headerImage.frame)+(headerImage.frame.size.height-h)*0.5f;
    nameLabel.frame=rect;
    
    rect=dateLabel.frame;
    rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;
    dateLabel.frame=rect;
    
    
    commentLabel.frame=CGRectMake(0.0f, 0.0f, 30.0f, 16.0f);
    favLabel.frame=CGRectMake(0.0f, 0.0f, 30.0f, 16.0f);
    

        
    float y=CGRectGetMinY(nameLabel.frame);
    
    rect=favLabel.frame;
    rect.origin.x=(self.frame.size.width-rect.size.width);
    rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
    favLabel.frame=rect;

    
    rect=favImage.frame;
    rect.origin.x=CGRectGetMinX(favLabel.frame)-rect.size.width-5.0f;
    rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
    favImage.frame=rect;

    rect=commentLabel.frame;
    rect.origin.x=CGRectGetMinX(favImage.frame)-rect.size.width;
    rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
    commentLabel.frame=rect;

    
    rect=commentImage.frame;
    rect.origin.x=CGRectGetMinX(commentLabel.frame)-rect.size.width-5.0f;
    rect.origin.y=y+(nameLabel.frame.size.height-rect.size.height)*0.5f;
    commentImage.frame=rect;
     

    
    rect=self.frame;
    rect.size.height=CGRectGetMaxY(contentLabel.frame)+10.0f;
    self.frame=rect;
}

-(void)comment:(int)comment{
    commentLabel.text=[NSString stringWithFormat:@"%d",comment];

}

-(void)favior:(int)favior{
    favLabel.text=[NSString stringWithFormat:@"%d",favior];

}
@end

