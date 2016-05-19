//
//  FMDBViewController.h
//  fmdbDemo
//
//  Created by zhangxy on 13-7-15.
//  Copyright (c) 2013年 zhangxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface FMDBViewController : UIViewController
{
    FMDatabase *db;
    NSString *database_path;
 
}
@end
