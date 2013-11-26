//
//  ChatImageCell.m
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import "ChatImageCell.h"
#import "ImageDownloadedView.h"
#import "GTGZImageDownloadedManager.h"
#import "Utils.h"

@interface ChatImageCell()
@end


@implementation ChatImageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        float size=([Utils isIPad]?75.0f:35.0f);
        imageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)];
        [self addSubview:imageView];
        [imageView release];
        
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.numberOfLines=1;
        [nameLabel theme:@"chatcell_name"];
        [self addSubview:nameLabel];
        [nameLabel release];
        
        bubbleView=[[UIImageView alloc] init];
        [self addSubview:bubbleView];
        [bubbleView release];
        
        size=([Utils isIPad]?300.0f:130.0f);

        contentImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)];
        contentImageView.defaultLoadingfile=@"noPic.png";
        [bubbleView addSubview:contentImageView];
        [contentImageView release];
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    
}


-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name contentUrl:(NSString*)contentUrl  bubbleType:(NSBubbleType)_bubbleType{
    
    [imageView setUrl:headerUrl];
    nameLabel.text=name;
    
    [contentImageView setUrl:contentUrl];
    
    bubbleType=_bubbleType;
    
}

+(float)cellHeight{
    float height=0.0f;
    float size=([Utils isIPad]?300.0f:130.0f);

    if(![Utils isIPad]){
        height=8+15.0f;


        height+=5.0f+10.0f+size+10.0f;
        height+=8.0f;
        
        if(height<10.0f+35.0f+10.0f)
            height=10.0f+35.0f+10.0f;
        
    }
    else{
        height=16.0f+30.0f;
        height+=15.0f+25.0f+size+25.0f;
        height+=16.0f;
        
        if(height<20.0f+75.0f+20.0f)
            height=20.0f+75.0f+20.0f;
    }
    return height;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(![Utils isIPad]){
        if(bubbleType==BubbleTypeSomeoneElse){
            CGRect rect=imageView.frame;
            rect.origin.x=20.0f;
            rect.origin.y=10.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentLeft;

            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageView.frame)+15.0f, 8.0f, 200.0f, 15.0f);
            
            bubbleView.image=[ChatCell bubbleSomeoneImg];
            
            rect.size.width=20.0f+contentImageView.frame.size.width+15.0f;
            if(rect.size.width<150)
                rect.size.width=150.0f;

            rect.size.height=10.0f+contentImageView.frame.size.height+10.0f;
            rect.origin.x=CGRectGetMaxX(imageView.frame)+5.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;

            
            bubbleView.frame=rect;
            
            rect=contentImageView.frame;
            rect.origin.x=20.0f;
            rect.origin.y=10.0f;
            contentImageView.frame=rect;
        }
        else{
            
            CGRect rect=imageView.frame;
            rect.origin.x=self.frame.size.width-rect.size.width-20.0f;
            rect.origin.y=10.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentRight;

            nameLabel.frame=CGRectMake(CGRectGetMinX(imageView.frame)-200.0f-15.0f, 8.0f, 200.0f, 15.0f);
            
            bubbleView.image=[ChatCell bubbleMineImg];
            
            rect.size.width=15.0f+contentImageView.frame.size.width+20.0f;
            if(rect.size.width<150)
                rect.size.width=150.0f;

            rect.size.height=10.0f+contentImageView.frame.size.height+10.0f;
            rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width-5.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+5.0f;
            
            bubbleView.frame=rect;
            
            rect=contentImageView.frame;
            rect.origin.x=bubbleView.frame.size.width-rect.size.width-20.0f;
            rect.origin.y=10.0f;
            contentImageView.frame=rect;
            
        }
    }
    else{
        if(bubbleType==BubbleTypeSomeoneElse){
            CGRect rect=imageView.frame;
            rect.origin.x=40.0f;
            rect.origin.y=20.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentLeft;

            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageView.frame)+30.0f, 16.0f, 450.0f, 30.0f);
            
            bubbleView.image=[ChatCell bubbleSomeoneImg];
            
            
            rect.size.width=40.0f+contentImageView.frame.size.width+25.0f;
            
            if(rect.size.width<350.0f)
                rect.size.width=350.0f;

            
            rect.size.height=25.0f+contentImageView.frame.size.height+25.0f;
            rect.origin.x=CGRectGetMaxX(imageView.frame)+20.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+15.0f;


            bubbleView.frame=rect;
            
            rect=contentImageView.frame;
            rect.origin.x=40.0f;
            rect.origin.y=25.0f;
            contentImageView.frame=rect;
        }
        else{
            
            CGRect rect=imageView.frame;
            rect.origin.x=self.frame.size.width-rect.size.width-40.0f;
            rect.origin.y=20.0f;
            imageView.frame=rect;
            
            nameLabel.textAlignment=NSTextAlignmentRight;

            nameLabel.frame=CGRectMake(CGRectGetMinX(imageView.frame)-450.0f-30.0f, 16.0f, 450.0f, 30.0f);
            
            bubbleView.image=[ChatCell bubbleMineImg];
            
            rect.size.width=25.0f+contentImageView.frame.size.width+40.0f;

            if(rect.size.width<350.0f)
                rect.size.width=350.0f;

            rect.size.height=25.0f+contentImageView.frame.size.height+25.0f;
            rect.origin.x=CGRectGetMinX(imageView.frame)-rect.size.width-20.0f;
            rect.origin.y=CGRectGetMaxY(nameLabel.frame)+15.0f;
            

            bubbleView.frame=rect;
            
            rect=contentImageView.frame;
            rect.origin.x=25.0f;
            rect.origin.y=15.0f;
            contentImageView.frame=rect;
            
        }
    }
}


@end
