
#import "PLKFileData.h"

@implementation PLKFileData

+ (void)saveDataToCSV:(NSString *)filename
          withColumns:(NSArray *)columns
              andData:(NSArray *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@.csv", documentsDirectory, filename];
    
    NSMutableString *string = [[NSMutableString alloc] initWithContentsOfFile:filepath
                                                                     encoding:NSStringEncodingConversionAllowLossy
                                                                        error:nil];
    if (!string) {
        string = [[NSMutableString alloc] initWithFormat:@"%@\r\n", [columns componentsJoinedByString:@","]];
    }
    
    if([[data objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        for (NSArray *row in data) {
            [string appendFormat:@"%@\r\n", [row componentsJoinedByString:@","]];
        }
    }
    else {
        [string appendFormat:@"%@\r\n", [data componentsJoinedByString:@","]];
    }
    
    [string writeToFile:filepath
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];
}

@end
