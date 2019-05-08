//
//  ViewController.m
//  mainScreen
//
//  Created by Jake Day on 5/5/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
- (IBAction)backButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[_gameButton addTarget:self action:@selector(toggleUIButtonImage:) forControlEvents:UIControlEventTouchUpInside];
    //[_reportButton addTarget:self action:@selector(toggleUIButtonImage:) forControlEvents:UIControlEventTouchUpInside];

}

-(IBAction)toggleUIButtonImage:(id)sender{
    if ([sender isSelected]) {
        [sender setBackgroundColor:[UIColor orangeColor]];
        [sender setSelected:NO];
    } else {
        [sender setBackgroundColor:[UIColor blueColor]];
        [sender setSelected:YES];
    }
}

- (IBAction)backButton:(id)sender {
    
}

@end
