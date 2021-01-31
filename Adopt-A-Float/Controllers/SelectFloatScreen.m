//
//  SelectFloatScreen.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/26/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import "SelectFloatScreen.h"

extern AppState *appStateManager;
@interface SelectFloatScreen ()
    @property (strong) NSArray<NSString *> *instrNames;
@end

@implementation SelectFloatScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.layer.cornerRadius = 10;
    self.buttonView.layer.cornerRadius = 20;
    self.buttonView.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 20;
    self.selectAllButton.layer.cornerRadius = 20;
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    _instrNames = appStateManager.instrNames;
}

- (void)viewWillAppear:(BOOL)animated {
    if (appStateManager.selectedInstrIndex >= 0) {
        NSIndexPath *selectedRow = [NSIndexPath indexPathForRow:appStateManager.selectedInstrIndex inSection:0];
        [self.table selectRowAtIndexPath:selectedRow animated:animated scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_instrNames count];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstrName"];
    cell.textLabel.text = _instrNames[indexPath.row];
    if (indexPath.row == appStateManager.selectedInstrIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// needed for implementation of UITableViewController class
- (NSIndexPath *)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *prevSelection = [tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:appStateManager.selectedInstrIndex inSection:0]];
    prevSelection.accessoryType = UITableViewCellAccessoryNone;
   
    
    appStateManager.selectedInstrIndex = (int) indexPath.row;
    appStateManager.selectedInstr = [appStateManager.instrNames objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

- (IBAction)displayAll:(id)sender {
    NSIndexPath *selectedRow = [self.table indexPathForSelectedRow];
    if (selectedRow) {
        UITableViewCell *selectedCell = [self.table cellForRowAtIndexPath:selectedRow];
        [self.table deselectRowAtIndexPath:selectedRow animated:YES];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    appStateManager.selectedInstrIndex = -1;
    appStateManager.selectedInstr = @"All";
}


@end
