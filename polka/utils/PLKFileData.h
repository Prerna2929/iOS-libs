
#import <Foundation/Foundation.h>

@interface PLKFileData : NSObject

+ (void)saveDataToCSV:(NSString *)filename
          withColumns:(NSArray *)columns
              andData:(NSArray *)data;

@end
