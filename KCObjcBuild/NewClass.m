//
//  NewClass.m
//  KCObjcBuild
//
//  Created by 张理想 on 2021/10/27.
//

#import "NewClass.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import <objc/message.h>


#import "SATest.h"

@interface NewClass ()
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSString *title;

@end

@implementation NewClass
+(void)load{
    
}
-(void)letTest{
    self.name =@"111";

}
-(void)startMethod{
    self.title =@"222";

    [self seeAllocSize];
    [self seeAllocPointer];
    [self seeMetaclass];
    [self test];
    [self testBlock];
    
}


#pragma mark - 类的内存
// 内存大小
-(void)seeAllocSize{
   NSObject *objc = [NSObject alloc];
   NSLog(@"objc对象类型占用的内存大小：%lu",sizeof(objc));
   NSLog(@"objc对象实际占用的内存大小：%lu",class_getInstanceSize([objc class]));
   NSLog(@"objc对象实际分配的内存大小：%lu",malloc_size((__bridge const void *)(objc)));
}
//内存指针
-(void)seeAllocPointer{
    
    /// [NewClass alloc] 和 [obj1 init] 返回的都是内存地址
    /// [NewClass alloc]
    
    NewClass *obj1 = [NewClass alloc];
    NewClass *obj2 = [obj1 init];
    NewClass *obj3 = [obj1 init];
    NSLog(@"%@ - %p - %p", obj1, obj1 , &obj1);
    NSLog(@"%@ - %p - %p", obj2, obj2 , &obj2);
    NSLog(@"%@ - %p - %p", obj3, obj3 , &obj3);
    
    NSLog(@"%@ - %p ", [obj1 init], [obj1 init]);
    NSLog(@"%@ - %p - %p", [NewClass alloc], [NewClass alloc]  );

    
    NewClass *obj4 ;
    NSLog(@"%@ - %p ",obj4, obj4);
     
}
-(void)seeMetaclass{
    Class cls1 = [SATest class];
    Class cls2 = [SATest alloc].class;
    Class cls3 = object_getClass([SATest alloc]);
    NSLog(@"cls1: %p", cls1);
    NSLog(@"cls2: %p", cls2);
    NSLog(@"cls3: %p", cls3);
}

#pragma mark - 动态创建类和方法
void hb_test_method(Class cla, SEL _cmd){
    NSLog(@"我这个添加的方法被调用了");
}

-(void)addNewClass{
    
    Class HBObject = objc_allocateClassPair(objc_getClass("NSObject"), "HBObject", 0);
    class_addIvar(HBObject, "name", sizeof(id), log2(sizeof(id)), @encode(id));
    class_addMethod(HBObject, sel_registerName("hb_test_method"), (IMP)hb_test_method, "v@:");
    objc_registerClassPair(HBObject);
    id newObject = [[HBObject alloc]init];
    [newObject setValue:@"yahibo" forKey:@"name"];
    NSLog(@"name:%@",[newObject valueForKey:@"name"]);
    ((id(*)(id, SEL))objc_msgSend)(newObject, @selector(hb_test_method));
}

#pragma mark - 内存地址
- (void)test{
    
    NSInteger i = 123;
    NSLog(@"i的内存地址：%p", i);
    NSLog(@"&i的内存地址：%p", &i);
    
    NSString *string = @"CJL";
    NSLog(@"string的内存地址：%p", string);
    NSLog(@"&string的内存地址：%p", &string);
    
    NSObject *obj = [[NewClass alloc] init];
    NSLog(@"obj的内存地址：%p", obj);
    NSLog(@"&obj的内存地址：%p", &obj);
    
    // 堆区
    NSString *myName = [NSString stringWithFormat:@"%@ - %zd", string, i];
    NSLog(@"myName的内存地址：%p", myName);
    NSLog(@"&myName的内存地址：%p", &myName);
    
    
}
-(void)testBlock{
    int a = 10;
    
    void(^block1)(void) = ^{
        NSLog(@"CJL - %d", 1);
    };
    
   void(__weak ^block2)(void) = ^{
       NSLog(@"CJL - %d", a);
   };
    void(^block3)(void) = ^{
        NSLog(@"CJL - %d", a);
    };
    a = 100;
    block1();
    block2();
    block3();
    
    NSLog(@"%@",block1);
    NSLog(@"%@",block2);
    NSLog(@"%@",block3);

}

@end
