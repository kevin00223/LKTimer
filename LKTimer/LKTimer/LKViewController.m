//
//  LKViewController.m
//  LKTimer
//
//  Created by 李凯 on 2020/2/18.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "LKViewController.h"
#import "LKSharedTimer.h"

@interface LKViewController ()

@property (nonatomic, copy) NSString *task;

@end

@implementation LKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 执行timer
    self.task = [LKSharedTimer execTask:^{
        NSLog(@"当前线程-%@", [NSThread currentThread]);
    } start:0 interval:1 repeats:YES async:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 取消timer
    [LKSharedTimer cancelTask:self.task];
}


@end
