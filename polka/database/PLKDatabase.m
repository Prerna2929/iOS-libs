//
//  PLKDatabase.m
//
//  Created by Alvaro Talavera on 2/25/14.
//  Copyright (c) 2014 Alvaro Talavera. All rights reserved.
//

#import "PLKDatabase.h"

#ifndef _SQLPATH
#define _SQLPATH @"db.sqlite"
#endif

static NSString *PLKDatabaseName = _SQLPATH;

static sqlite3 *db;
static BOOL opened = NO;

@implementation PLKDatabase

+ (void)setDatabaseName:(NSString *)name
{
    PLKDatabaseName = name;
}

+ (void)createEditableCopyOfDatabaseIfNeeded
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *writableDBPath = [self getDBPath];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSLog(@"PLKDatabase path: %@", writableDBPath);
    
    if (success) {
        [self open];
    }
    else {
        // Crea el archivo en el dispositivo
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PLKDatabaseName];
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
        [self open];
    }
}

+ (void)open
{
    if(!opened) {
        NSString *writableDBPath = [self getDBPath];
        if (sqlite3_open([writableDBPath UTF8String], &db) == SQLITE_OK) {
            opened = YES;
        }
        else {
            NSLog(@">> SQLite can´t open database");
            opened = NO;
        }
    }
}

+ (void)close
{
    if(opened) {
        opened = NO;
        sqlite3_close(db);
    }
}


+ (BOOL)executeQuery:(NSString *)sentence
{
    // Variables para realizar la consulta
    sqlite3_stmt *result;
    const char* next;
    int rc;
    
    @synchronized(self) {
        
        [self open];
        
        // Ejecuta la consulta
        if ( sqlite3_prepare_v2(db, [sentence UTF8String], (uint)[sentence length], &result, &next) == SQLITE_OK ) {
            rc = sqlite3_step(result);
            sqlite3_finalize(result);
        }
    }
    return (rc == SQLITE_DONE || rc == SQLITE_OK);
}

+ (NSMutableArray *)executeSentence:(NSString *)sentence
{
    sqlite3_stmt *result;
    const char* next;
    NSMutableArray *res = nil;
    
    @synchronized(self) {
        [self open];
        if ( sqlite3_prepare_v2(db, [sentence UTF8String], (uint)[sentence length], &result, &next) == SQLITE_OK ){
            res = [NSMutableArray array];
            
            while (sqlite3_step(result)==SQLITE_ROW) {
                    
                int cols = sqlite3_column_count(result);
                    
                NSMutableArray *rar = [NSMutableArray arrayWithCapacity:cols];
                for (int i = 0; i < cols; i++) {
                    int colType = sqlite3_column_type(result, i);
                    id value;
                    
                    if (colType == SQLITE_TEXT) {
                        value = [NSString stringWithUTF8String: (char *)sqlite3_column_text(result, i)];
                    } else if (colType == SQLITE_INTEGER) {
                        int col = sqlite3_column_int(result, i);
                        value = [NSNumber numberWithInt:col];
                    } else if (colType == SQLITE_FLOAT) {
                        double col = sqlite3_column_double(result, i);
                        value = [NSNumber numberWithDouble:col];
                    } else if (colType == SQLITE_NULL) {
                        value = @"";
                    } else {
                        value = @"";
                        NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                    }
                    [rar addObject:value];
                }
                [res addObject:rar];
            }
            sqlite3_finalize(result);
        } else {
            NSLog(@"SQLLite query error: %s", sqlite3_errmsg(db));
        }
    }
    return res;
}


+ (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:PLKDatabaseName];
}

+ (void)insertInTable:(NSString *)table fromDictionary:(NSDictionary *)dictionary
{
    NSString *keys  = [dictionary.allKeys componentsJoinedByString:@","];
    
    NSMutableArray *values_arr = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    for (NSString *val in dictionary.allValues) {
        [values_arr addObject:[NSString stringWithFormat:@"\"%@\"", val]];
    }
    
    NSString *values = [values_arr componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", table, keys, values];
    [self executeQuery:sql];
}




@end
