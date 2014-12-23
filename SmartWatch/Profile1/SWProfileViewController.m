//
//  SWProfileViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/3.
//
//

#import "SWProfileViewController.h"
#import "SWHeadImageCell.h"
#import "SWProfileInfoCell.h"
#import "SWProfileModel.h"
#import "SWUserInfo.h"
#import "WBPath.h"
#import "HTDatePicker.h"
#import "SWPickerView.h"

@interface SWProfileViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HTDatePickerDelegate,SWPickerViewDelegate>
{
    SWHeadImageCell *headImageCell;
    
    HTDatePicker *datePicker;
    
    SWPickerView *sexPickerView;
    NSArray *sexPickerViewDataSource;
    
    SWPickerView *heightPickerView;
    NSArray *heightPickerViewDataSource;
    
    SWPickerView *weightPickerView;
    NSArray *weightPickerViewDataSource;
    
    SWProfileModel *model;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        model = [[SWProfileModel alloc] initWithResponder:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"3背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"3背景-ios_02"]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 17.0f);
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * headImageCellIdentifier = @"headImageCellIdentifier";
    static NSString * otherCellIdentifier = @"otherCellIdentifier";
    if (indexPath.row == 0) {
        headImageCell = (SWHeadImageCell *)[tableView dequeueReusableCellWithIdentifier:headImageCellIdentifier];
        if (!headImageCell) {
            headImageCell = [[SWHeadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headImageCellIdentifier];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap)];
            [headImageCell.headImageView addGestureRecognizer:tapGesture];
            headImageCell.nameTextField.delegate = self;
        }
        
        headImageCell.headImageView.image = [[UIImage alloc] initWithContentsOfFile:[[WBPath documentPath] stringByAppendingPathComponent:[[SWUserInfo shareInstance] headImagePath]]];
        headImageCell.nameTextField.text = [[SWUserInfo shareInstance] name];
        return headImageCell;
    }
    
    SWProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellIdentifier];
    if (!cell) {
        cell = [[SWProfileInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellIdentifier];
    }
    
    if (indexPath.row == 1) {
        cell.title = @"性别";
        cell.value = [[SWUserInfo shareInstance] sex] == 0 ? @"女" : @"男";
    } else if (indexPath.row == 2) {
        cell.title = @"生日";
        cell.value = [[SWUserInfo shareInstance] birthdayString];
    } else if (indexPath.row == 3) {
        cell.title = @"身高";
        cell.value = [NSString stringWithFormat:@"%@cm", @([[SWUserInfo shareInstance] height]).stringValue];
    } else if (indexPath.row == 4) {
        cell.title = @"体重";
        cell.value = [NSString stringWithFormat:@"%@kg", @([[SWUserInfo shareInstance] weight]).stringValue];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 168.0f;
    }
    
    return 45.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (datePicker && !datePicker.hidden) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row != 0) {
        self.tableView.userInteractionEnabled = NO;
    }
    
    if (indexPath.row == 1) {
        if (!sexPickerView) {
            sexPickerView = [[SWPickerView alloc] init];
            sexPickerView.hidden = YES;
            sexPickerView.delegate = self;
            
            sexPickerViewDataSource = @[@"男", @"女"];
            sexPickerView.dataSource = sexPickerViewDataSource;
        }
        [sexPickerView showFromView:self.view];
    } else if (indexPath.row == 2) {
        if (!datePicker) {
            datePicker = [[HTDatePicker alloc] initWithFrame:CGRectMake(0, self.view.height, IPHONE_WIDTH, 260) date:[NSDate date]];
            datePicker.hidden = YES;
            datePicker.delegate = self;
            [self.view addSubview:datePicker];
        }
        [self showDatePicker:YES];
    } else if (indexPath.row == 3) {
        if (!heightPickerView) {
            heightPickerView = [[SWPickerView alloc] init];
            heightPickerView.hidden = YES;
            heightPickerView.delegate = self;
            
            heightPickerViewDataSource = @[@140, @145, @150, @155, @160, @165, @170, @175, @180, @185, @190];
            heightPickerView.titleSuffix = @"cm";
            heightPickerView.dataSource = heightPickerViewDataSource;
        }
        [heightPickerView showFromView:self.view];
    } else if (indexPath.row == 4) {
        if (!weightPickerView) {
            weightPickerView = [[SWPickerView alloc] init];
            weightPickerView.hidden = YES;
            weightPickerView.delegate = self;
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 20; i < 201; i++) {
                [arr addObject:@(i).stringValue];
            }
            weightPickerViewDataSource = arr;
            weightPickerView.titleSuffix = @"kg";
            weightPickerView.dataSource = weightPickerViewDataSource;
        }
        [weightPickerView showFromView:self.view];
    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (datePicker && !datePicker.hidden) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newStr length]>20)
    {
        NSString *msg =  NSLocalizedString(@"名字字符数不能超过20", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [model saveName:textField.text];
    return YES;
}

#pragma mark - Action sheet

- (void)headImageTap {
    if (datePicker && !datePicker.hidden) {
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消",@"Cancel button text")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从相册选择",@"Button text"),
                                  NSLocalizedString(@"拍照",@"Camera button text"),nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.tableView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [[GCDQueue mainQueue] queueBlock:^{
                [self presentViewController:imagePicker animated:YES completion:nil];
            } afterDelay:0.3f];
        }
    }
    if (buttonIndex == 0){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [[GCDQueue mainQueue] queueBlock:^{
            [self presentViewController:imagePicker animated:YES completion:nil];
        } afterDelay:0.3f];
    }
}

#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    headImageCell.headImageView.image = originalImage;
    [model saveHeadImage:originalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    headImageCell.headImageView.image = selectedImage;
    [model saveHeadImage:selectedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTDatePickerDelegate

- (void)datePickerCancel {
    [self showDatePicker:NO];
}

- (void)datePickerFinished:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [model saveBirthday:dateString];
    [self showDatePicker:NO];
    [self.tableView reloadData];
}

- (void)showDatePicker:(BOOL)show {
    self.tableView.userInteractionEnabled = show ? NO : YES;
    datePicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        datePicker.top = show ? self.view.height - 260.0f: self.view.height;
    } completion:^(BOOL finished) {
        if (!show) {
            datePicker.hidden = YES;
        }
    }];
}

#pragma mark - SWPickerViewDelegate 

- (void)pickerView:(SWPickerView *)pickerView didFinished:(NSString *)value {
    if (pickerView == sexPickerView) {
        NSInteger sex = [value isEqualToString:@"男"] ? 1 : 0;
        if ([[SWBLECenter shareInstance] setUserInfoWithHeight:[SWUserInfo shareInstance].height weight:[SWUserInfo shareInstance].weight sex:sex]) {
            [model saveSex:sex];
        }
    } else if (pickerView == heightPickerView) {
        if ([[SWBLECenter shareInstance] setUserInfoWithHeight:value.integerValue weight:[SWUserInfo shareInstance].weight sex:[SWUserInfo shareInstance].sex]) {
            [model saveHeight:value.integerValue];
        }
    } else if (pickerView == weightPickerView) {
        if ([[SWBLECenter shareInstance] setUserInfoWithHeight:[SWUserInfo shareInstance].height weight:value.integerValue sex:[SWUserInfo shareInstance].sex]) {
            [model saveWeight:value.integerValue];
        }
    }
    
    [self.tableView reloadData];
    [pickerView hideFromView:self.view];
    self.tableView.userInteractionEnabled = YES;
}

- (void)pickerViewDidCancel:(SWPickerView *)pickerView {
    [pickerView hideFromView:self.view];
    self.tableView.userInteractionEnabled = YES;
}

@end
