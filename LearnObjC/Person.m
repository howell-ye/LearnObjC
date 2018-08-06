//
//  Person.m
//  LearnObjC
//
//  Created by yehowell on 2018/3/22.
//  Copyright © 2018年 howell. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person
+ (void)printStatic{
    
}
- (void)print{
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %p", [self class]);
    const char *name = object_getClassName(self);
    
    Class metaClass = objc_getMetaClass(name);
    NSLog(@"MetaClass is %p",metaClass);
    Class currentClass = [self class];
    
    NSString *str = [NSString stringWithFormat:@"sldda:%@",@"sakdjd"];
    static NSInteger num = 21334;
    NSLog(@"string:%p",str);
//    NSLog(@"int:%p",num);
    
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        unsigned int countMethod = 0;
        NSLog(@"---------------**%d start**-----------------------",i);
        Method * methods = class_copyMethodList(currentClass, &countMethod);
        [self printMethod:countMethod methods:methods ];
        NSLog(@"---------------**%d end**-----------------------",i);
        currentClass = object_getClass(currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}
- (void)printMethod:(int)count methods:(Method *) methods{
    for (int j = 0; j < count; j++) {
        Method method = methods[j];
        SEL methodSEL = method_getName(method);
        const char * selName = sel_getName(methodSEL);
        if (methodSEL) {
            NSLog(@"sel------%s", selName);
        }
    }
}

- (void)test
{
//    NSObject *obj = [[NSObject alloc] init];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
//        @synchronized(obj){
//            NSLog(@"需要线程同步的操作1 开始");
//            sleep(3);
//            NSLog(@"需要线程同步的操作1 结束");
//        }
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        @synchronized(obj) {
//            NSLog(@"需要线程同步的操作2");
//        }
//    });
    
    /********************************************************************************/
    
    
    //主线程中
    NSLock *theLock = [[NSLock alloc] init];
    NSObject *obj = [[NSObject alloc] init];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void(^TestMethod)(int);
        TestMethod = ^(int value){
            [theLock lock];
            if (value > 0){
                [obj copy];
                sleep(5); //后面写上[theLock unlock];而不是放在最后，就加锁，解锁就一一对应了，
            }
            [theLock unlock];
        };
        TestMethod(5);
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [theLock lock];
        [obj copy];
        [theLock unlock];
        
    });
    
    /***************************************************************************/
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"需要线程同步的操作1 开始");
        sleep(2); //数组写操作
        NSLog(@"需要线程同步的操作1 结束");
        dispatch_semaphore_signal(signal);
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        sleep(1);
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"需要线程同步的操作2");
        dispatch_semaphore_signal(signal);
        
    });
    
    NSConditionLock * lock = [[NSConditionLock alloc]init];
    NSMutableArray * piaos = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
    
    // 线程1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i< piaos.count; i++) {
            [lock lock];
            NSLog(@"哎呀哦");
            [lock unlockWithCondition:i];
            sleep(3);
        }

    });
    // 线程2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [lock lockWhenCondition:2];
        NSLog(@"xxoo");
        [lock unlock];
    });
    
}

//计算字符个数
-  (int)convertToInt:(NSString*)strtemp {
    
    int arr[5] = {1,3,5,7,9};
    int m = *(arr+2);
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

@end

