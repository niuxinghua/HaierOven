//
//  OHPlayAudio.m
//  酷学
//
//  Created by 刘康 on 14-7-1.
//  Copyright (c) 2014年 Edaysoft. All rights reserved.
//

#import "OHPlayAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface OHPlayAudio ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioSession * audioSession;

@end

@implementation OHPlayAudio

+ (id)sharedAudioPlayer
{
    static OHPlayAudio *audioPlayer ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[OHPlayAudio alloc] init];
    });
    
    return audioPlayer;
}

- (id)init{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)play
{
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(self.audioSession == nil)
    {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else
    {
        [ self.audioSession setActive:YES error:nil];
    }
    
    [self.audioPlayer stop];
    [self.audioPlayer play];
        NSLog(@"播放。 ");
}

- (void)playFuck
{
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
    
    if(self.audioSession == nil)
    {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else
    {
        [ self.audioSession setActive:YES error:nil];
    }
    
    NSData* data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"fuck" withExtension:@"mp3"]];
    
    [self setplayData:data];
    
    [self.audioPlayer stop];
    [self.audioPlayer play];
}

- (void)stop
{
    [self.audioPlayer stop];
}



- (void)setplayData:(NSData *)data
{
    NSError *error;
    
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [self.audioPlayer prepareToPlay];
    
}

- (void)setplayURL:(NSURL *)url{
    NSError *error;
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [self.audioPlayer prepareToPlay];
}

@end
