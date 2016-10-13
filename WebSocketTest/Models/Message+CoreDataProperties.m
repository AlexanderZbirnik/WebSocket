//
//  Message+CoreDataProperties.m
//  WebSocketTest
//
//  Created by Alex Zbirnik on 06.10.16.
//  Copyright © 2016 none. All rights reserved.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [[[NSFetchRequest alloc] initWithEntityName:@"Message"] autorelease];
}

@dynamic date;
@dynamic isSended;
@dynamic onOff;
@dynamic text;

@end
