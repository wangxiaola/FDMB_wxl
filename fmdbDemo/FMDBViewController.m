//
//  FMDBViewController.m
//  fmdbDemo
//
//  Created by zhangxy on 13-7-15.
//  Copyright (c) 2013年 zhangxy. All rights reserved.
//

#import "FMDBViewController.h"


#define DBNAME    @"personinfo.sqlite"
#define ID        @"id"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"


@interface FMDBViewController ()

@end

@implementation FMDBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView{
    [super loadView];
    
    
    UIButton *openDBBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect=CGRectMake(60, 60, 200, 50);
    openDBBtn.frame=rect;
    [openDBBtn addTarget:self action:@selector(createTable) forControlEvents:UIControlEventTouchDown];
    [openDBBtn setTitle:@"createTable" forState:UIControlStateNormal];
    [self.view addSubview:openDBBtn];
    
    
    UIButton *insterBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect2=CGRectMake(60, 130, 200, 50);
    insterBtn.frame=rect2;
    [insterBtn addTarget:self action:@selector(insertData) forControlEvents:UIControlEventTouchDown];
    [insterBtn setTitle:@"insert" forState:UIControlStateNormal];
    [self.view addSubview:insterBtn];
    
    
    UIButton *updateBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect3=CGRectMake(60, 200, 200, 50);
    updateBtn.frame=rect3;
    [updateBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchDown];
    [updateBtn setTitle:@"update" forState:UIControlStateNormal];
    [self.view addSubview:updateBtn];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect4=CGRectMake(60, 270, 200, 50);
    deleteBtn.frame=rect4;
    [deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchDown];
    [deleteBtn setTitle:@"delete" forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect5=CGRectMake(60, 340, 200, 50);
    selectBtn.frame=rect5;
    [selectBtn addTarget:self action:@selector(selectData) forControlEvents:UIControlEventTouchDown];
    [selectBtn setTitle:@"select" forState:UIControlStateNormal];
    [self.view addSubview:selectBtn];
    
    
    UIButton *multithreadBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect6=CGRectMake(60, 410, 200, 50);
    multithreadBtn.frame=rect6;
    [multithreadBtn addTarget:self action:@selector(multithread) forControlEvents:UIControlEventTouchDown];
    [multithreadBtn setTitle:@"multithread" forState:UIControlStateNormal];
    [self.view addSubview:multithreadBtn];
    
    
}


- (void)createTable{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID,NAME,AGE,ADDRESS];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];

    }
}

-(void) insertData{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                               TABLENAME, NAME, AGE, ADDRESS, @"张三", @"13", @"济南"];
        BOOL res = [db executeUpdate:insertSql1];
        NSString *insertSql2 = [NSString stringWithFormat:
                                @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                                TABLENAME, NAME, AGE, ADDRESS, @"李四", @"12", @"济南"];
        BOOL res2 = [db executeUpdate:insertSql2];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];

    }
    
}

-(void) updateData{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",
                               TABLENAME,   AGE,  @"15" ,AGE,  @"13"];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];

    }
  
}

-(void) deleteData{
    
    if ([db open]) {
        
//        NSString *deleteSql = [NSString stringWithFormat:
//                               @"delete from %@ where %@ = '%@'",
//                               TABLENAME, NAME, @"张三"];
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME, NAME, @"张三"];
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [db close];

    }
    
}



-(void) selectData{

    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",TABLENAME];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:ID];
            NSString * name = [rs stringForColumn:NAME];
            NSString * age = [rs stringForColumn:AGE];
            NSString * address = [rs stringForColumn:ADDRESS];
            NSLog(@"id = %d, name = %@, age = %@  address = %@", Id, name, age, address);
        }
        [db close];
    }

}
-(void) multithread{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:database_path];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 10; ++i) {
            [queue inDatabase:^(FMDatabase *db2) {
                
                NSString *insertSql1= [NSString stringWithFormat:
                                       @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES (?, ?, ?)",
                                       TABLENAME, NAME, AGE, ADDRESS];
                
                NSString * name = [NSString stringWithFormat:@"jack %d", i];
                NSString * age = [NSString stringWithFormat:@"%d", 10+i];
                
                
                BOOL res = [db2 executeUpdate:insertSql1, name, age,@"济南"];
                if (!res) {
                    NSLog(@"error to inster data: %@", name);
                } else {
                    NSLog(@"succ to inster data: %@", name);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 10; ++i) {
            [queue inDatabase:^(FMDatabase *db2) {
                NSString *insertSql2= [NSString stringWithFormat:
                                       @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES (?, ?, ?)",
                                       TABLENAME, NAME, AGE, ADDRESS];
                
                NSString * name = [NSString stringWithFormat:@"lilei %d", i];
                NSString * age = [NSString stringWithFormat:@"%d", 10+i];
                
                BOOL res = [db2 executeUpdate:insertSql2, name, age,@"北京"];
                if (!res) {
                    NSLog(@"error to inster data: %@", name);
                } else {
                    NSLog(@"succ to inster data: %@", name);
                }
            }];
        }
    });

}

/**
 *  判断是否存在表
 *
 *  @param tableName 表名
 *
 *  @return
 */
- (BOOL)isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  获得表的数据条数
 *
 *  @param tableName 表名
 *
 *  @return 数量
 */
- (BOOL) getTableItemCount:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *rs = [db executeQuery:sqlstr];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        return count;
    }
    
    return 0;
}
/**
 *  删除表
 *
 *  @param tableName 表名
 *
 *  @return 是否删除
 */
- (BOOL) deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        return NO;
    }
    
    return YES;
}
/**
 *  清除表
 *
 *  @param tableName 表名
 *
 *  @return 是否清除成功
 */
- (BOOL) eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        return NO;
    }
    
    return YES;
}


- (void)viewDidLoad
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
