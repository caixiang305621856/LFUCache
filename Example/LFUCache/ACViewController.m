//
//  ACViewController.m
//  LFUCache
//
//  Created by caixiang305621856 on 08/14/2021.
//  Copyright (c) 2021 caixiang305621856. All rights reserved.
//

#import "ACViewController.h"
#import "LFUViewController.h"
#import "ACNSCacheViewController.h"

@interface ACViewController ()

@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nscache:(id)sender {
    ACNSCacheViewController * l = [ACNSCacheViewController new];
    [self.navigationController pushViewController:l animated:YES];
}
- (IBAction)lfucache:(id)sender {
    LFUViewController * l = [LFUViewController new];
    [self.navigationController pushViewController:l animated:YES];
}

@end
