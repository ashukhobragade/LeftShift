//
//  MasterViewController.m
//  LeftShiftsOpenweather
//
//  Created by AshU on 3/18/15.
//  Copyright (c) 2015 Ashish Khobragade. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()<UITextFieldDelegate>

@property NSMutableArray *objects;

@property(nonatomic,strong) UIView *addCityView;
@property(nonatomic,strong) UITextField *cityTextField;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNewCityView];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddCityView)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addNewCityView{
    
    _addCityView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 150)];
    [_addCityView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_addCityView];
    
    _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, _addCityView.frame.size.width-10, 40)];
    _cityTextField.clearButtonMode =YES;
    [_cityTextField setContentMode:UIViewContentModeCenter];
    [_cityTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_cityTextField setBackgroundColor:[UIColor whiteColor]];
    _cityTextField.delegate = self;
    _cityTextField.placeholder = @"Enter City Name";
    
    [_addCityView addSubview:_cityTextField];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [doneBtn setFrame:CGRectMake(110, 100, 80, 40)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneBtn setTitle:@"Done" forState:UIControlStateHighlighted];
    
    [doneBtn setBackgroundColor:[UIColor blueColor]];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [doneBtn addTarget:self action:@selector(removeAddNewCityView) forControlEvents:UIControlEventTouchUpInside];
    
    [_addCityView addSubview:doneBtn];
    
    [self.addCityView setHidden:YES];
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:_cityTextField.text atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    
    UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-1, cell.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:line];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}
#pragma mark events-

-(void)showAddCityView{
    
    _cityTextField.text=@"";
    [self.addCityView setHidden:NO];
    [_cityTextField becomeFirstResponder];
      }

-(void)removeAddNewCityView{
    
    [self.addCityView setHidden:YES];
    
    [_cityTextField resignFirstResponder];
    
    if (![_cityTextField.text isEqualToString:@""]) {
        
        [self insertNewObject:nil];
    }

}
#pragma mark -textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_cityTextField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
_cityTextField.text=@"";
    return YES;
}
@end
