//
//  Bookmark.m
//  Intuit
//
//  Created by Gleb Tarasov on 30.07.12.
//
//

#import "Bookmark.h"

@implementation Bookmark

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.comment = [coder decodeObjectForKey:@"comment"];
        self.paragraph = [coder decodeObjectForKey:@"paragraph"];
        self.timeInterval = [coder decodeObjectForKey:@"timeInterval"];
        self.courseId = [coder decodeObjectForKey:@"courseId"];
        self.videoNum = [coder decodeObjectForKey:@"videoNum"];
        self.lecture = [coder decodeObjectForKey:@"lecture"];
        self.currentFontSize = [coder decodeObjectForKey:@"currentFontSize"];
        self.currentWidth = [coder decodeObjectForKey:@"currentWidth"];
        self.currentHeight = [coder decodeObjectForKey:@"currentHeight"];
        self.currentPage = [coder decodeObjectForKey:@"currentPage"];
        self.creation = [coder decodeObjectForKey:@"creation"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.paragraph forKey:@"paragraph"];
    [aCoder encodeObject:self.timeInterval forKey:@"timeInterval"];
    [aCoder encodeObject:self.courseId forKey:@"courseId"];
    [aCoder encodeObject:self.videoNum forKey:@"videoNum"];
    [aCoder encodeObject:self.lecture forKey:@"lecture"];
    [aCoder encodeObject:self.currentFontSize forKey:@"currentFontSize"];
    [aCoder encodeObject:self.currentPage forKey:@"currentPage"];
    [aCoder encodeObject:self.currentWidth forKey:@"currentWidth"];
    [aCoder encodeObject:self.currentHeight forKey:@"currentHeight"];
    [aCoder encodeObject:self.creation forKey:@"creation"];
}

- (BOOL)equalsObject:(id)object toObject:(id)other
{
    return object == other || [object isEqual:other];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
        return YES;
    
    if (![object isKindOfClass:self.class])
        return NO;
    
    Bookmark *other = object;
    
    return ([self equalsObject:self.comment toObject:other.comment]
            && [self equalsObject:self.paragraph toObject:other.paragraph]
            && [self equalsObject:self.timeInterval toObject:other.timeInterval]
            && [self equalsObject:self.courseId toObject:other.courseId]
            && [self equalsObject:self.videoNum toObject:other.videoNum]
            && [self equalsObject:self.lecture toObject:other.lecture]
            && [self equalsObject:self.creation toObject:other.creation]);
    
}

- (NSUInteger)hash
{
    return (self.comment.hash
            ^ self.paragraph.hash
            ^ self.timeInterval.hash
            ^ self.courseId.hash
            ^ self.videoNum.hash
            ^ self.lecture.hash
            ^ self.creation.hash);
}

@end
