//
//  MultipleDelegate.h
// 
//
//  Created by Alexander Naumov on 14/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultipleDelegate<ObjectType> : NSObject

@property (nonatomic, readonly) ObjectType delegate;

- (instancetype)init;
- (void)addDelegate:(ObjectType)delegate;
- (void)removeDelegate:(ObjectType)delegate;

@end
