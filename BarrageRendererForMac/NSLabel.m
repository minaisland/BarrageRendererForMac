//
//  NSLabel.m
//  BarrageRendererForMac
//
//  Created by 郑先生 on 16/1/22.
//  Copyright © 2016年 郑先生. All rights reserved.
//

#import "NSLabel.h"

@implementation NSLabel

- (id)init
{
    if (self = [super init]) {
        self.bordered = self.editable = self.drawsBackground = NO;
    }
    return self;
}

@end
