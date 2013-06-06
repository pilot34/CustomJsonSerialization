//
//  Task.h
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 07.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject<NSCoding>

@property (nonatomic) NSInteger num;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) BOOL deleted;
@property (strong, nonatomic) NSData *sourceData;

@end
