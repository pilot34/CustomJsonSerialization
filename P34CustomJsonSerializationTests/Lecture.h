//
//  Lecture.h
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 07.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lecture : NSObject<NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *tasks;
@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *secondDate;
@property (nonatomic) NSTimeInterval timeInterval;

@end
