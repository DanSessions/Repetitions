//
//  Exercise.m
//  Repetitions
//
//  Created by Dan Sessions on 14/04/2014.
//  Copyright (c) 2014 Dan Sessions. All rights reserved.
//

#import "Exercise.h"

@interface Exercise ()
@property (nonatomic, assign) BOOL started;
@end

@implementation Exercise

- (void)start
{
    self.started = YES;
    self.repetitionsCompleted = 0;
    self.startDate = [NSDate date];
}

- (void)stop
{
    self.started = NO;
    self.finishDate = [NSDate date];
}

- (NSInteger)repetitionsToGo
{
    return self.repetitions - self.repetitionsCompleted;
}

@end
