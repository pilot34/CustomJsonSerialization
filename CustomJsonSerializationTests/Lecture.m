//
//  Lecture.m
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 07.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import "Lecture.h"

@implementation Lecture

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.title = [aDecoder decodeObject];
        self.tasks = [aDecoder decodeObject];
        self.results = [aDecoder decodeObject];
        self.timeInterval = [[aDecoder decodeObject] floatValue];
        self.date = [aDecoder decodeObject];
        self.secondDate = [aDecoder decodeObject];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title];
    [aCoder encodeObject:self.tasks];
    [aCoder encodeObject:self.results];
    [aCoder encodeObject:@(self.timeInterval)];
    [aCoder encodeObject:self.date];
    [aCoder encodeObject:self.secondDate];
}

@end
