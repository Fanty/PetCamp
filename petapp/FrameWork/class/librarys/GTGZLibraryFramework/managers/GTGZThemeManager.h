//
//  GTGZThemeManager.h
//  GTGZLibrary
//
//  Created by fanty on 13-3-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

@interface GTGZTheme:NSObject

@property(nonatomic,retain) NSString* key;
@property(nonatomic,retain) UIColor* textColor;
@property(nonatomic,retain) UIColor* highlightColor;
@property(nonatomic,retain) UIColor* selectedColor;
@property(nonatomic,retain) UIColor* disabledColor;
@property(nonatomic,retain) UIColor* backgroundColor;
@property(nonatomic,assign) float fontSize;
@property(nonatomic,assign) BOOL  fontBold;
@property(nonatomic,retain) NSString* fontName;

-(UIFont*)font;

@end


@interface GTGZThemeManager : NSObject{
    NSMutableArray* themeList;
    
    NSMutableArray* themeImageList;
    
    NSString* themeKey;
    
    NSString* imageThemeKey;
}

@property(nonatomic,assign) BOOL supportIPad;

@property(nonatomic,retain) NSString* defaultFontName;

/*
 @return the shared instance
 */
+(GTGZThemeManager*)sharedInstance;

/*
 @return UIImage from image name   use [UIImage imageNamed:]
 */
-(UIImage*) imageByTheme:(NSString*)imageName;

/*
 @return UIImage from image name  usr [UIImage imageWithContentsOfFile:];
 */
-(UIImage*)imageResourceByTheme:(NSString*)imageName;

/*
 @open the theme xml  and category xml to parser
 */
-(void)openTheme:(NSString*)theme;

/*
 @open the theme xml and parser
 */
-(void)openImageTheme:(NSString*)key;


/*
 @check the theme is same
 */
-(BOOL)compareTheme:(NSString*)newTheme;

-(BOOL)compareImageTheme:(NSString*)newTheme;

/*
 @return theme object from key
 */
-(GTGZTheme*)get:(NSString*)key;


@end
