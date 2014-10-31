//
//  PLKImage.h
//  Tex
//
//  Created by Alvaro Talavera on 10/2/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLKImage : NSObject

+ (NSString *)saveImageToDisk:(UIImage *)image
                     withName:(NSString *)name
                       folder:(NSString *)folder;


+ (UIImage *)imageWithImage:(UIImage *)image
           scaledToMaxWidth:(CGFloat)width
                  maxHeight:(CGFloat)height;

+ (UIImage *)imageScalingAndCropping:(UIImage *)image
                                size:(CGSize)targetSize;


+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)size;

+ (NSString *)getImageJPGThumbBase64EncodedWithImage:(UIImage *)image;

+ (NSString *)getImageJPGThumbBase64EncodedWithFilePath:(NSString *)filePath;



@end
