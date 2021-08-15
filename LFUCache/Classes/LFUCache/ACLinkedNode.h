//
//  ACLinkedNode.h
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import <Foundation/Foundation.h>

@interface ACLinkedNode : NSObject

/// 前驱
@property (weak, nonatomic) ACLinkedNode *prev;
/// 后驱
@property (weak, nonatomic) ACLinkedNode *next;
/// 节点的key
@property (strong, nonatomic) id key;
/// 节点的value
@property (strong, nonatomic) id value;
/// 节点被访问的频次
@property (nonatomic) NSUInteger frequency;

- (instancetype)initWithKey:(id)key value:(id)value frequency:(NSUInteger)frequency;

@end
