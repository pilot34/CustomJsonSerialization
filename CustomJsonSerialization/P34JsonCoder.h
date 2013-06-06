//
//  P34JsonCoder.h
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 06.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P34JsonCoder : NSCoder

+ (NSData *)dataWithJSONObject:(id)obj;
+ (id)JSONObjectWithData:(NSData *)data;

@end
