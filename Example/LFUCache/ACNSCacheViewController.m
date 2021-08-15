//
//  ACNSCacheViewController.m
//  LFUCache_Example
//
//  Created by caixiang on 2021/8/15.
//  Copyright © 2021 caixiang305621856. All rights reserved.
//

#import "ACNSCacheViewController.h"
#import "ACNSCache.h"

@interface ACNSCacheViewController ()<NSCacheDelegate>

@property (strong, nonatomic) ACNSCache *cache;

@end

@implementation ACNSCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self beginCache];
}

- (void)beginCache {
    for (int i = 0; i<20; i++) {
        NSString *obj = [NSString stringWithFormat:@"object--%d",i];
        [self.cache setObject:obj forKey:@(i) cost:0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (int i = 0; i < 10; i ++) {
        NSString *s =   [self.cache objectForKey:@(i)];
        NSLog(@"%@ objectForKey ",s);
    }
}

- (ACNSCache *)cache {
    if (!_cache) {
        _cache = [ACNSCache new];
        _cache.totalCostLimit = 8000;
        _cache.delegate = self;
        _cache.didEnterBackgroundBlock = ^(ACNSCache * _Nonnull cache) {
            for (int i = 0; i < 10; i ++) {
                NSString *s =   [cache objectForKey:@(i)];
                NSLog(@"%@ objectForKey ",s);
            }
        };
    }
    return _cache;
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    //evict : 驱逐
    NSLog(@"%@", [NSString stringWithFormat:@"%@ will be evict",obj]);
}

@end
