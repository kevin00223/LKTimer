//
//  LKSharedTimer.h
//  LKTimer
//
//  Created by 李凯 on 2020/2/18.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKSharedTimer : NSObject

// timer执行任务
+ (NSString *)execTask: (void(^)(void))task
                 start: (NSTimeInterval)start
              interval: (NSTimeInterval)interval
               repeats: (BOOL)repeats
                 async: (BOOL)async;

// 取消timer
+ (void)cancelTask: (NSString *)task;

@end

NS_ASSUME_NONNULL_END
