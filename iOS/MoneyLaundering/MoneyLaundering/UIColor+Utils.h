

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Utils)

- (UIColor *)colorWithBrightnessFactor:(CGFloat)factor;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithAlphaFromHexString:(NSString *)hexString;
@end
