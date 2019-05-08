//
//  GraphView.h
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHPController.h"
//#import "ReportCellViewController.h"

#define kGraphHeight 394
#define kDefaultGraphWidth 2955
#define kOffsetX 0
#define kOffsetY 10
#define kStepX 50
#define kStepY 50
#define kGraphBottom 394
#define kGraphTop 20
#define kCircleRadius 3

#define hrLow 40
#define hrHigh 200

NS_ASSUME_NONNULL_BEGIN

@interface GraphView : UIView {
    float pointerX;
    float pointerY;
    BOOL drawPointer;
    float *data;
    NSString *dataStr;
    int dataLength;
    float scale;
}

@property (strong, nonatomic) NSString *session;

//plotData = [[NSArray alloc] initWithObjects:@58,@58,@57,@57,@71,@71,@50,@50,@57,@57,@50,@50,@106,@106,@92,@85,@85,@78,@78,@78,@50,@50,@50,@50,@50,@50,@50,@50,@50,@64,@57,@57,@57,@64,@64,@50,@50,@50,@57,@57,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@57, nil];

@end

NS_ASSUME_NONNULL_END
