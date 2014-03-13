//
//  WindowController.m
//  NotificationsTest
//
//  Created by James Clarke on 3/11/14.
//  Copyright (c) 2014 Caffeine and Cocoa. All rights reserved.
//

#import "WindowController.h"
#import "FXNotifications.h"


static NSString *const IncrementCountNotification = @"IncrementCountNotification";


@interface WindowController ()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) IBOutlet NSTextField *label;

@end

@implementation WindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self addObserver:nil];
}

- (IBAction)closeSheet:(id)sender
{
    [NSApp endSheet:self.window];
}

- (IBAction)increment:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:IncrementCountNotification object:self.label];
}

- (IBAction)addObserver:(id)sender
{
    //using the built-in method (in a naive way), we would leak like hell
    //    [[NSNotificationCenter defaultCenter] addObserverForName:IncrementCountNotification
    //                                                      object:nil
    //                                                       queue:[NSOperationQueue mainQueue]
    //                                                  usingBlock:^(NSNotification *note) {
    //
    //        NSTextField *label = note.object;
    //        label.text = [NSString stringWithFormat:@"Presses: %@", @(++self.count)];
    //    }];
    
    //using the FXNotifications method, this approach doesn't leak and just works as expected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              forName:IncrementCountNotification
                                               object:self.label
                                                queue:[NSOperationQueue mainQueue]
                                           usingBlock:^(NSNotification *note, __weak WindowController *self) {
                                               
                                               NSTextField *label = note.object;
                                               label.stringValue = [NSString stringWithFormat:@"Presses: %@", @(++self.count)];
                                           }];
}

- (IBAction)removeObserver:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IncrementCountNotification object:self.label];
}

@end
