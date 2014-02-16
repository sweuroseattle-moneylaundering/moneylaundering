
#import "UIColor+Utils.h"

@implementation UIColor (Utils)

- (UIColor *)colorWithBrightnessFactor:(CGFloat)factor
{
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
	return [UIColor colorWithRed:components[0] * factor 
						   green:components[1] * factor 
							blue:components[2] * factor 
						   alpha:components[3]];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:
												[NSCharacterSet whitespaceAndNewlineCharacterSet]] 
						 uppercaseString];
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) 
		cString = [cString substringFromIndex:2];
	
	// strip # if it appears
	if ([cString hasPrefix:@"#"]) 
		cString = [cString substringFromIndex:1];
	
	// String should be 6 characters
	if ([cString length] != 6) 
		return [UIColor blackColor];
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];

	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];	
}

+ (UIColor *)colorWithAlphaFromHexString:(NSString *)hexString {
    if(!hexString || hexString.length == 0) {
        return nil;
    }
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
