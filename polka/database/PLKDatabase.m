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
            NSLog(@">> SQLite open success.");
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


+ (NSMutableArray *)executeSentence:(NSString *)sentence sentenceIsSelect:(BOOL )isSelect
{
    
    // Variables para realizar la consulta
    sqlite3_stmt *resultado;
    const char* siguiente;
    NSMutableArray *res = nil;
    
    @synchronized(self) {
        
        [self open];
        
        if (isSelect){
            
            // Ejecuta la consulta
            if ( sqlite3_prepare_v2(db,[sentence UTF8String],(uint)[sentence length],&resultado,&siguiente) == SQLITE_OK ){                
                res = [NSMutableArray array];
                // Recorre el resultado
                
                while (sqlite3_step(resultado)==SQLITE_ROW) {
                    
                    int cols = sqlite3_column_count(resultado);
                    
                    NSMutableArray *rar = [NSMutableArray arrayWithCapacity:cols];
                    for(int i=0; i<cols; i++) {
                        int colType = sqlite3_column_type(resultado, i);
                        id value;
                        
                        if (colType == SQLITE_TEXT) {
                            value = [NSString stringWithUTF8String: (char *)sqlite3_column_text(resultado, i)];
                        } else if (colType == SQLITE_INTEGER) {
                            int col = sqlite3_column_int(resultado, i);
                            value = [NSNumber numberWithInt:col];
                        } else if (colType == SQLITE_FLOAT) {
                            double col = sqlite3_column_double(resultado, i);
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
                
                sqlite3_finalize(resultado);
            }
        }
        else {
            // Ejecuta la consulta
            if ( sqlite3_prepare_v2(db,[sentence UTF8String],(uint)[sentence length],&resultado,&siguiente) == SQLITE_OK ) {
                sqlite3_step(resultado);
                sqlite3_finalize(resultado);
            }
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
    [self executeSentence:sql sentenceIsSelect:NO];
}




@end
