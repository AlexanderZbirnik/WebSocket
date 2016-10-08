//
//  NSDate+Additions.h
//  WebSocketTest
//
//  Created by Alex Zbirnik on 05.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSString *) formattedDateString;
- (NSString *) formattedDateShortString;

+ (NSDate *) dateFromFormattedDateString: (NSString *) string;
+ (NSDate *) dateFromFormattedDateShortString: (NSString *)  string;

@end
