//
//  ReportCellViewController.h
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "PointerView.h"
#import "ReportViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportCellViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet PointerView *pointerView;
@property (strong, nonatomic) NSString *session;

- (NSString *)getSession;

@end

NS_ASSUME_NONNULL_END
