//
//  PersonDynamicViewController.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class ImageDownloadedView;
@class MyPetNewsTableView;
@class AsyncTask;
@interface PersonDynamicViewController : NavContentViewController{

    MyPetNewsTableView* myPetNewsTableView;
    
    AsyncTask* task;
}

@end
