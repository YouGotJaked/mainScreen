//
//  ReportViewController.h
//  mainScreen
//
//  Created by Jake Day on 5/5/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHPController.h"
#import "ReportCellViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : UIViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSString *)getSession;
@end

NS_ASSUME_NONNULL_END
