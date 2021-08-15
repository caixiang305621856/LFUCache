//
//  CACache.m
//  Cache
//
//  Created by caixiang on 2021/8/14.
//

#import "ACNSCache.h"
#import <UIKit/UIKit.h>
#import <os/lock.h>

#define AC_LOCK_DECLARE(lock) os_unfair_lock lock
#define AC_LOCK_INIT(lock) lock = OS_UNFAIR_LOCK_INIT
#define AC_LOCK(lock) os_unfair_lock_lock(&lock)
#define AC_UNLOCK(lock) os_unfair_lock_unlock(&lock)

@interface ACNSCache (){
    AC_LOCK_DECLARE(_weakCacheLock);
}
@property (nonatomic, strong, nonnull) NSMapTable *weakCache; // strong-weak cache
@end

@implementation ACNSCache

- (instancetype)init {
    self = [super init];
    if (self) {
        AC_LOCK_INIT(_weakCacheLock);
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.weakCache = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)setObject:(id)obj forKey:(id)key cost:(NSUInteger)g {
    [super setObject:obj forKey:key cost:g];
    if (key && obj) {
        AC_LOCK(_weakCacheLock);
        [self.weakCache setObject:obj forKey:key];
        AC_UNLOCK(_weakCacheLock);
    }
}

- (id)objectForKey:(id)key {
    id obj = [super objectForKey:key];
    if (key && !obj) {
        AC_LOCK(_weakCacheLock);
        obj = [self.weakCache objectForKey:key];
        AC_UNLOCK(_weakCacheLock);
        if (obj) {
            [super setObject:obj forKey:key cost:0];
        }
    }
    return obj;
}

- (void)removeObjectForKey:(id)key {
    [super removeObjectForKey:key];
    if (key) {
        AC_LOCK(_weakCacheLock);
        [self.weakCache removeObjectForKey:key];
        AC_UNLOCK(_weakCacheLock);
    }
}

- (void)removeAllObjects {
    [super removeAllObjects];
    AC_LOCK(_weakCacheLock);
    [self.weakCache removeAllObjects];
    AC_UNLOCK(_weakCacheLock);
}

- (void)_appDidReceiveMemoryWarningNotification {
    if (self.didReceiveMemoryWarningBlock) {
        self.didReceiveMemoryWarningBlock(self);
    }
    [super removeAllObjects];
}

- (void)_appDidEnterBackgroundNotification {
    if (self.didEnterBackgroundBlock) {
        self.didEnterBackgroundBlock(self);
    }
    [super removeAllObjects];
}

@end
