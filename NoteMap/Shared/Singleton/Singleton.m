//
//  Singleton.m
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "NoteMap-Swift.h"

@interface Singleton()

@property (nonatomic) Color test;
@end

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
        _isLoaded = NO;
        _currentX = 0;
        _currentY = 0;
        _currentZ = 0;
    }
    return self;
}

-(NSArray *)colorOrder {
    return [[NSArray alloc] initWithObjects:ColorRed,
                                            ColorOrange,
                                            ColorYellow,
                                            ColorGreen,
                                            ColorBlue,
                                            ColorPurple,
                                            nil];
}

-(CGSize)noteMapSize {
    CGFloat multipler = 100;
    return CGSizeMake([UIScreen width] * multipler,
                      [UIScreen height] * multipler);
}

-(BOOL)isCoordsLoaded {
    return _currentZ != 0 &&
            _currentY >= 0 &&
            _currentX >= 0;
}

-(void)saveCoords {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat: _currentX forKey: @"currentx"];
    [defaults setFloat: _currentY forKey: @"currenty"];
    [defaults setFloat: _currentZ forKey: @"currentz"];
    [defaults synchronize];
}

-(void)loadCoords {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _currentX = [defaults floatForKey:@"currentx"];
    _currentY = [defaults floatForKey:@"currenty"];
    _currentZ = [defaults floatForKey:@"currentz"];
}

-(CGPoint)viewingPoint {
    CGFloat x = _currentX;
    CGFloat y = _currentY;
    return CGPointMake(x, y);
}

-(void)updateCoords:(CGPoint)point {
    if(point.x >= 0 && point.y >= 0) {
        _currentX = point.x;
        _currentY = point.y;
    }
}

@end

