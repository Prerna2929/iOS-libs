//
//  PLKObjects.h
//  App
//
//  Created by Alvaro Talavera on 5/30/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLKObjects : NSObject

+ (BOOL)classDescendsFromClass:(Class)classA classB:(Class)classB;

+ (id)shared;

@end
