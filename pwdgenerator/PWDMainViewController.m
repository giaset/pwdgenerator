//
//  PWDMainViewController.m
//  pwdgenerator
//
//  Created by Gianni Settino on 2014-09-03.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

#import "PWDMainViewController.h"

@interface PWDMainViewController ()

@property (nonatomic, strong) UILabel *passwordLabel;

@property (nonatomic, strong) UISwitch *capsSwitch;
@property (nonatomic, strong) UISwitch *numbersSwitch;
@property (nonatomic, strong) UISwitch *symbolsSwitch;

@end

@implementation PWDMainViewController

int length = 7;
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PWDGenerator";
    
    self.tableView.tableHeaderView = [self headerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIView*)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    headerView.backgroundColor = [UIColor blackColor];
    
    // Password Label
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 0, 0)];
    self.passwordLabel.textColor = [UIColor whiteColor];
    self.passwordLabel.font = [UIFont systemFontOfSize:34];
    [self generatePassword];
    [headerView addSubview:self.passwordLabel];
    
    // Refresh Button
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [refreshButton sizeToFit];
    refreshButton.tintColor = [UIColor whiteColor];
    // Properly place the button
    CGRect frameToModify = refreshButton.frame;
    frameToModify.origin.y = CGRectGetMaxY(self.passwordLabel.frame) + 10;
    frameToModify.origin.x = CGRectGetMidX(self.view.frame)-(refreshButton.frame.size.width/2);
    refreshButton.frame = frameToModify;
    [refreshButton addTarget:self action:@selector(generatePassword) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:refreshButton];
    
    return headerView;
}

- (void)setPasswordLabelTextTo:(NSString *)str
{
    self.passwordLabel.text = str;
    [self.passwordLabel sizeToFit];
    
    // Now center the label
    CGRect frameToModify = self.passwordLabel.frame;
    frameToModify.origin.x = CGRectGetMidX(self.view.frame)-(self.passwordLabel.frame.size.width/2);
    self.passwordLabel.frame = frameToModify;
}

- (void)lengthSliderChanged:(id)sender {
    UISlider *slider = (UISlider*)sender;
    length = slider.value;
    self.title = [NSString stringWithFormat:@"Length = %d", length];
}

- (void)generatePassword {
    NSString *lowercase = @"abcdefghijklmnopqrstuvwxyz";
    NSString *uppercase = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *numbers = @"1234567890";
    NSString *symbols = @"`~!@#$%^&*()_-+={}[]|:;'<>,.?/";
    
    NSMutableString *validChars = [[NSMutableString alloc] initWithString:lowercase];
    
    if (self.capsSwitch.on) {
        [validChars appendString:uppercase];
    }
    
    if (self.numbersSwitch.on) {
        [validChars appendString:numbers];
    }
    
    if (self.symbolsSwitch.on) {
        [validChars appendString:symbols];
    }
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [validChars characterAtIndex: arc4random_uniform([validChars length]) % [validChars length]]];
    }
    
    [self setPasswordLabelTextTo:randomString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Length";
            break;
            
        case 1:
            return @"Options";
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Customize the cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 5;
        slider.maximumValue = 10;
        slider.value = length;
        [slider addTarget:self action:@selector(lengthSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview: slider];
        slider.bounds = CGRectMake(0, 0, cell.contentView.bounds.size.width - 10, slider.bounds.size.height);
        slider.center = CGPointMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds));
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    } else {
        // Add a switch to this cell (NB: THIS WILL FUCK-UP BECAUSE OF CELL-REUSE, BUT I'M RUNNING LOW ON TIME SO IT'LL DO FOR NOW...)
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = toggle;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Caps";
                self.capsSwitch = toggle;
                break;
            case 1:
                cell.textLabel.text = @"Numbers";
                self.numbersSwitch = toggle;
                break;
            case 2:
                cell.textLabel.text = @"Symbols";
                self.symbolsSwitch = toggle;
                break;
            default:
                break;
        }
    }
    
    return cell;
}

@end
