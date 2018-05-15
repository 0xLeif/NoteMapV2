//
//  Singleton.m
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@implementation Singleton

+ (Singleton *)standard {
    static Singleton *main = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        main = [[self alloc] init];
    });
    
    return main;
}

- (id)init {
    if (self = [super init]) {
        _commonString = @"this is string";
    }
    return self;
}

@end
