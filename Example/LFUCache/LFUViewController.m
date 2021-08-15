//
//  LFUViewController.m
//  LFUCache_Example
//
//  Created by caixiang on 2021/8/15.
//  Copyright © 2021 caixiang305621856. All rights reserved.
//

#import "LFUViewController.h"
#import "ACLFUCache.h"

@interface TestClass : NSObject
@property (copy, nonatomic) NSString *name;
@end

@implementation TestClass

@end


@interface LFUViewController ()
@property (strong, nonatomic) ACLFUCache *cache;
@property (strong, nonatomic) TestClass *cls;

@end

@implementation LFUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self statrCache];
}

- (void)statrCache {
    self.cache = [[ACLFUCache alloc] initWithCapacity:7];
    self.cache.didEnterBackgroundBlock = ^(ACLFUCache * _Nonnull cache) {
        NSLog(@"---------");
    };
    
    for (NSInteger i = 0; i < 7; i ++) {
        TestClass *cls = [[TestClass alloc] init];
        cls.name = [NSString stringWithFormat:@"%zd",i];
        [self.cache setObject:@(i) forKey:[NSString stringWithFormat:@"%zd",i]];
        if (i == 5) {
            _cls = cls;
        }
    }
    //淘汰0；
    
//    [self.cache setObject:@1 forKey:@"1"];
//    [self.cache setObject:@5 forKey:@"5"];
    //淘汰2
    
//    [self.cache setObject:@3 forKey:@"3"]; //2
//    [self.cache setObject:@3 forKey:@"3"]; //2
//    [self.cache setObject:@3 forKey:@"3"]; //2

//    [self.cache setObject:@4 forKey:@"4"]; //2
//    [self.cache setObject:@4 forKey:@"4"]; //2
//    [self.cache setObject:@4 forKey:@"4"]; //2

//    [self.cache setObject:@5 forKey:@"5"]; //2
//    [self.cache setObject:@5 forKey:@"5"]; //2
//    [self.cache setObject:@5 forKey:@"5"]; //2
    
//    [self.cache setObject:@1 forKey:@"1"];
//    [self.cache setObject:@1 forKey:@"1"];
//    [self.cache setObject:@1 forKey:@"1"];

//    [self.cache setObject:@10001 forKey:@"1----"];
    //淘汰3
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"---%@",[self.cache objectForKey:@"5"]);
//    NSLog(@"---%@",[self.cache objectForKey:@"6"]);
//    [self.cache removeAllObjects];
    
    NSLog(@"%@",[self.cache allValues]);
    if ([self.cache containsObjectForKey:@"5"]) {
        NSLog(@"---%@",[self.cache objectForKey:@"5"]);
    }
}

@end
