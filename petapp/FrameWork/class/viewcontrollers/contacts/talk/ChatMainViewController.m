//
//  ChatMainViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ChatMainViewController.h"
#import "GroupDetailViewController.h"
#import "ChatPanel.h"
#import "GTGZScroller.h"
#import "GTGZThemeManager.h"
#import "ChatCell.h"
#import "ChatImageCell.h"
#import "GroupMessage.h"
#import "PetUser.h"
#import "DataCenter.h"
#import "AsyncTask.h"
#import "TalkManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AlertUtils.h"
#import "GroupModel.h"
#import "GTGZUtils.h"
#import "RootViewController.h"
#import "SettingManager.h"

@interface ChatMainViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate,UIActionSheetDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,ChatPanelDelegate>

-(void)groupDetail;

-(void)sendImage:(UIImage*)image;

-(void)sendText:(NSString*)text isImage:(BOOL)isImage;

-(void)sync;
-(void)syncTimeEvent;
@end

@implementation ChatMainViewController

@synthesize groupModel;

-(id)init{
    self=[super init];
    if(self){
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"groupDetail") target:self action:@selector(groupDetail)];
        
        chatArray=[[NSMutableArray alloc] initWithCapacity:3];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    firstLoad=YES;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"chat_bg.png"]];
    
    
    chatPanel=[[ChatPanel alloc] init];
    chatPanel.delegate=self;

    CGRect rect=self.view.frame;
    
    rect.size.height-=chatPanel.frame.size.height;
    
    tableView=[[GTGZTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.touchDelegate=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];


    chatPanel.superViewHeight=self.view.frame.size.height;
    rect=chatPanel.frame;
    rect.origin.y=self.view.frame.size.height-rect.size.height-2.0f;
    chatPanel.frame=rect;
    [self.view addSubview:chatPanel];
    [chatPanel release];

    [self sync];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [syncTimer invalidate];
    syncTimer=nil;
    [task cancel];

    self.groupModel=nil;
    [super dealloc];
}

#pragma mark method

-(void)setGroupModel:(GroupModel *)value{
    [groupModel release];
    if(value==nil){
        groupModel=nil;
        return;
    }
    groupModel=[[GroupModel alloc] init];
    groupModel.groupId=value.groupId;
    groupModel.groupName=value.groupName;
    groupModel.petUser=value.petUser;
    groupModel.user_count=value.user_count;
    groupModel.type=value.type;
    groupModel.desc=value.desc;
    groupModel.location=value.location;
    groupModel.createtime=value.createtime;
    
}


-(void)sync{
    [syncTimer invalidate];
    syncTimer=nil;
    [task cancel];
    
    
    MBProgressHUD* progressHUD=nil;
    
    if(firstLoad){
        progressHUD=[AlertUtils showLoading:lang(@"loading") view:self.view];
        
        [progressHUD show:NO];
    }
    
    task=[[AppDelegate appDelegate].talkManager syncTalk:self.groupModel.groupId];
    [task setFinishBlock:^{
        [progressHUD hide:NO];
        if([task result]!=nil){
            
            BOOL _scrollToBottom=NO;
            if([chatArray count]>0){
                GroupMessage* msg=[chatArray lastObject];
                NSArray* list=[task result];
                if([list count]>0){
                    GroupMessage* _msg=[list lastObject];
                    _scrollToBottom=(![msg.msgId isEqualToString:_msg.msgId]);
                }
            }
            [chatArray removeAllObjects];
            [chatArray addObjectsFromArray:[task result]];
            [tableView reloadData];
            if(firstLoad)
                _scrollToBottom=YES;

            if(_scrollToBottom)
                [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.05];
        }
        else{
            if([task error]!=nil){
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:[task errorMessage] message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        firstLoad=NO;

        task=nil;
        
        [syncTimer invalidate];
        syncTimer=[NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(syncTimeEvent) userInfo:nil repeats:NO];
    }];
}

-(void)syncTimeEvent{
    
    [self sync];
}

-(void)scrollToBottom{
    if([chatArray count]>1)
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}



-(void)groupDetail{
    GroupDetailViewController* controller=[[GroupDetailViewController alloc] init];
    controller.groupModel=self.groupModel;
    controller.title=self.title;
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}


-(void)sendImage:(UIImage*)image{

    [syncTimer invalidate];
    syncTimer=nil;
    [task cancel];
    MBProgressHUD* progressHUD=[AlertUtils showLoading:lang(@"loading") view:self.view];
    
    [progressHUD show:NO];

    image=[GTGZUtils imageWithThumbnail:image size:CGSizeMake(800.0f, 800.0f)];
    NSData* data=UIImageJPEGRepresentation(image,70);
    
    task=[[AppDelegate appDelegate].settingManager fileUpload:data type:@"user"];
    [task setFinishBlock:^{
        [progressHUD hide:NO];

        NSString* link=@"";
        if([task result]!=nil){
            link=[task result];
        }
        task=nil;
        
        if([link length]>0){
            [self sendText:link isImage:YES];
        }
        else{
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"fileUploadFailed") message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }];
}

-(void)sendText:(NSString*)text isImage:(BOOL)isImage{
    [syncTimer invalidate];
    syncTimer=nil;
    [task cancel];
    MBProgressHUD* progressHUD=[AlertUtils showLoading:lang(@"loading") view:self.view];
    
    [progressHUD show:NO];
    
    task=[[AppDelegate appDelegate].talkManager sendChat:self.groupModel.groupId content:text isImage:isImage];
    
    [task setFinishBlock:^{
        [progressHUD hide:NO];
        
        if(![task status]){
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:[task errorMessage] message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else{
            GroupMessage* groupMessage=[[GroupMessage alloc] init];
            groupMessage.msgId=@"-1";
            groupMessage.content=text;
            groupMessage.sender=[DataCenter sharedInstance].user;
            groupMessage.createtime=[NSDate date];
            groupMessage.isImage=NO;
            
            [chatArray addObject:groupMessage];
            [tableView reloadData];
            
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
        task=nil;
        [self sync];
    }];

}


#pragma mark tableview delegate  datasource

- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event{
    [chatPanel resignFirstResponder];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [chatPanel resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [chatArray count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMessage* model=[chatArray objectAtIndex:[indexPath row]];
    if(model.isImage){
        return [ChatImageCell cellHeight];
    }
    else{
        return [ChatCell cellHeight:model.content];
    }
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMessage* model=[chatArray objectAtIndex:[indexPath row]];

    NSString* myId=[DataCenter sharedInstance].user.uid;
    if(!model.isImage){
        ChatCell* cell=(ChatCell*)[_tableView dequeueReusableCellWithIdentifier:@"chat_cell"];
        if(cell==nil){
            cell=[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chat_cell"];
            
            
        }
        [cell headerUrl:model.sender.imageHeadUrl name:model.sender.nickname content:model.content bubbleType:([myId isEqualToString:model.sender.uid]?BubbleTypeMine:BubbleTypeSomeoneElse)];
        return cell;
    }
    else{
        ChatImageCell* cell=(ChatImageCell*)[_tableView dequeueReusableCellWithIdentifier:@"image_cell"];
        if(cell==nil){
            cell=[[ChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image_cell"];
            
            
        }
        [cell headerUrl:model.sender.imageHeadUrl name:model.sender.nickname contentUrl:model.content bubbleType:([myId isEqualToString:model.sender.uid]?BubbleTypeMine:BubbleTypeSomeoneElse)];
        return cell;

    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [chatPanel resignFirstResponder];
}

#pragma mark chat panel delegate


-(void)chatPanelKeyworkShow:(int)height{
    CGRect rect= tableView.frame;
    rect.size.height=CGRectGetMinY(chatPanel.frame);
    tableView.frame=rect;
}


-(void)chatPanelDidSelectedAdd:(ChatPanel*)__chatPanel{
    [chatPanel resignFirstResponder];
    
    if([[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0){
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从手机相片图库中选取" otherButtonTitles:nil, nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [sheet showInView:[AppDelegate appDelegate].rootViewController.view];
        [sheet release];
    }
    else{
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相片图库中选取", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [sheet showInView:[AppDelegate appDelegate].rootViewController.view];
        [sheet release];

    }
}

-(void)chatPanelDidSend:(ChatPanel*)_chatPanel{
    NSString* text=[GTGZUtils trim:_chatPanel.text];
    if([text length]<1){
        return;
    }
    _chatPanel.text=nil;
    [_chatPanel resignFirstResponder];
    
    [self sendText:text isImage:NO];
}


#pragma mark actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==2)return;
    
    if([[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0 && buttonIndex==1)return;
    
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.videoQuality=UIImagePickerControllerQualityTypeLow;
    picker.delegate = self;
    
    if(buttonIndex==1 || [[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            
        }
    }
    else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
        }
    }
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {

        UIPopoverController *popover = [[[UIPopoverController alloc] initWithContentViewController:picker] autorelease];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
            [picker.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        [self presentViewController:picker animated:YES completion:^{}];
        
    }
}

#pragma mark imagepicker delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popoverController.delegate=nil;
    [popoverController dismissPopoverAnimated:NO];
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popoverController.delegate=nil;
    [popoverController dismissPopoverAnimated:NO];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    picker.delegate=nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        NSString *imageKey = @"UIImagePickerControllerOriginalImage";
        UIImage* image=nil;
        image=[info objectForKey:imageKey];
        if(image!=nil && picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
        }
        
        [self sendImage:image];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker.delegate=nil;
    [picker dismissModalViewControllerAnimated:YES];
}



@end
