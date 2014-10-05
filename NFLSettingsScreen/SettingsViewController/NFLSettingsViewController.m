//
//  NFLSettingsViewController.m
//  NFLSettingsScreen
//
//  Created by Amit Soni on 10/29/13.
//

#define colorWithRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0  alpha:1.0]
#define kHeightForSettingsTableViewRow              60.0f
#define kHeightForSettingsTableViewSectionHeader    30.0f
#define kFontSizeForSettingsTableViewHeaderLabel    18.0f
#define kFontSizeForSettingsTableViewCellTextLabel  18.0f

#import "NFLSettingsViewController.h"

@interface NFLSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (strong, nonatomic) NSArray *tableDataSource;
@end

@implementation NFLSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doInitializations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Format of array is:  Array of dictionaries -  In Each Dictionary 1 Key - 1 Value : key is the section header name and value is again an array of dictionaries, each dictionary contains 2 keys- text and imageName, "text" key for text to appear in Cell and "imageName" for name of image to appear as thumbnail image in cell
 */
#pragma mark - Private Methods
- (void)doInitializations
{
    self.tableDataSource = @[@{@" " : @[@{@"text" : @"Sign In", @"imageName" : @"NFL_Logo.png"}, @{@"text" : @"Bengals", @"imageName" : @"teamLogo.png"}]},
                             @{@"CONNECT SOCIAL" : @[@{@"text" : @"Connect to Facebook", @"imageName" : @"facebookIcon.png"}]},
                             @{@"SUBSCRIPTIONS" : @[@{@"text" : @"Mobile Premium", @"imageName" : @"PlayButtonIcon.png"}, @{@"text" : @"Restore Purchases", @"imageName" : @"PlayButtonIcon.png"}]},
                             @{@"VIDEO" : @[@{@"text" : @"Closed Captioning"}]},
                             @{@"HELP" : @[@{@"text" : @"FAQs"}]},
                             @{@"MORE" : @[@{@"text" : @"Privacy Policy"}, @{@"text" : @"Terms & Conditions"}, @{@"text" : @"Send Feedback"}, @{@"text" : @"Rate NFL Mobile"}]},
                             @{@"APP INFO" : @[@{@"text" : @"NFL Version:1.0.1.0"}, @{@"text" : @"Ref Id:526f7d810cf237aa2fb0675f"}]}
                             ];
    
    [self.settingsTableView setDataSource:self];
    [self.settingsTableView setDelegate:self];
}

- (UISwitch *)getSwitchForVideoAccessoryView
{
    UISwitch *switchAccessory = [[UISwitch alloc] init];
    [switchAccessory addTarget:self action:@selector(didChangedValueForVideoSwitch:) forControlEvents:UIControlEventValueChanged];
    
    return switchAccessory;
}

- (void)didChangedValueForVideoSwitch:(UISwitch *)sender
{
    if ([sender isOn]) {
        NSLog(@"Turned On");
    }
    else {
        NSLog(@"Turned Off");
    }
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictDetails = [self.tableDataSource objectAtIndex:[indexPath section]];
    NSString *headerTitle = [[dictDetails allKeys] lastObject];
    NSDictionary *cellDetails = [dictDetails[headerTitle] objectAtIndex:[indexPath row]];
    NSString *textForCell = [cellDetails objectForKey:@"text"];
    
    [cell.textLabel setText:textForCell];
    
    if ([cellDetails objectForKey:@"imageName"]) {
        [cell.imageView setImage:[UIImage imageNamed:[cellDetails objectForKey:@"imageName"]]];
    }
    
    if ([headerTitle isEqualToString:@"VIDEO"]) {
        [cell setAccessoryView:[self getSwitchForVideoAccessoryView]];
    }
    
    if ([headerTitle isEqualToString:@"MORE"] || [headerTitle isEqualToString:@"HELP"] || [headerTitle isEqualToString:@"SUBSCRIPTIONS"] || [headerTitle isEqualToString:@" "]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setTextColor:colorWithRGB(44.0, 44.0, 44.0)];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:kFontSizeForSettingsTableViewCellTextLabel]];
}

#pragma mark - UITableView DataSource and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictDetails = [self.tableDataSource objectAtIndex:section];
    NSString *keyForHeader = [[dictDetails allKeys] lastObject];
    
    return [dictDetails[keyForHeader] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableDataSource count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeightForSettingsTableViewSectionHeader)];
    [headerView setBackgroundColor:colorWithRGB(103.0, 103.0, 103.0)];
    
    CGRect headingLabelFrame = headerView.frame;
    headingLabelFrame.origin.x = 10;
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:headingLabelFrame];
    [headingLabel setTextAlignment:NSTextAlignmentLeft];
    [headingLabel setText:[[self.tableDataSource[section] allKeys] lastObject]];
    [headingLabel setTextColor:[UIColor whiteColor]];
    [headingLabel setFont:[UIFont boldSystemFontOfSize:kFontSizeForSettingsTableViewHeaderLabel]];
    
    [headerView addSubview:headingLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float heightForSection = 0;
    
    if (section != 0) {
        heightForSection = kHeightForSettingsTableViewSectionHeader;
    }
    
    return heightForSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForSettingsTableViewRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TableView Row Selected at RowIndex:%d in Section:%d", [indexPath row], [indexPath section]);
}

@end
