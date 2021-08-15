//
//  ACNSCache.h
//  CacheBenchmark
//
//  Created by caixiang on 2021/8/15.
//  Copyright © 2021 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACNSCache : NSCache

/// 内存警告触发回调
@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(ACNSCache *cache);
/// 进入后台回调
@property (nullable, copy) void(^didEnterBackgroundBlock)(ACNSCache *cache);

- (nullable id)objectForKey:(nonnull id)key;
- (void)setObject:(nullable id)object forKey:(nonnull id)key;
- (void)setObject:(nullable id)object forKey:(nonnull id)key cost:(NSUInteger)cost;
- (void)removeObjectForKey:(nonnull id)key;
- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
