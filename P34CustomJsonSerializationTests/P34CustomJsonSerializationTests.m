//
//  CustomJsonSerializationTests.m
//  CustomJsonSerializationTests
//
//  Created by Gleb Tarasov on 06.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import "P34CustomJsonSerializationTests.h"
#import "P34JsonCoder.h"
#import "Lecture.h"
#import "Task.h"

@implementation P34CustomJsonSerializationTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSimple
{
    NSData *data = [P34JsonCoder dataWithJSONObject:@1];
    STAssertNotNil(data, @"data");
}

- (void)testStrings
{
    NSData *data;
    NSString *str;
    
    data = [P34JsonCoder dataWithJSONObject:@"str"];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(str, @"str", nil);
    
    
    data = [P34JsonCoder dataWithJSONObject:@""];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(str, @"", nil);
    
    data = [P34JsonCoder dataWithJSONObject:@"a\n\na\n\r\n"];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(str, @"a\n\na\n\r\n", nil);
    
    data = [P34JsonCoder dataWithJSONObject:nil];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertNil(str, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@"5"];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(str, @"5", nil);
    
    data = [P34JsonCoder dataWithJSONObject:@"5.0"];
    str = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(str, @"5.0", nil);
}

- (void)testNumbers
{
    NSData *data;
    NSNumber *num;
    
    data = [P34JsonCoder dataWithJSONObject:@0];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @0, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@999];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @999, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@0.1];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @0.1, nil);
    
    // double instead of float type, but I think it's OK
    data = [P34JsonCoder dataWithJSONObject:@0.1f];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @0.1, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@(-10231.1)];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @(-10231.1), nil);
    
    data = [P34JsonCoder dataWithJSONObject:@YES];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @YES, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@NO];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @NO, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@(YES)];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(num, @(YES), nil);
    
    data = [P34JsonCoder dataWithJSONObject:[NSDecimalNumber notANumber]];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertNil(num, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@(1./0.)];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertNil(num, nil);
    
    data = [P34JsonCoder dataWithJSONObject:@(-1/0.)];
    num = [P34JsonCoder JSONObjectWithData:data];
    STAssertNil(num, nil);
}

- (void)testCollections
{
    NSData *data;
    NSArray *arr;
    NSSet *set;
    NSDictionary *dict;
    
    NSArray *arr1 = @[ @"1", @"3", @YES, @0, @(-123123) ];
    NSSet *set1 = [NSSet setWithArray:arr1];
    NSDictionary *dict1 = @{ @"key1" : @"val1", @"123asdasd asd asda sda sdas \fdv ds\n`dad" : @"val2", @"1232" : NSNull.null, @"key2" : @NO };
    
    data = [P34JsonCoder dataWithJSONObject:arr1];
    arr = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(arr, arr1, nil);
    
    data = [P34JsonCoder dataWithJSONObject:set1];
    set = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(set, set1, nil);

    data = [P34JsonCoder dataWithJSONObject:dict1];
    dict = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(dict, dict1, nil);
}

- (void)testTask
{
    Task *task1 = [[Task alloc] init];
    task1.title = @"asd asdas a sfliusdgiudshg dg\n\r\n\r\td";
    task1.num = 10;
    task1.deleted = YES;

    Task *task;
    NSData *data;
    
    data = [P34JsonCoder dataWithJSONObject:task1];
    task = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(task, task1, nil);
}

- (void)testLecture
{
    Lecture *lect1 = [[Lecture alloc] init];
    Task *task1 = [[Task alloc] init];
    Task *task2 = [[Task alloc] init];
    
    task1.title = @"asd asdas d";
    task2.title = @"as dsazxc293 23";
    task1.num = 10;
    task2.num = -12312312;
    task1.deleted = NO;
    task2.deleted = YES;
    
    lect1.title = @"as dasdasd asddsjvnxcjvn123 12";
    lect1.tasks = @[ task1, task2, NSNull.null ];
    lect1.results = @{ @"result1" : @6, @"result2" : @10, @"result4" : task2, @"res2asdsad" : NSNull.null };
    lect1.secondDate = NSDate.date;
    
    Lecture *lect;
    NSData *data;
    
    data = [P34JsonCoder dataWithJSONObject:lect1];
    lect = [P34JsonCoder JSONObjectWithData:data];
    STAssertEqualObjects(lect.title, lect1.title, nil);
    STAssertEqualObjects(lect.tasks, lect1.tasks, nil);
    STAssertEqualObjects(lect.results, lect1.results, nil);
    STAssertEqualObjects(lect.date, lect1.date, nil);
    STAssertEqualsWithAccuracy(lect.secondDate.timeIntervalSince1970, lect1.secondDate.timeIntervalSince1970, 0.0001, nil);
}

@end
