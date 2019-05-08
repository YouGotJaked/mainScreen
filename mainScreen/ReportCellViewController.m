//
//  ReportCellViewController.m
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "ReportCellViewController.h"

@interface ReportCellViewController ()

@end

@implementation ReportCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scroller.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight);
    
    NSLog(@"the session is %@", _session);
    self.pointerView.session = _session;
    self.graphView.session = _session;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSString *)getSession {
    return _session;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
