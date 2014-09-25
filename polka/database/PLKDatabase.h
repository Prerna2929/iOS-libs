//
//  PLKDatabase.h
//  Mazen
//
//  Created by Alvaro Talavera on 10/5/12.
//  Copyright (c) 2012 Alvaro Talavera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"

@interface PLKDatabase : NSObject

+ (void)setDatabaseName:(NSString *)name;

+ (void)createEditableCopyOfDatabaseIfNeeded;

+ (void)close;

+ (NSMutableArray *)executeSentence:(NSString *)sentence sentenceIsSelect:(BOOL )isSelect;

+ (void)insertInTable:(NSString *)table fromDictionary:(NSDictionary *)dictionary;

@end
