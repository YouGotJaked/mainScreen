//
//  ReportViewController.m
//  mainScreen
//
//  Created by Jake Day on 5/5/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@property (weak, nonatomic) IBOutlet UITableView *reportTableView;
@property (strong,nonatomic) NSMutableArray *tableData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) NSString *session;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    // Do any additional setup after loading the view.
    PHPController *php = [[PHPController alloc] init];
    int size = [php getFilledSessions];
    NSLog(@"size: %d", size);
    self.tableData = [NSMutableArray arrayWithCapacity:size];
    //self.tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    for (int i = 0; i < size; i++) {
        NSString *sessionStr = @"Session ";
        sessionStr = [sessionStr stringByAppendingString:[NSString stringWithFormat:@"%d", i+1]];
        [self.tableData insertObject:sessionStr atIndex:i];
    }
}

-(NSString *)getTimeAsString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss a"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


-(void)configTableView {
    self.reportTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
    [self.view addSubview:self.reportTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [self.reportTableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text =  [_tableData objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"title of cell %@", [_tableData objectAtIndex:indexPath.row]);
    
    NSString *sessionStr = @"SESSION";
    _session = [sessionStr stringByAppendingString:[NSString stringWithFormat:@"%ld", indexPath.row+1]];

    [self performSegueWithIdentifier:@"ReportCellSegue" sender:self];
}

- (NSString *)getSession {
    return _session;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //following lines needed only if you need to send some detail across to ContactViewController
    if ([segue.identifier isEqualToString:@"ReportCellSegue"]) {
        ReportCellViewController *destinationViewController = segue.destinationViewController;
        
        destinationViewController.session = _session;
        //where strTest is a variable in ContactViewController. i.e:
        //"@property (nonatomic, strong) NSString *strTest;"
        //declared in `ContactViewController.h`
    }
    
    //...
}

@end
