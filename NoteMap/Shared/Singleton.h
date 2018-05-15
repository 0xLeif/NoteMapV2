//
//  Singleton.h
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Singleton : NSObject

///This is the standard Singleton object that is shared across the app
+ (Singleton *)standard;

//MARK: Properties
///Example string
@property NSString *commonString;

@end
