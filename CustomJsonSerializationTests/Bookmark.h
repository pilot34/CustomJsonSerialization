//
//  Bookmark.h
//  Intuit
//
//  Created by Gleb Tarasov on 30.07.12.
//
//

#import <Foundation/Foundation.h>
#import "Lecture.h"

@interface Bookmark : NSObject<NSCoding>

@property(strong, nonatomic) NSString *comment;
@property(strong, nonatomic) NSNumber *paragraph;
@property(strong, nonatomic) NSNumber *timeInterval;
@property(strong, nonatomic) NSNumber *courseId;
@property(strong, nonatomic) NSNumber *videoNum;
@property(strong, nonatomic) Lecture *lecture;
@property(strong, nonatomic) NSDate *creation;
@property(strong, nonatomic) NSNumber *currentFontSize;
@property(strong, nonatomic) NSNumber *currentPage;
@property(strong, nonatomic) NSNumber *currentWidth;
@property(strong, nonatomic) NSNumber *currentHeight;

@end
