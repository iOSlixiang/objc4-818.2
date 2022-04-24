//
//  main.m
//  KCObjcBuild
//
//  Created by cooci on 2021/1/5.


// KC 重磅提示 调试工程很重要 源码直观就是爽
// ⚠️编译调试不能过: 请你检查以下几小点⚠️
// ①: enable hardened runtime -> NO
// ②: build phase -> denpendenice -> objc
// 爽了之后,还来一个 👍

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import <objc/message.h>

#import "NewClass.h"
#import "SATest.h"

union Test {
    char name;
    int age;
    long height;
};

void printUnion(union Test t) {
    printf("%c\n",t.name);
    printf("%d\n",t.age);
    printf("%ld\n",t.height);
    printf("---------\n");
}


int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NewClass *class = [[NewClass alloc]init];
        [class startMethod];
  
    }
    return 0;
}

 
