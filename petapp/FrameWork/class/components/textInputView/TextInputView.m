//
//  TextInputView.m
//  PetNews
//
//  Created by fanty on 13-9-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "TextInputView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"

@implementation TextInputView


-(id)initWithTitle:(NSString*)title field:(NSString*)field{
    self=[self init];
    if(self){
        self.userInteractionEnabled=YES;
        
        UIImage* img=[[GTGZThemeManager sharedInstance] imageByTheme:@"board.png"];
        img=[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f];
        [self setBackgroundImage:img forState:UIControlStateNormal];
        [self setBackgroundImage:img forState:UIControlStateHighlighted];

        titleLabel=[[UILabel alloc] init];
        titleLabel.text=title;
        titleLabel.numberOfLines=1;
        [titleLabel theme:@"textinput_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        textField=[[UITextField alloc] init];
        textField.text=field;
        if([Utils isIPad]){
            [textField setFont:[UIFont systemFontOfSize:30.0f]];
        }
        textField.borderStyle=UITextBorderStyleNone;
        [self addSubview:textField];
        [textField release];
    }
    return self;
}

-(id)initWithTitle:(NSString*)title value:(NSString*)value{
    self=[self init];
    if(self){
        self.userInteractionEnabled=YES;
        titleLabel=[[UILabel alloc] init];
        
        titleLabel.text=title;
        titleLabel.numberOfLines=1;
        [titleLabel theme:@"textinput_title"];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        valueLabel=[[UILabel alloc] init];
        valueLabel.text=value;
        valueLabel.numberOfLines=1;
        [valueLabel theme:@"textinput_value"];
        [self addSubview:valueLabel];
        [valueLabel release];
        
        arrowView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"down_arrow.png"]];
        [self addSubview:arrowView];
        [arrowView release];
    }
    return self;

}

-(NSString*)content{
    if(valueLabel!=nil)
        return  valueLabel.text;
    else
        return textField.text;
}

-(void)content:(NSString*)value{
    valueLabel.text=value;
    textField.text=value;
    [self layoutSubviews];
}

-(void)returnKeyType:(UIReturnKeyType)returnKeyType{
    textField.returnKeyType=returnKeyType;
}

-(void)keyboardType:(UIKeyboardType)keyboardType{
    textField.keyboardType=keyboardType;
}

-(void)secureTextEntry:(BOOL)secureText{

    textField.secureTextEntry = secureText;
}

-(void)showArrow{
    if(arrowView==nil){
        arrowView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"down_arrow.png"]];
        [self addSubview:arrowView];
        [arrowView release];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(textField!=nil){
        CGRect rect=titleLabel.frame;
        rect.origin.x=10.0f;
        rect.size.width=self.frame.size.width*0.4f;
        rect.size.height=self.frame.size.height;
        titleLabel.frame=rect;
        
        rect=textField.frame;
        
        rect.size.height=self.frame.size.height - 2;
        rect.origin.y=self.frame.size.height-rect.size.height+([Utils isIPad]?18.0f:8.0f);
        rect.origin.x=CGRectGetMaxX(titleLabel.frame);
        rect.size.width=self.frame.size.width-rect.origin.x;
        textField.frame=rect;
        
        if(arrowView!=nil){
            arrowView.hidden=([textField.text length]>0);
            CGRect rect=arrowView.frame;
            rect.origin.x=(self.frame.size.width-rect.size.width)*0.5f;
            rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
            arrowView.frame=rect;
        }
    }
    else{
        CGRect rect=arrowView.frame;
        rect.origin.x=self.frame.size.width-rect.size.width-10.0f;
        rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
        arrowView.frame=rect;

        rect=titleLabel.frame;
        rect.origin.x=10.0f;
        rect.size.width=CGRectGetMinX(arrowView.frame)-15.0f;
        rect.size.height=self.frame.size.height;
        titleLabel.frame=rect;
        
        valueLabel.frame=rect;
        titleLabel.hidden=([valueLabel.text length]>0);
        //valueLabel.hidden=([valueLabel.text length]<1);
    }

    if([textField.text length]>0)
        titleLabel.highlighted=YES;
    else
        titleLabel.highlighted=NO;
}

-(BOOL)becomeFirstResponder{
    if([textField canBecomeFirstResponder])
        [textField becomeFirstResponder];
    
    return YES;
}

-(BOOL)resignFirstResponder{
    if([textField isFirstResponder])
        [textField resignFirstResponder];
    return YES;
}

-(void)delegate:(id<UITextFieldDelegate>)delegate{
    textField.delegate=delegate;
}

-(void)updateTitleColor:(NSString*)value{
    if([value length]>0)
        titleLabel.highlighted=YES;
    else
        titleLabel.highlighted=NO;
}

-(void)textFieldDisabled{
    textField.enabled=NO;
}

@end
