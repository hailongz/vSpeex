//
//  vSpeexPlayer.h
//  vSpeex
//
//  Created by zhang hailong on 13-6-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vSpeex/vSpeexReader.h>

@interface vSpeexPlayer : NSOperation

@property(nonatomic,assign) id delegate;
@property(nonatomic,readonly) SInt16 * frameBytes;
@property(nonatomic,readonly) UInt32 frameSize;
@property(nonatomic,readonly) NSTimeInterval duration;

-(id) initWithReader:(id<vSpeexReader>) reader;

@end

@protocol vSpeexPlayerDelegate

@optional

-(void) vSpeexPlayerDidFinished:(vSpeexPlayer *) player;

@end