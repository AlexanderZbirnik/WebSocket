//
//  NSDate+Additions.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "NSDate+Additions.h"

static NSString * const NSDateFormatString      = @"dd.MM.yyyy hh:mm:ss.SSS";
static NSString * const NSDateFormatShortString = @"dd.MM.yyyy hh:mm";

@implementation NSDate (Additions)

- (NSString *) formattedDateString {
    
    NSDateFormatter *formatter =
    [NSDate formatterFromString:NSDateFormatString];
    
    return [formatter stringFromDate:self];
}

- (NSString *) formattedDateShortString {
    
    NSDateFormatter *formatter =
    [NSDate formatterFromString:NSDateFormatShortString];
    
    return [formatter stringFromDate:self];
}

+ (NSDate *) dateFromFormattedDateString: (NSString *) string {
    
    NSDateFormatter *formatter =
    [self formatterFromString:NSDateFormatString];
    
    return [formatter dateFromString:string];
}

+ (NSDate *) dateFromFormattedDateShortString: (NSString *)  string {
    
    NSDateFormatter *formatter =
    [self formatterFromString:NSDateFormatShortString];
    
    return [formatter dateFromString:string];
}

+ (NSDateFormatter *) formatterFromString: (NSString *) formatString {
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]  autorelease];
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    
    return formatter;
}

@end
