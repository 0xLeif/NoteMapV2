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
///Returns the ordered color array
-(NSArray *)colorOrder;
///Returns the NoteMap global size
-(CGSize)noteMapSize;
///Returns if the Coords have been loaded
-(BOOL)isCoordsLoaded;
///Returns the current viewingPoint of the user on the NoteMap ScrollView (contentOffset)
-(CGPoint)viewingPoint;

//MARK: Util methods
///Saves the current Coords
-(void)saveCoords;
///Loads the current Coords
-(void)loadCoords;
///Use to update the current Coords
-(void)updateCoords:(CGPoint) point;

//MARK: Properties
///Has the Application loaded the NoteMap for the user
@property (nonatomic) BOOL isLoaded;
///The current X position of the user in the NoteMap ScrollView
@property (assign, nonatomic) CGFloat currentX;
///The current Y position of the user in the NoteMap ScrollView
@property (assign, nonatomic) CGFloat currentY;
///The current Z position of the user in the NoteMap ScrollView
@property (assign, nonatomic) CGFloat currentZ;

@end
