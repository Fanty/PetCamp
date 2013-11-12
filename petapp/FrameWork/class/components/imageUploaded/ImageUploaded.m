//
//  ImageUploaded.m
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ImageUploaded.h"
#import "GTGZThemeManager.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "GTGZUtils.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageSubUploaded()
-(void)closeClick;
@end

@implementation ImageSubUploaded
@synthesize delegate;
@synthesize maxImage;

-(id)initWithImage:(UIImage *)image{
    self.maxImage=image;
    
    self=[super initWithImage:[GTGZUtils imageWithThumbnail:image size:CGSizeMake(200.0f, 200.0f)]];
    
    if(self){
        self.userInteractionEnabled=YES;
        UIImage* closeImg=[[GTGZThemeManager sharedInstance] imageByTheme:@"btn_remove.png"];
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:closeImg forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(0, 0, closeImg.size.width, closeImg.size.height*1.5f);
        [self addSubview:button];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect=button.frame;
    rect.origin.x=self.frame.size.width-rect.size.width;
    rect.origin.y-=rect.size.height*0.1f;
    button.frame=rect;
}


-(void)dealloc{
    self.maxImage=nil;
    [super dealloc];
}

-(void)closeClick{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration =0.3f;
    animation.delegate=self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:nil];
    self.layer.transform=CATransform3DMakeScale(0.0, 0.0, 0.0);

}

#pragma mark animation delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([self.delegate respondsToSelector:@selector(removeImageSubUploaded:)])
        [self.delegate performSelector:@selector(removeImageSubUploaded:) withObject:self];
}

@end

@interface ImageUploaded()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
-(void)clickButtonEvent;
@end


@implementation ImageUploaded
@synthesize parentViewController;
- (id)initWithFrame:(CGRect)frame{
    UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"addbutton.png"];
    frame.size.height=img.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        imageViews=[[NSMutableArray alloc] initWithCapacity:2];
        left=20.0f;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        self.userInteractionEnabled=YES;
        uploadButton=[UIButton buttonWithType:UIButtonTypeCustom];
        uploadButton.frame=CGRectMake(left, 0.0f, img.size.width, img.size.height);
        [uploadButton setImage:img forState:UIControlStateNormal];
        [uploadButton addTarget:self action:@selector(clickButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:uploadButton];
    }
    return self;
}

-(void)dealloc{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;

    [imageViews release];
    [super dealloc];
}

-(void)showUpLoadButton:(BOOL)value{
    uploadButton.hidden=!value;
}

-(void)smallSize{
    CGRect rect=uploadButton.frame;
    if([Utils isIPad])
        rect.size=CGSizeMake(140.0f, 140.0f);
    else
        rect.size=CGSizeMake(70.0f, 70.0f);
    uploadButton.frame=rect;
    rect=self.frame;
    rect.size.height=uploadButton.frame.size.height;
    self.frame=rect;
}

-(void)clickButtonEvent{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:lang(@"cancel") destructiveButtonTitle:lang(@"camera") otherButtonTitles:lang(@"open_phone"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

-(void)addNewImage:(UIImage*)image{
    ImageSubUploaded* imgView=[[ImageSubUploaded alloc] initWithImage:image];
    imgView.frame=CGRectMake(left, 0.0f, uploadButton.frame.size.width, uploadButton.frame.size.height);
    imgView.delegate=self;
    [self addSubview:imgView];
    [imageViews addObject:imgView];
    [imgView release];
        
    left+=imgView.frame.size.width+10.0f;
    [self bringSubviewToFront:uploadButton];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
        CGRect rect=uploadButton.frame;
        rect.origin.x=left;
        uploadButton.frame=rect;
    } completion:^(BOOL finish){
    
    }];
    
    self.contentSize=CGSizeMake(left+uploadButton.frame.size.width+20.0f, self.frame.size.height);
}


-(NSArray*)images{
    NSMutableArray* array=[[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    for(ImageSubUploaded* uploaded in imageViews){
        [array addObject:uploaded.maxImage];
    }
    return array;
}

#pragma mark  actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==2)return;
    
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.videoQuality=UIImagePickerControllerQualityTypeHigh;
    picker.delegate = self;
    
    if(buttonIndex==1){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            
        }
    }
    else{        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;            
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
        }
    }
    AppDelegate* appDelegate=[AppDelegate appDelegate];
    
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        popover=nil;
        popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
            [picker.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f) inView:appDelegate.window permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        if(self.parentViewController!=nil)
            [self.parentViewController presentModalViewController:picker animated:YES];
        else
            [appDelegate.rootViewController presentModalViewController:picker animated:YES];
    }
    
}

#pragma mark  imagepicker delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        picker.delegate=nil;
        [picker dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    picker.delegate=nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        NSString *imageKey = @"UIImagePickerControllerOriginalImage";
        UIImage* image=nil;
        image=[info objectForKey:imageKey];
        if(image!=nil && picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
        }
        [self addNewImage:image];
        [pool release];
        
    }

    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        [picker dismissModalViewControllerAnimated:YES];
    }

    
}

#pragma mark  subuploaded delegate

-(void)removeImageSubUploaded:(ImageSubUploaded*)uploaded{
    [imageViews removeObject:uploaded];
    [uploaded removeFromSuperview];
    left=20.0f;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
        for(uploaded in imageViews){
            CGRect rect=uploaded.frame;
            rect.origin.x=left;
            uploaded.frame=rect;
            
            left+=uploaded.frame.size.width+10.0f;
        }
        
        CGRect rect=uploadButton.frame;
        rect.origin.x=left;
        uploadButton.frame=rect;

    } completion:^(BOOL finish){
        self.contentSize=CGSizeMake(left+uploadButton.frame.size.width+20.0f, self.frame.size.height);

    }];
}


@end
