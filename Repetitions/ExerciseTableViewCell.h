//
//  ExerciseTableViewCell.h
//  Repetitions
//
//  Created by Dan Sessions on 22/04/2014.
//  Copyright (c) 2014 Dan Sessions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *repetitionsLabel;

@end
