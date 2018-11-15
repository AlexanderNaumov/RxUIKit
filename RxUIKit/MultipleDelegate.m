//
//  MultipleDelegate.m
// 
//
//  Created by Alexander Naumov on 14/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

#import "MultipleDelegate.h"

@interface MultipleDelegate()
@property NSMutableArray *delegates;
@end

@implementation MultipleDelegate

- (instancetype)init {
    _delegates = [NSMutableArray new];
    return self;
}

- (void)addDelegate:(id)delegate {
    [_delegates addObject: delegate];
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject: delegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    for (id delegate in _delegates) {
        NSMethodSignature *signature = [delegate methodSignatureForSelector: sel];
        if (signature) {
            return signature;
        }
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector: invocation.selector]) {
            [invocation invokeWithTarget: delegate];
            return;
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector: aSelector]) {
            return true;
        }
    }
    return false;
}

- (id)delegate {
    return self;
}

@end
