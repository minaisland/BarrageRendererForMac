//
//  AppDelegate.m
//  BarrageRendererForMac
//
//  Created by 郑先生 on 16/1/22.
//  Copyright © 2016年 郑先生. All rights reserved.
//

#import "AppDelegate.h"
#import "BarrageHeader.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) BarrageRenderer *renderer;

@end

@implementation AppDelegate
{
    NSTimer * _timer;
    NSInteger _index;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoSendBarrage) userInfo:nil repeats:YES];
    
    self.renderer = [[BarrageRenderer alloc] init];
    self.renderer.view.frame = self.window.contentView.bounds;
    self.renderer.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
//    self.renderer.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.window.contentView insertSubview:self.renderer.view atIndex:0];
    
    // Insert code here to initialize your application
}

- (BarrageDescriptor *)createDanmukuWithDict:(NSDictionary *)dict
{
    NSString *pString = dict[@"p"];
    NSString *mString = dict[@"m"];
    if (pString.length<1 || mString.length<1) {
        return nil;
    }
    NSArray *pArray = [pString componentsSeparatedByString:@","];
    if (pArray.count<5) {
        return  nil;
    }
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"direction"] = @([pArray[1] integerValue]%3);
//    DanmakuFont fontSize = [pArray[2] integerValue]%2;
    
    descriptor.params[@"timestamp"] = @([pArray[0] floatValue]/1000.0);
    descriptor.params[@"text"] = mString;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"textColor"] = [self.class colorWithHexStr:pArray[3]];
    return descriptor;
}
#define RGBCOLOR(r,g,b) [NSColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
+ (NSColor *)colorWithHexStr:(NSString *)str
{
    int i = 0;
    if ([str characterAtIndex:0] == '#')
        i = 1;
    
    if (i + 6 > [str length])
        return [NSColor blackColor];
    
    return RGBCOLOR([self intWithC1:[str characterAtIndex:i]
                                 C2:[str characterAtIndex:i + 1]],
                    [self intWithC1:[str characterAtIndex:i + 2]
                                 C2:[str characterAtIndex:i + 3]],
                    [self intWithC1:[str characterAtIndex:i + 4]
                                 C2:[str characterAtIndex:i + 5]]);
}

+ (int)intWithC1:(char)c1 C2:(char)c2
{
    int s = [self intWithChar:c1] * 16 + [self intWithChar:c2];
    return s;
}

+ (int)intWithChar:(char) c
{
    int r = 0;
    if (c >= '0' && c <= '9')
        r = c - '0';
    else if (c >= 'a' && c <= 'z')
        r = c - 'a' + 10;
    else if (c >= 'A' && c <= 'Z')
        r = c - 'A' + 10;
    return r;
}

- (void)autoSendBarrage
{
    [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
}
- (IBAction)start:(NSButton *)sender
{
    [_renderer start];
//    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
//    NSArray *danmakus = [NSArray arrayWithContentsOfFile:danmakufile];
//    for (NSDictionary *dict in danmakus) {
//        [_renderer receive:[self createDanmukuWithDict:dict]];
//    }
}

- (IBAction)stop:(NSButton *)sender {
    [_renderer pause];
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"过场文字弹幕:"];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
