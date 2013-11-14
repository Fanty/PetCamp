//
//  PetNewsDetailViewController.m
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsDetailViewController.h"
#import "iCarousel.h"
#import "PullTableView.h"
#import "PetNewsDetailHeader.h"
#import "PetNewsModel.h"
#import "ImageDownloadedView.h"
#import "PetUser.h"
#import "AsyncTask.h"
#import "ImageShowFullScreenView.h"
#import "CommandCell.h"
#import "WriterView.h"
#import "Utils.h"
#import "CommentModel.h"
#import "GTGZUtils.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "PetNewsAndActivatyManager.h"
#import "MBProgressHUD.h"
#import "AlertUtils.h"
#import "HeadTabView.h"
#import "WeiboEngine.h"
#import "DataCenter.h"

@interface PetNewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate,iCarouselDataSource,iCarouselDelegate,WriterViewDelegate,UIActionSheetDelegate,HeadTabViewDelegte,UIAlertViewDelegate>
-(void)initHeader;
-(void)initLoading;
-(void)loadDetailData;
-(void)loadCommandData;
-(void)menuClick;
-(void)doLikeAction;
-(void)doSendComment:(NSString*)content;
@end

@implementation PetNewsDetailViewController
@synthesize pid;

-(id)init{
    self=[super init];
    self.title=lang(@"petNewsEditTitle");
    [self backNavBar];
    
    [self rightNavBar:@"menu_header.png" target:self action:@selector(menuClick)];

    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    offset=0;
    
    [self initLoading];
    [self loadDetailData];

    DataCenter* dataCenter=[DataCenter sharedInstance];
    if(dataCenter.showUpdatePetNews){
        dataCenter.showUpdatePetNews=NO;
        [dataCenter save];
    }


    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [writerView close];
    [writerView release];
    [headerDetail release];
    [bgViewCarousel release];
    [imagesCarousel release];
    [petNewsModel release];
    [commands release];
    
    petNewsModel=nil;
    writerView=nil;
    headerDetail=nil;
    bgViewCarousel=nil;
    imagesCarousel=nil;
    commands=nil;
}

-(void)dealloc{
    self.pid=nil;
    [writerView close];
    [writerView release];
    writerView=nil;

    [headerDetail release];
    [bgViewCarousel release];
    [imagesCarousel release];
    [petNewsModel release];
    [commands release];
    [super dealloc];
}


#pragma mark method

-(void)initHeader{
    if(headerDetail!=nil)return;
    headerDetail=[[PetNewsDetailHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    NSDate* date=petNewsModel.updatedate;
    if(date==nil)
        date=petNewsModel.createdate;
    [headerDetail headerImageUrl:petNewsModel.petUser.imageHeadUrl name:petNewsModel.petUser.nickname date:date content:petNewsModel.desc comment:petNewsModel.command_count favior:petNewsModel.laudCount];
    
    float left=([Utils isIPad]?30.0f:10.0f);

    
    float size=self.view.frame.size.width-left*2.0f;
    
    bgViewCarousel=[[UIView alloc] initWithFrame:CGRectMake(left, 0.0f, size, [petNewsModel.imageUrls count]>0?size:0.0f)];
    bgViewCarousel.clipsToBounds=YES;
  //  if([Utils isIPad]){
        bgViewCarousel.backgroundColor=[GTGZUtils colorConvertFromString:@"#BCBCBC"];
  //  }
  //  else{
   //     bgViewCarousel.backgroundColor=[GTGZUtils colorConvertFromString:@"#282828"];
 //   }
    
    imagesCarousel=[[iCarousel alloc] initWithFrame:CGRectMake(left, left, size-left*2.0f, size-left*2.0f)];
    imagesCarousel.clipsToBounds=YES;
    imagesCarousel.dataSource=self;
    imagesCarousel.delegate=self;
    imagesCarousel.bounces=NO;
    imagesCarousel.type=iCarouselTypeLinear;
    [bgViewCarousel addSubview:imagesCarousel];
    
}

-(void)initLoading{
    loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.frame=CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
    loadingView.center=self.view.center;
    [self.view addSubview:loadingView];
    [loadingView release];
}


-(void)loadDetailData{
    [loadingView startAnimating];
    [noLabelButton removeFromSuperview];
    noLabelButton=nil;
    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager petNewsDetail:self.pid];
    [task setFinishBlock:^{
        
        [loadingView stopAnimating];
        [petNewsModel release];
        petNewsModel=nil;
        NSArray* array=[task result];
        if([array count]>0){
            petNewsModel=[[array objectAtIndex:0] retain];
        }
        task=nil;
        if(petNewsModel!=nil){
            [loadingView removeFromSuperview];
            loadingView=nil;
            
            
            
            tabView=[[HeadTabView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, ([Utils isIPad]?75.0f:45.0f))];
            tabView.hightlightWhenTouch=YES;
            tabView.delegate=self;
            [tabView showHighlight:NO];
            
            CGRect rect=self.view.bounds;
            rect.size.height-=tabView.frame.size.height;
            tableView=[[PullTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
            
            tableView.backgroundColor=[UIColor clearColor];
            tableView.showsHorizontalScrollIndicator=NO;
            tableView.showsVerticalScrollIndicator=NO;
            tableView.scrollsToTop=YES;
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            tableView.delegate=self;
            tableView.touchDelegate=self;
            tableView.dataSource=self;
            [self.view addSubview:tableView];
            [tableView release];
            
            [tabView setTabNameArray:[NSArray arrayWithObjects:lang(@"comment"),lang(@"share"),lang(@"like"), nil]];
            
            rect=tabView.frame;
            rect.origin.y=self.view.frame.size.height-rect.size.height;
            tabView.frame=rect;
            
            [self.view addSubview:tabView];
            
            [tabView release];
            
            [tableView createLoadMoreFooter];
            tableView.loadMoreState=PullTableViewLoadMoreStateDragLoading;
            [self loadCommandData];
        }
        else{
            
            //[AlertUtils showAlert:[task errorMessage] view:self.view];
            if(noLabelButton==nil){
                noLabelButton=[UIButton buttonWithType:UIButtonTypeCustom];
                noLabelButton.backgroundColor=[UIColor clearColor];
                [noLabelButton setTitle:lang(@"reNoLabelClick") forState:UIControlStateNormal];
                [noLabelButton theme:@"reNoLabelClick"];
                noLabelButton.frame=self.view.bounds;
                [noLabelButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:noLabelButton];
            }
            [self.view bringSubviewToFront:noLabelButton];
        }
    }];

}


-(void)loadCommandData{

    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager petNewsCommentList:self.pid offset:offset];
    [task setFinishBlock:^{
        tableView.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){
            [tableView releaseLoadMoreFooter];
        }
        else{
            offset++;
            NSArray* array=[task result];
            
            if(commands==nil){
                commands=[[NSMutableArray alloc] initWithCapacity:2];
            }
            
            if([array count]>0)
                [commands addObjectsFromArray:array];
            
            if([array count]<HTTP_PAGE_SIZE){
                [tableView releaseLoadMoreFooter];
            }
            else{
                [tableView createLoadMoreFooter];
            }
            [tableView reloadData];
        }
        task=nil;
        
    }];
}

-(void)menuClick{
    if(task==nil){
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        int cancelButtonIndex=0;
        int destructiveButtonIndex=0;
        //[sheet addButtonWithTitle:lang(@"send_friend")];
        if([petNewsModel.imageUrls count]>0){
            [sheet addButtonWithTitle:lang(@"savePicture")];
            destructiveButtonIndex++;
            cancelButtonIndex++;
        }
        if(![petNewsModel.petUser.uid isEqualToString:[DataCenter sharedInstance].user.uid]){
//            [sheet addButtonWithTitle:lang(@"report")];
        }
        else{
            [sheet addButtonWithTitle:lang(@"delete")];
            sheet.destructiveButtonIndex=destructiveButtonIndex;
            cancelButtonIndex++;
        }

        
        [sheet addButtonWithTitle:lang(@"cancel")];
        sheet.cancelButtonIndex=cancelButtonIndex;
        [sheet showInView:[AppDelegate appDelegate].rootViewController.view];
        
        [sheet release];
    }
}

-(void)doLikeAction{
    if(task==nil){
        MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
        [hud show:YES];
        
        [task cancel];
        task=[[AppDelegate appDelegate].petNewsAndActivatyManager likePost:self.pid];
        [task setFinishBlock:^{
            [hud hide:NO];
            if(![task status]){
                [AlertUtils showAlert:lang(@"doLikeSame") view:self.view];
            }
            else{
                [AlertUtils showAlert:lang(@"thanks_like") view:self.view];
                petNewsModel.laudCount++;
                [headerDetail favior:petNewsModel.laudCount];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePetNewsListNotification object:nil];
            }
            
            task=nil;
            
        }];
    }

}

-(BOOL)canBackNav{
    return (task==nil);
}

-(void)doSendComment:(NSString *)content{
    if(task==nil){
        MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
        [hud show:YES];
        
        [task cancel];
        task=[[AppDelegate appDelegate].petNewsAndActivatyManager createPetNewsComment:self.pid content:content];
        [task setFinishBlock:^{
            [hud hide:NO];
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
                task=nil;

            }
            else{
                task=nil;
                petNewsModel.command_count++;
                [headerDetail comment:petNewsModel.command_count];

                [AlertUtils showAlert:lang(@"commentsuccess") view:self.view];

                [commands release];
                commands=nil;
                [tableView reloadData];

                offset=0;
                [self loadCommandData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePetNewsListNotification object:nil];

            }
            
            
        }];
    }
}


#pragma mark table delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(task==nil && tableView.dragging && !tableView.decelerating)
        [tableView checkLoadMoreScrollingState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(task==nil && tableView.loadMoreState==PullTableViewLoadMoreStateDragStartLoad){
        tableView.loadMoreState=PullTableViewLoadMoreStateDragLoading;
        [self loadCommandData];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(task==nil &&  tableView.loadMoreState==PullTableViewLoadMoreStateDragUp){
        tableView.loadMoreState=PullTableViewLoadMoreStateDragStartLoad;
   }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [commands count]+2;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self initHeader];
    if([indexPath row]==0){
        return headerDetail.frame.size.height;
    }
    else if([indexPath row]==1){
        return bgViewCarousel.frame.size.height+20.0f;
    }
    else{
        return [CommandCell cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [self initHeader];
        }
        [cell addSubview:headerDetail];
        
        return cell;
    }
    else if([indexPath row]==1){
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondCell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [self initHeader];
        }
        [cell addSubview:bgViewCarousel];
        
        return cell;
    }
    else{
        
        CommandCell *cell = (CommandCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[CommandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];

        }
        
        CommentModel* model=[commands objectAtIndex:[indexPath row]-2];

        [cell nickname:model.petUser.nickname headerImageUrl:model.petUser.imageHeadUrl content:model.content date:model.createdate];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark carousel  delegate  datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [petNewsModel.imageUrls count];
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel{
    return NO;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    if(view==nil){
        view=[[[ImageDownloadedView alloc] initWithFrame:carousel.bounds] autorelease];
        
        view.contentMode=UIViewContentModeScaleAspectFit;
    }
    

    NSString* imageUrl=[petNewsModel.imageUrls objectAtIndex:index];
    
    ImageDownloadedView* imgView=(ImageDownloadedView*)view;    
    imgView.thumbnailSize=carousel.bounds.size;
    [imgView setUrl:imageUrl];
	return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if(option==iCarouselOptionVisibleItems)
        return 3;
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    ImageShowFullScreenView* view=[[ImageShowFullScreenView alloc] init];
    [view setArray:petNewsModel.imageUrls];
    [view showInWindow];
    [view showImage:index];
    [view release];
}


#pragma mark  writerview delegate

-(void)didPostInWriterView:(WriterView*)_writerView{
    NSString* content=[GTGZUtils trim:writerView.text];
    if([content length]>0){
        [self doSendComment:content];
    }
    
    [writerView close];
    [writerView release];
    writerView=nil;
}

-(void)didCancelInWriterView:(WriterView*)_writerView{
    
}

#pragma mark  action sheet delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    int deleteIndex=0;
    if([petNewsModel.imageUrls count]>0){
        deleteIndex++;
        if(buttonIndex==0){
            UIImage* img=((ImageDownloadedView*)imagesCarousel.currentItemView).image;
            UIImageWriteToSavedPhotosAlbum(img, nil,nil, nil);
            [AlertUtils showAlert:lang(@"successSaveImage") view:self.view];
        }
    }
    if([petNewsModel.petUser.uid isEqualToString:[DataCenter sharedInstance].user.uid]){
        if(deleteIndex==buttonIndex){
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:lang(@"confirmToDelete") message:nil delegate:self cancelButtonTitle:lang(@"cancel") otherButtonTitles:lang(@"confirm"), nil];
            [alert show];
            [alert release];
        }
    }
}

#pragma mark  headtabbar delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    if(index==0){
        if(writerView==nil){
            writerView=[[WriterView alloc] init];
            writerView.delegate=self;
        }
        [writerView buttonText:lang(@"command")];
        [writerView placeholder:lang(@"write_command")];
        
        [writerView show];

    }
    else if(index==1){
        [WeiboEngine defaultWebboEngine].webboDelegate=nil;
        [[WeiboEngine defaultWebboEngine] share:petNewsModel.desc];
    }
    else if(index==2){
        [self doLikeAction];
    }
}

#pragma mark alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
        [hud show:YES];

        task=[[AppDelegate appDelegate].petNewsAndActivatyManager deletePost:self.pid];
        [task setFinishBlock:^{
            [hud hide:NO];
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePetNewsListNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            task=nil;
        }];
    }
}



@end
