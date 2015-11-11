//
//  ViewController.m
//  JYTServiceDemo
//
//  Created by bihongbo on 15/10/29.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (weak, nonatomic) IBOutlet UITextView *paramTextView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (assign, nonatomic) int page;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
        
}
- (IBAction)requestAction:(UIButton *)sender {
    [self.act startAnimating];
    
//    SearchTeacherParam * param = [[SearchTeacherParam alloc] init];
//    param.userId = @"0001";
//    param.page = @"1";
//    param.size = @"100";
//    self.paramTextView.text = [NSString stringWithFormat:@"URL:%@\n%@:\n%@",URL_HOME_TEACHERLIST,param.description,[param keyValues]];
    
#pragma mark 基础请求支持,开启json缓存
//    JsonCacheContext * jc = [[JsonCacheContext alloc] init];
//    [BaseService baseServiceWithURLString:URL_SEARCH_TEACHERLIST andResultClass:[SearchTeacherResult class] andParam:param andCacheContext:jc andRequestType:ServiceRequestTypeGet success:^(id result) {
//        [self.act stopAnimating];
//        SearchTeacherResult * rs = result;
//        self.resultTextView.text = [NSString stringWithFormat:@"%@:\n%@",rs.description,[rs keyValues]];
//    } andFailed:^(NSError *error) {
//        [self.act stopAnimating];
//        self.resultTextView.text = @"网络异常";
//    }];
    
    
#pragma mark 封装业务层之后的使用
//    [TeacherService teacherSearchDataWithParam:param Success:^(SearchTeacherResult *result) {
//        [self.act stopAnimating];
//        self.resultTextView.text = [NSString stringWithFormat:@"%@:\n%@",result.description,[result keyValues]];
//    } andFailed:^(NSError *error) {
//        [self.act stopAnimating];
//        self.resultTextView.text = @"网络异常";
//    }];

    
}

- (IBAction)clearAction:(id)sender {
    self.paramTextView.text = @"";
    self.resultTextView.text = @"";
}


@end
