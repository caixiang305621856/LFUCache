//
//  ACLinkedNode.h
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import <Foundation/Foundation.h>

@interface ACLinkedNode : NSObject

@property (strong, nonatomic) ACLinkedNode *prev;
@property (strong, nonatomic) ACLinkedNode *next;
@property (strong, nonatomic) id key;
@property (strong, nonatomic) id value;
@property (nonatomic) NSUInteger frequency;

- (instancetype)initWithKey:(id)key value:(id)value frequency:(NSUInteger)frequency;

@end
