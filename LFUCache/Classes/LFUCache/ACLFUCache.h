//
//  ACLFUCache.h
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import <Foundation/Foundation.h>
#import "ACDoubleLinkedList.h"
#import "ACLinkedNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACLFUCache : NSObject
/// 容量 缓存容量
@property (readonly) NSUInteger capacity;
/// 大小 缓存数量
@property (readonly) NSUInteger count;
/// 默认YES
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;
/// 默认YES
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;

@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(ACLFUCache *cache);

@property (nullable, copy) void(^didEnterBackgroundBlock)(ACLFUCache *cache);

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (BOOL)containsObjectForKey:(id<NSCopying>)key;

- (nullable id)objectForKey:(id<NSCopying>)key;

- (void)setObject:(nullable id)object forKey:(id<NSCopying>)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
