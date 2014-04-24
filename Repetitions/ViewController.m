//
//  ViewController.m
//  Repetitions
//
//  Created by Dan Sessions on 14/04/2014.
//  Copyright (c) 2014 Dan Sessions. All rights reserved.
//

#import "ViewController.h"
#import "Exercise.h"
#import "ExerciseTableViewCell.h"

@import QuartzCore;
@import AudioToolbox;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *repetitionsToGoView;
@property (weak, nonatomic) IBOutlet UIView *repetitionsView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UILabel *repetitionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repetitionsToGoLabel;
@property (weak, nonatomic) IBOutlet UITableView *exercisesTableView;
@property (strong, nonatomic) NSMutableArray *exercises;
@property (strong, nonatomic) Exercise *exercise;
@property (nonatomic) NSInteger repetitions;
@property (weak, nonatomic) IBOutlet UIStepper *repetitionsStepper;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exercises = [NSMutableArray array];
    
    self.repetitions = 10;
    self.repetitionsStepper.value = self.repetitions;
    
    [self setup];
}

- (void)setup
{
    self.startButton.layer.cornerRadius = self.startButton.bounds.size.height / 2;
    self.saveButton.layer.cornerRadius = self.saveButton.bounds.size.height / 2;
    self.repetitionsView.layer.cornerRadius = self.repetitionsView.bounds.size.height / 2;
    self.repetitionsToGoView.layer.cornerRadius = self.repetitionsToGoView.bounds.size.height / 2;
    self.clearButton.layer.cornerRadius = self.clearButton.bounds.size.height / 2;
}

- (void)vibrateDevice
{
    AudioServicesPlaySystemSound (1350); //RingerVibeChanged, works if currently silent.
    AudioServicesPlaySystemSound (1351); //SilentVibeChanged, works if currently NOT silent.
}

#pragma mark - IBActions

- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    self.repetitions = sender.value;
    
    self.repetitionsLabel.text = [NSString stringWithFormat:@"%d", self.repetitions];
}

- (IBAction)tapClear:(UIButton *)sender
{
    [self.exercises removeAllObjects];
    
    [self.exercisesTableView reloadData];
}

- (IBAction)tapStart:(UIButton *)sender
{
    if (!self.exercise) {
        self.exercise = [[Exercise alloc] init];
        self.exercise.repetitions = self.repetitions;
        [self addObservers];
        [self.exercise start];
        return;
    }
    
    if (self.exercise.started) {
        self.exercise.repetitionsCompleted++;
    }
    
    if (self.exercise.repetitionsToGo == 0) {
        [self vibrateDevice];
        [self.exercise stop];
        [self.exercises addObject:self.exercise];
        [self removeObservers];
        self.exercise = nil;
        [self.exercisesTableView reloadData];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exercises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell" forIndexPath:indexPath];
    
    Exercise *exercise = self.exercises[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [dateFormatter stringFromDate:exercise.finishDate];
    
    cell.repetitionsLabel.text = [NSString stringWithFormat:@"%d %@",
                                  exercise.repetitions,
                                  NSLocalizedString(@"Repetitions", @"Repetitions")];
    
    cell.timeLabel.text = timeString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"exercise.repetitionsCompleted"]) {
        self.repetitionsToGoLabel.text = [NSString stringWithFormat:@"%d", self.exercise.repetitionsToGo];
        return;
    }
    
    if ([keyPath isEqualToString:@"exercise.started"]) {
        if (self.exercise.started) {
            NSString *title = NSLocalizedString(@"done", "Done");
            [self.startButton setTitle:title forState:UIControlStateNormal];
        }
        else {
            NSString *title = NSLocalizedString(@"start", "Start");
            [self.startButton setTitle:title forState:UIControlStateNormal];
        }
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)addObservers
{
    [self addObserver:self forKeyPath:@"exercise.repetitionsCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"exercise.started" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
    [self removeObserver:self forKeyPath:@"exercise.repetitionsCompleted"];
    [self removeObserver:self forKeyPath:@"exercise.started"];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
