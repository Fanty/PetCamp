//
//  MySqlite.h
//  TextForSqlite
//
//  Created by 肖 昶 on 12-4-18.
//  Copyright (c) 2013年 广州绿蕃茄科技有限公司. All rights reserved.
//

#import "sqlite3.h"

@interface SqliteLib : NSObject{
    sqlite3* db;
    sqlite3_stmt  *dbResult;
}


-(void)open:(NSString*)dbName;
-(void)close;

-(NSString*)stringValue:(int)_column;
-(long long)longLongValue:(int)_column;
-(double)doubleValue:(int)_column;
-(BOOL)boolValue:(int)_column;

-(NSString*)stringValueByColumnName:(NSString*)columnname;

-(long long)longLongValueByColumnName:(NSString*)columnname;
-(double)doubleValueByColumnName:(NSString*)columnname;
-(BOOL)boolValueByColumnName:(NSString*)columnname;
-(NSString*)columnName:(int)_column;

-(BOOL)execute:(NSString*)query;
-(BOOL)query:(NSString*)query;
-(BOOL)next;
-(void)prepare:(NSString*)query;
-(void)bind:(NSString*)value index:(int)index;
-(void)bindInt:(int)value index:(int)index;
-(void)bindFloat:(float)value index:(int)index;

-(void)finalize;
@end
