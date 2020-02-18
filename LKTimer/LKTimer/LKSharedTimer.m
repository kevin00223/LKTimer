//
//  LKSharedTimer.m
//  LKTimer
//
//  Created by 李凯 on 2020/2/18.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "LKSharedTimer.h"

// 存放timer的字典
static NSMutableDictionary *timers_;
// 互斥锁: 保证字典的线程安全
dispatch_semaphore_t semaphore_;

@implementation LKSharedTimer

// 初始化私有变量
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    
    // 创建队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    // Timer
    // 1. 创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 2. 设置时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
    interval * NSEC_PER_SEC, 0);
    
    // 对字典的操作进行加锁
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%ld", timers_.count];
    timers_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    // 3. timer回调
    dispatch_source_set_event_handler(timer, ^{
        // 执行任务
        task();
        // 不重复 就取消任务(通过key找timer)
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    // 4. 开启timer
    dispatch_resume(timer);
    
    return name;
}

+ (void)cancelTask:(NSString *)task {
    if (task.length == 0) return;
    
    // 对字典的操作进行加锁
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[task];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:task];
    }
    dispatch_semaphore_signal(semaphore_);
}


@end
