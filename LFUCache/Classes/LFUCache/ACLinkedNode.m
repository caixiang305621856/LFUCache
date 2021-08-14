//
//  ACLinkedNode.m
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import "ACLinkedNode.h"

@implementation ACLinkedNode

- (instancetype)initWithKey:(id)key value:(id)value frequency:(NSUInteger)frequency {
    if (self = [super init]) {
        _key = key;
        _value = value;
        _frequency = frequency;
    }
    return self;
}


@end
