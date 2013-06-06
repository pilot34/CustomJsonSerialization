CustomJsonSerialization
=======================

JSON serialization for Objective-C custom classes with NSCoding protocol


## Example

```objective-c
    Task *task = [[Task alloc] init];
    ...
    NSData *data = [P34JsonCoder dataWithJSONObject:task];
    ...
    Task *taskCopy = [P34JsonCoder JSONObjectWithData:data];
```

