//
//  GraphView.m
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

//float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};

- (float *)initData {
    //float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};
    //short oldData[] = {58,58,57,57,71,71,50,50,57,57,50,50,106,106,92,85,85,78,78,78,50,50,50,50,50,50,50,50,50,64,57,57,57,64,64,50,50,50,57,57,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,57};
    //NSMutableArray *oldDataConverted = [NSMutableArray arrayWithObjects:oldData count:sizeof(oldData)];
    
    //NSArray *plotData = [[NSArray alloc] initWithObjects:@58,@58,@57,@57,@71,@71,@50,@50,@57,@57,@50,@50,@106,@106,@92,@85,@85,@78,@78,@78,@50,@50,@50,@50,@50,@50,@50,@50,@50,@64,@57,@57,@57,@64,@64,@50,@50,@50,@57,@57,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@57, nil];
    
    PHPController *php = [[PHPController alloc] init];
    NSArray *plotData = [php parseArrayFromSession:_session];
    NSLog(@"Session: %@, Array: %@", _session, plotData);
    //NSDictionary *myDict = [pp parseDictionary];
    //for(id key in myDict)
        //NSLog(@"key=%@ value=%@", key, [myDict objectForKey:key]);
    dataLength = (int)[plotData count];
    scale = [self getScaleFromMaxOfArray:plotData];
    
    return [self rangeToPercentageFromArray:plotData WithLow:(int)hrLow andHigh:(int)hrHigh];
}

- (void)drawLineGraphWithContext:(CGContextRef)context {
    data = [self initData];
    
    for (int i = 0; i < dataLength; i++) {
        //NSLog(@"key:%d\tdata:%f", i,data[i]);
    }
    
    // prepare gradient
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.5, 0.0, 0.2,  // Start color
        1.0, 0.5, 0.0, 0.8}; // End color
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = kOffsetX;
    startPoint.y = kGraphHeight;
    endPoint.x = kOffsetX;
    endPoint.y = kOffsetY;
    
    // specify fill color
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < dataLength; i++) {
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextAddLineToPoint(context, kOffsetX + (dataLength - 1) * kStepX, kGraphHeight);
    CGContextClosePath(context);
    
    //CGContextDrawPath(context, kCGPathFill);
    CGContextSaveGState(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // cleanup
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    
    for (int i = 1; i < dataLength; i++) {
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // emphasize data points
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
    for (int i = 1; i < dataLength - 1; i++) {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(context, rect);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // define thickness and color of grid lines
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // draw vertical grid lines
    int vLines = (kDefaultGraphWidth - kOffsetX) / kStepX;
    
    for (int i = 0; i <= vLines; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    // draw horizontal grid lines
    
    int hLines = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    
    for (int i = 0; i <= hLines; i++) {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    
    // commit drawing
    CGContextStrokePath(context);
    
    // disable dash
    CGContextSetLineDash(context, 0, NULL, 0);
    
    [self drawLineGraphWithContext:context];
    
    // Drawing text
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    
    // display x labels
    for (int i = 1; i < dataLength; i++) {
        NSString *theText = [NSString stringWithFormat:@"%d", i];
        CGSize labelSize = [theText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX - labelSize.width/2, kGraphBottom - kOffsetY/2, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);

    }
    
    // display y labels
    NSArray *yLabels = [[NSArray alloc] initWithObjects:@65, @85, @105, @125, @145, @165, @185, @205, nil];

    for (int i = 1; i < [yLabels count]; i++) {
        int offset = (int)[yLabels count] - i - 1;
        NSString *yLabelText = [NSString stringWithFormat:@"%@", yLabels[offset]];
        CGSize labelSize = [yLabelText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
        CGContextShowTextAtPoint(context, kOffsetX, kOffsetY + i * kStepY - labelSize.height, [yLabelText cStringUsingEncoding:NSUTF8StringEncoding], [yLabelText length]);
    }
    
}

- (float *)rangeToPercentageFromArray:(NSArray *)array WithLow:(int)low andHigh:(int)high {
    NSInteger arrayCount = [array count];
    float *convertedArray = (float *)malloc(sizeof(float) * arrayCount);
    
    for (int i = 0; i < arrayCount; i++) {
        int obj = (int)[(NSNumber *)[array objectAtIndex:i] integerValue];
        float range = high - low;
        float offset = obj - low;
        // TODO: implement scaling
        float percentage = offset / range;
        //float percentage = (obj-low) / (high-low);
        convertedArray[i] = percentage;
        //NSLog(@"(%d-%d) / (%d-%d) = %f", obj, low, high, low, percentage);
    }
    
    return convertedArray;
}

- (float)getScaleFromMaxOfArray:(NSArray *)array {
    // sort array
    [array sortedArrayUsingSelector:@selector(compare:)];
    
    // get max
    int length = (int)[array count];
    float max = (float)[(NSNumber *)[array objectAtIndex:length-1] integerValue];
    
    if (max > 200) {
        return 1.0;
    } else if (max > 150) {
        return 1.25;
    } else if (max > 100) {
        return 1.5;
    } else if (max > 50) {
        return 2;
    } else {
        return 2.25;
    }
}

@end
