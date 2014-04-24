//
//  Exercise.h
//  Repetitions
//
//  Created by Dan Sessions on 14/04/2014.
//  Copyright (c) 2014 Dan Sessions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

@property (nonatomic, assign) NSInteger repetitions;
@property (nonatomic, assign) NSInteger repetitionsCompleted;
@property (readonly, nonatomic, assign) NSInteger repetitionsToGo;
@property (readonly, nonatomic, assign) BOOL started;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *finishDate;

- (void)start;
- (void)stop;

@end
