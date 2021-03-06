//
//  vSpeexStreamWriter.m
//  vSpeex
//
//  Created by Zhang Hailong on 13-6-29.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "vSpeexStreamWriter.h"


#include "speex/speex.h"
#include "speex/speex_header.h"
#include "ogg/ogg.h"


@interface vSpeexStreamWriter(){
    FILE * _file;
    void * _ebuf;
    
}

@end

@implementation vSpeexStreamWriter

@synthesize speex = _speex;
@synthesize closed = _closed;

-(void) dealloc{
    if(_ebuf){
        free(_ebuf);
    }
    [_speex release];
    [super dealloc];
}

-(id) initWithFilePath:(NSString *) filePath speex:(vSpeex *) speex{
    if((self = [super init])){
        
        if(speex == nil){
            [self autorelease];
            return nil;
        }
        
        _file = fopen([filePath UTF8String], "wb");
        
        if(_file == nil){
            [self autorelease];
            return nil;
        }
        
        _speex = [speex retain];
        
        const struct SpeexMode * m = & speex_nb_mode;
        
        switch (speex.mode) {
            case vSpeexModeWB:
                m = & speex_wb_mode;
                break;
            case vSpeexModeUWB:
                m = & speex_uwb_mode;
                break;
            default:
                break;
        }
        
        SpeexHeader header;
       
        speex_init_header(&header, speex.samplingRate, 1, m);
        
        header.vbr = 0;
        header.bitrate = 16;
        header.frame_size = _speex.frameSize;
        header.frames_per_packet = speex.bitSize;
        header.reserved1 = speex.quality;
        
        int bytes = 0;
        void * data = speex_header_to_packet(&header, & bytes);
        
        fwrite(data, 1, bytes, _file);
        
        speex_header_free(data);
        
    }
    return self;
}

-(BOOL) writeFrame:(void *) frameBytes echoBytes:(void *) echoBytes{
    
    if(_closed){
        return NO;
    }
    
    int length = [_speex frameBytes];
    
    if(_ebuf == NULL){
        _ebuf = malloc(length);
    }
    
    memset(_ebuf, 0, length);
    
    if((length = [_speex encodeFrame:frameBytes encodeBytes:_ebuf echoBytes:echoBytes]) > 0){
        
        fwrite(_ebuf, 1, _speex.bitSize, _file);
        
        return YES;
    }
    
    return NO;
}

-(BOOL) close{
    
    if(!_closed){
    
        if(_file){
        
            fclose(_file);
            _file = NULL;
        }
        
        return YES;
    }
    
    return YES;
}

-(void) flush{
    if(_file){
        fflush(_file);
    }
}

@end