//
//  ACLFUCache.h
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface ACLFUCache : NSObject

/// 容量限制 默认是NSUIntegerMax
@property NSUInteger countLimit;
/// 已缓存数量
@property (readonly) NSUInteger count;
/// 默认YES
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;
/// 默认YES
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;
/// 内存警告触发回调
@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(ACLFUCache *cache);
/// 进入后台触发回调
@property (nullable, copy) void(^didEnterBackgroundBlock)(ACLFUCache *cache);

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (BOOL)containsObjectForKey:(id)key;
- (nullable id)objectForKey:(id)key;
- (void)setObject:(nullable id)object forKey:(id)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

- (NSArray *)allkeys;
- (NSArray *)allValues;

@end

NS_ASSUME_NONNULL_END
