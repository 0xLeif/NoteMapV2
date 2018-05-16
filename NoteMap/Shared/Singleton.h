//
//  Singleton.h
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Singleton : NSObject

///This is the standard Singleton object that is shared across the app
+(Singleton *)standard;
-(NSArray *)colorOrder;
-(CGSize)noteMapSize;
-(BOOL)isCoordsLoaded;
-(CGPoint)viewingPoint;

-(void)saveCoords;
-(void)loadCoords;
-(void)updateCoords:(CGPoint) point;

//MARK: Properties
@property (nonatomic) BOOL isLoaded;
@property (assign, nonatomic) CGFloat currentX;
@property (assign, nonatomic) CGFloat currentY;
@property (assign, nonatomic) CGFloat currentZ;

@end
