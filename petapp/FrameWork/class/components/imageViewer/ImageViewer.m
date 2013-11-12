//
//  ImageViewer.m
//  PetNews
//
//  Created by 肖昶 on 13-9-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ImageViewer.h"
#import "GTGZHorizalTableView.h"
#import "BannerModel.h"
#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
#define IMAGE_TAB   335
#define   BANNER_HEIGHT   120.0f
#define   IPAD_BANNER_HEIGHT  326.0f

@interface ImageViewer()<GTGZHorizalTableViewDataSource>
-(void)timerEvent;
-(void)addCellClick:(GTGZHorizalTableViewCell*)cell;
@end

@implementation ImageViewer
@synthesize list;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        tableView=[[GTGZHorizalTableView alloc] initWithFrame:CGRectMake(0.0f,0.0f, frame.size.width, ([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT))];
        tableView.scrollsToTop=NO;
        tableView.dataSource=self;
        tableView.scrollsToTop=NO;
        tableView.pagingEnabled=YES;
        //tableView.clipsToBounds=YES;
        
        tableView.multipleTouchEnabled=NO;
        tableView.directionalLockEnabled=YES;
        tableView.exclusiveTouch=YES;
        tableView.bounces=YES;
        tableView.backgroundColor=[UIColor clearColor];
        [self addSubview:tableView];
        
        [tableView release];
        
        float pageControlheight=([Utils isIPad]?80.0f:40.0f);
        pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT)-pageControlheight, self.frame.size.width, pageControlheight)];
        
        pageControl.userInteractionEnabled=NO;
        [self addSubview:pageControl];
        [pageControl release];
        
        timer=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)dealloc{
    [timer invalidate];
    self.list=nil;
    [super dealloc];
}

- (GTGZHorizalTableViewCell *)dataView:(GTGZHorizalTableView *)_tableView rowIndex:(int)rowIndex{
    GTGZHorizalTableViewCell* cell=[_tableView dequeueReusableCell];
    if(cell==nil){
        cell=[[[GTGZHorizalTableViewCell alloc] init] autorelease];
        [cell addTarget:self action:@selector(addCellClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.tag=rowIndex;
    BannerModel* info=([list objectAtIndex:rowIndex]);
    NSString* url=info.imageUrl;
    
    
    
    ImageDownloadedView* imageView=(ImageDownloadedView*)[cell viewWithTag:IMAGE_TAB];
    if(imageView==nil){
        imageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
        imageView.clipsToBounds=YES;
        imageView.thumbnailSize=imageView.frame.size;
        imageView.tag=IMAGE_TAB;
        [cell addSubview:imageView];
        [imageView release];
    }
    [imageView setUrl:url];
    return cell;
    
}

-(int)dataViewRowsCount:(GTGZHorizalTableView*)tableView{
    return [self.list count];
}



-(void)dataViewEndDraging:(GTGZHorizalTableView*)_tableView{
    
    if([list count]>1){
        float x=tableView.contentOffset.x;
        for(int i=0;i<[self.list count];i++){
            GTGZHorizalTableViewCell* cell=[tableView cellForRowIndex:i];
            if(cell!=nil){
                CGRect rect=cell.frame;
                rect.origin.x-=x;
                rect.origin.x=floor(rect.origin.x);
                if(rect.origin.x>=0 && rect.origin.x<self.frame.size.width){
                    int currentPage=i-1;
                    if(i==0){
                        currentPage=[self.list count]-2;
                        tableView.contentOffset=CGPointMake(tableView.contentSize.width-tableView.frame.size.width*2.0f, 0.0f);
                    }
                    else if(i>=[self.list count]-1){
                        currentPage=0;
                        tableView.contentOffset=CGPointMake(tableView.frame.size.width, 0.0f);
                    }
                    pageControl.currentPage=currentPage;
                    currentPage++;

                    [timer invalidate];
                    timer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
                    
                    break;
                }
            }
        }
    }
}


-(void)setList:(NSArray *)value{
    [list release];
    if([value count]<1){
        list=nil;
        return;
    }
    NSMutableArray*  array=[[NSMutableArray alloc] initWithCapacity:2];
    if([value count]>1){
        [array addObject:[value lastObject]];
    }
    [array addObjectsFromArray:value];
    if([value count]>1){
        [array addObject:[value objectAtIndex:0]];
    }
    list=[array retain];
    [array release];
    
    pageControl.currentPage=0;
    pageControl.numberOfPages=[value count];
    
    if([value count]>1)
        tableView.contentOffset=CGPointMake(tableView.frame.size.width, 0.0f);
}

-(void)timerEvent{
    if([list count]<2 ||  self.superview==nil){
        [timer invalidate];
        timer=nil;
        return;
    }
    
    float currentPage=pageControl.currentPage;
    float x=0.0f;
    currentPage++;
    
    if(currentPage>= pageControl.numberOfPages){
        currentPage=0;
        [tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        
    }
    
    
    x=tableView.frame.size.width*(currentPage+1);
    
    pageControl.currentPage=currentPage;
    tableView.pagingEnabled=([list count]>1);
    [tableView setContentOffset:CGPointMake(x, 0.0f) animated:YES];
}

-(void)addCellClick:(GTGZHorizalTableViewCell*)cell{
    if([self.delegate respondsToSelector:@selector(didImageViewerSelected:index:)])
        [self.delegate didImageViewerSelected:self index:cell.tag];
}


@end
