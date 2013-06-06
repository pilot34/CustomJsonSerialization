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

@end
