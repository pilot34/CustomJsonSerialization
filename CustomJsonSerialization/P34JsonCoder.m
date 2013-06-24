//
//  P34JsonCoder.m
//  CustomJsonSerialization
//
//  Created by Gleb Tarasov on 06.06.13.
//  Copyright (c) 2013 Gleb Tarasov. All rights reserved.
//

#import "P34JsonCoder.h"

#define OBJECT_PREFIX @"obj:"
#define ROOT_OBJECT_KEY @"root"

@interface P34JsonCoder()

@property (strong, nonatomic) NSMutableArray *currentObjectStack;
@property (strong, nonatomic) NSMutableArray *currentObjectValuesWithoutKeysStack;
@property (strong, nonatomic) NSMutableArray *sourceDictionaryStack;

@end

@implementation P34JsonCoder

- (BOOL)isPrimitiveObject:(id)object
{
    return (!object
            || object == NSNull.null
            || [object isKindOfClass:NSString.class]
            || [object isKindOfClass:NSNumber.class]);
}

- (NSString *)classNameForObject:(NSObject *)obj
{
    if ([obj isKindOfClass:NSDate.class])
        return NSStringFromClass(NSDate.class);
    else if ([obj isKindOfClass:NSArray.class])
        return NSStringFromClass(NSArray.class);
    else if ([obj isKindOfClass:NSSet.class])
        return NSStringFromClass(NSSet.class);
    else if ([obj isKindOfClass:NSDictionary.class])
        return NSStringFromClass(NSDictionary.class);
    else
        return NSStringFromClass(obj.class);
}

- (NSString *)keyForObject:(NSObject *)obj
{
   return [NSString stringWithFormat:@"%@%@", OBJECT_PREFIX, [self classNameForObject:obj]];
}

- (NSDictionary *)resultDictionary
{
    id result = self.currentObjectValuesWithoutKeysStack.lastObject;
    NSAssert([result isKindOfClass:NSArray.class], @"[result isKindOfClass:NSArray.class]");
    NSArray *arr = result;
    NSAssert(arr.count == 1, @"arr.count == 1");
    return @{ ROOT_OBJECT_KEY : arr };
}

+ (NSData *)dataWithJSONObject:(id)obj
{
    if (!obj)
        return nil;
    
    P34JsonCoder *coder = [[P34JsonCoder alloc] init];
    [coder encodeObject:obj];
    
    id result = coder.resultDictionary;
    
    return [NSJSONSerialization dataWithJSONObject:result
                                           options:0
                                             error:nil];
}

+ (id)JSONObjectWithData:(NSData *)data
{
    if (!data)
        return nil;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    
    if (!dict)
        return nil;
    
    if (!dict[ROOT_OBJECT_KEY])
        return nil;
    
    P34JsonCoder *coder = [[P34JsonCoder alloc] init];
    [coder.sourceDictionaryStack addObject:dict[ROOT_OBJECT_KEY]];
    return [coder decodeObject];
}

- (void)encodeDataObject:(NSData *)data
{
    [self encodeObject:data];
}

- (NSInteger)versionForClassName:(NSString *)className
{
    return 0;
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentObjectStack = [NSMutableArray array];
        self.currentObjectValuesWithoutKeysStack = [NSMutableArray array];
        [self.currentObjectValuesWithoutKeysStack addObject:[NSMutableArray array]];
        self.sourceDictionaryStack = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Encoding

- (id)encodeCustomObject:(id)object
{
    [self.currentObjectStack addObject:[NSMutableDictionary dictionary]];
    [self.currentObjectValuesWithoutKeysStack addObject:[NSMutableArray array]];
    
    [object encodeWithCoder:self];
    id encoded = [self.currentObjectStack lastObject];
    NSMutableArray *valuesWithoutKeys = self.currentObjectValuesWithoutKeysStack.lastObject;
    if (valuesWithoutKeys.count > 0)
    {
        NSDictionary *dict = encoded;
        if (dict.allKeys.count > 0)
        {
            @throw [NSException exceptionWithName:@"Error"
                                           reason:@"You can use either NSCoding with keys, or without keys. Not simultaniously!"
                                         userInfo:nil];
        }
        
        encoded = valuesWithoutKeys;
    }
    
    
    [self.currentObjectValuesWithoutKeysStack removeLastObject];
    [self.currentObjectStack removeLastObject];
    
    return @{ [self keyForObject:object] : encoded };
}

- (NSDictionary *)encodeArray:(NSArray *)array
{
    NSMutableArray *vals = [NSMutableArray array];
    
    for (id obj in array)
    {
        id encoded = [self encodeCurrentObject:obj];
        if (encoded)
            [vals addObject:encoded];
    }
    
    return @{ [self keyForObject:array] : vals };
}

- (NSDictionary *)encodeDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *vals = [NSMutableDictionary dictionary];
    
    for (id key in dict)
    {
        if (![key isKindOfClass:NSString.class])
        {
            @throw [NSException exceptionWithName:@"Error"
                                           reason:@"JSON supports only string keys in dictionaries"
                                         userInfo:nil];
            
        }
        id encoded = [self encodeCurrentObject:dict[key]];
        vals[key] = encoded;
    }
    
    return @{ [self keyForObject:dict] : vals };
}

- (NSDictionary *)encodeSet:(NSSet *)set
{
    NSMutableArray *vals = [NSMutableArray array];
    
    for (id obj in set)
    {
        id encoded = [self encodeCurrentObject:obj];
        if (encoded)
            [vals addObject:encoded];
    }
    
    return @{ [self keyForObject:set] : vals };
}

- (NSDictionary *)encodeDate:(NSDate *)date
{
    return @{ [self keyForObject:date] : @([date timeIntervalSince1970]) };
}

- (id)encodeCurrentObject:(id)object 
{
    if (!object || object == NSNull.null)
    {
        return NSNull.null;
    }
    else if ([self isPrimitiveObject:object])
    {
        return object;
    }
    else if ([object isKindOfClass:NSDate.class])
    {
        return [self encodeDate:object];
    }
    else if ([object isKindOfClass:NSArray.class])
    {
        return [self encodeArray:object];
    }
    else if ([object isKindOfClass:NSSet.class])
    {
        return [self encodeSet:object];
    }
    else if ([object isKindOfClass:NSDictionary.class])
    {
        return [self encodeDictionary:object];
    }
    else
    {
        return [self encodeCustomObject:object];
    }
}

- (void)encodeObject:(id)object
{
    id encoded = [self encodeCurrentObject:object];
    NSMutableArray *arr = self.currentObjectValuesWithoutKeysStack.lastObject;
    if (encoded)
        [arr addObject:encoded];
}

- (void)encodeBytes:(const void *)byteaddr length:(NSUInteger)length
{
    NSString *str = [NSString stringWithCharacters:byteaddr length:length];
    [self encodeString:str];
}

- (void)encodeString:(NSString *)value
{
    [self setObject:value forKey:nil];
}

- (void)encodeBool:(BOOL)value
{
    [self setObject:[NSNumber numberWithBool:value] forKey:nil];
}

- (void)encodeDouble:(double)value
{
    [self setObject:[NSNumber numberWithDouble:value] forKey:nil];
}

- (void)encodeFloat:(float)value
{
    [self setObject:[NSNumber numberWithFloat:value] forKey:nil];
}

- (void)encodeInt:(int)value
{
    [self setObject:[NSNumber numberWithInt:value] forKey:nil];
}

- (void)encodeInt64:(long)value
{
    [self setObject:[NSNumber numberWithLong:value] forKey:nil];
}

- (void)encodeObject:(id)object forKey:(NSString *)key
{
    id encoded = [self encodeCurrentObject:object];
    [self setObject:encoded forKey:key];
}

- (void)encodeBytes:(const void *)byteaddr length:(NSUInteger)length forKey:(NSString *)key
{
    NSString *str = [NSString stringWithCharacters:byteaddr length:length];
    [self encodeString:str forKey:key];
}

- (void)encodeString:(NSString *)value forKey:(NSString *)key
{
    [self setObject:value forKey:key];
}

- (void)encodeBool:(BOOL)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)encodeDouble:(double)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)encodeFloat:(float)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)encodeInt:(int)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)encodeInt32:(int32_t)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)encodeInt64:(long)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithLong:value] forKey:key];
}

- (void)setObject:(NSObject *)object forKey:(NSString *)key
{
    if (key)
    {
        id current = self.currentObjectStack.lastObject;
        [current setObject:object forKey:key];
    }
    else
    {
        NSMutableArray *arr = self.currentObjectValuesWithoutKeysStack.lastObject;
        if (object)
            [arr addObject:object];
    }
}

#pragma - Decoding

- (id)decodeCurrentObject:(id)value
{
    if (value == NSNull.null || !value)
    {
        return nil;
    }
    else if ([self isPrimitiveObject:value])
    {
        return value;
    }
    else if ([value isKindOfClass:NSDictionary.class])
    {
        return [self decodeCustomObject:value];
    }
    else
    {
        NSString *error = [NSString stringWithFormat:@"Wrong object %@ of class %@ in json", value, [value class]];
        @throw [NSException exceptionWithName:@"Error" reason:error userInfo:nil];
    }
}

- (id)decodeCustomObject:(NSDictionary *)dict
{
    if (dict.allKeys.count != 1)
        return nil;
    
    NSString *key = dict.allKeys.lastObject;
    NSRange range = [key rangeOfString:OBJECT_PREFIX];
    if (range.location != 0)
        return nil;
    NSString *clsName = [key substringFromIndex:range.length];
    Class cls = NSClassFromString(clsName);
    if (!cls)
    {
        NSString *error = [NSString stringWithFormat:@"No class with name %@", clsName];
        @throw [NSException exceptionWithName:@"Error" reason:error userInfo:nil];
    }
    
    if (cls == NSDate.class)
    {
        return [self decodeDate:dict[key]];
    }
    else if (cls == NSArray.class)
    {
        return [self decodeArray:dict[key]];
    }
    else if (cls == NSSet.class)
    {
        return [self decodeSet:dict[key]];
    }
    else if (cls == NSDictionary.class)
    {
        return [self decodeSimpleDictionary:dict[key]];
    }
    else
    {
        if (dict[key])
            [self.sourceDictionaryStack addObject:dict[key]];
        
        id obj = [cls alloc];
        if (obj)
            [self.currentObjectStack addObject:obj];
        
        if (![obj conformsToProtocol:@protocol(NSCoding)])
        {
            NSString *error = [NSString stringWithFormat:@"Class %@ doesn't conform protocol NSCoding", cls];
            @throw [NSException exceptionWithName:@"Error" reason:error userInfo:nil];
        }
        
        obj = [obj initWithCoder:self];
        
        [self.currentObjectStack removeLastObject];
        [self.sourceDictionaryStack removeLastObject];
        return obj;
    }
}

- (id)decodeDate:(id)num
{
    if (num == NSNull.null)
        return nil;
    
    return [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
}

- (id)decodeArray:(NSArray *)arr
{
    NSMutableArray *res = [NSMutableArray array];
    for (id obj in arr)
    {
        id decoded = [self decodeCurrentObject:obj];
        if (!decoded)
            decoded = NSNull.null;
        [res addObject:decoded];
    }
    return res;
}

- (id)decodeSet:(NSSet *)set
{
    NSMutableSet *res = [NSMutableSet set];
    for (id obj in set)
    {
        id decoded = [self decodeCurrentObject:obj];
        if (!decoded)
            decoded = NSNull.null;
        [res addObject:decoded];
    }
    return res;
}

- (id)decodeSimpleDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    for (id key in dict)
    {
        id decoded = [self decodeCurrentObject:dict[key]];
        if (!decoded)
            decoded = NSNull.null;
        [res setObject:decoded forKey:key];
    }
    return res;
}

- (id)decodeObject
{
    NSAssert(self.sourceDictionaryStack.count > 0, @"self.sourceDictionaryStack.count > 0");
    
    id object = self.sourceDictionaryStack.lastObject;
    if ([self isPrimitiveObject:object])
    {
        return object;
    }
    
    NSArray *arr = self.sourceDictionaryStack.lastObject;
    if (![arr isKindOfClass:NSArray.class])
    {
        @throw [NSException exceptionWithName:@"Error"
                                       reason:@"Not an array in json object encoded without keys."
                                     userInfo:nil];
    }
    
    if (arr.count == 0)
    {
        @throw [NSException exceptionWithName:@"Error"
                                       reason:@"An array for json object encoded without keys doesn't contain enough elements"
                                     userInfo:nil];
    }
    
    [self.sourceDictionaryStack removeLastObject];
    id sourceObject = arr[0];
    id decodedObject = [self decodeCurrentObject:sourceObject];
    NSMutableArray *copy = arr.mutableCopy;
    [copy removeObjectAtIndex:0];
    if (copy)
        [self.sourceDictionaryStack addObject:copy];
    
    return decodedObject;
}

- (NSDictionary *)dictionaryForDecoding
{
    NSAssert(self.sourceDictionaryStack.count > 0, @"self.sourceDictionaryStack.count > 0");
    
    NSDictionary *dict = self.sourceDictionaryStack.lastObject;
    if (![dict isKindOfClass:NSDictionary.class])
    {
        @throw [NSException exceptionWithName:@"Error"
                                       reason:@"Not a dictionary in json object encoded with keys."
                                     userInfo:nil];
    }
    
    return dict;
}

- (id)objectFromDictionaryForKey:(NSString *)key
{
    NSDictionary *dict = [self dictionaryForDecoding];
    
    id obj = dict[key];
    return obj;
}

- (id)decodeObjectForKey:(NSString *)key
{
    NSDictionary *dict = [self dictionaryForDecoding];
    
    id sourceObject = dict[key];
    if (!sourceObject)
        return NSNull.null;
    id decodedObject = [self decodeCurrentObject:sourceObject];
    return decodedObject;
}

- (BOOL)decodeBoolForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj boolValue];
}

- (int)decodeIntForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj intValue];
}

- (int32_t)decodeInt32ForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj intValue];
}

- (int64_t)decodeInt64ForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj longValue];
}

- (NSInteger)decodeIntegerForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj integerValue];
}

- (double)decodeDoubleForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj doubleValue];
}

- (float)decodeFloatForKey:(NSString *)key
{
    id obj = [self objectFromDictionaryForKey:key];
    return [obj floatValue];
}

- (NSData *)decodeDataObject
{
    return [self decodeObject];
}

@end
