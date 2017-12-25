//
//  ViewController.h
//  RAC
//
//  Created by zhouyuxi on 2017/11/15.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet TestView *myView;
@property (weak, nonatomic) IBOutlet UITextField *myField;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


- (IBAction)model:(id)sender;

@end

