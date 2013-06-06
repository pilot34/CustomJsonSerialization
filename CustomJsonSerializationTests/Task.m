//
//  Task.m
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 07.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import "Task.h"

@implementation Task

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.num = [aDecoder decodeIntegerForKey:@"num"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.deleted = [aDecoder decodeBoolForKey:@"deleted"];
        self.sourceData = [aDecoder decodeObjectForKey:@"sourceData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeBool:self.deleted forKey:@"deleted"];
    [aCoder encodeInteger:self.num forKey:@"num"];
    [aCoder encodeObject:self.sourceData forKey:@"sourceData"];
}

- (NSUInteger)hash
{
    return self.num ^ self.deleted ^ self.title.hash;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:Task.class])
        return NO;
    
    Task *other = object;
    return other.deleted == self.deleted && other.num == self.num && [other.title isEqualToString:self.title];
}

@end
