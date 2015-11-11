# JYTServiceDemo

###本工程是对天天象上业务层的封装。

###使用方法：

####1.设置公共参数

    [BaseService setPublicParamDict:[self publicParamDict]];

####2.设置背景图片

    [BaseService setNetWorkMaxConcurrentOperationCount:10];

####3.设置缓存最大并发数

    [BaseService setCacheMaxConcurrentOperationCount:10];

####4.设置请求超时时间

[BaseService setTimeOutInteval:10];

####5.发起网络请求

    SearchTeacherParam * param = [[SearchTeacherParam alloc] init];
    param.userId = @"0001";
    param.page = @"1";
    param.size = @"100";
    
   
    [BaseService baseServiceWithURLString:URL_SEARCH_TEACHERLIST andResultClass:[SearchTeacherResult class] andParam:param andCacheContext:nil  andRequestType:ServiceRequestTypeGet success:^(id result) {
        SearchTeacherResult * rs = result;
    } andFailed:^(NSError *error) {
        self.resultTextView.text = @"网络异常";
    }];

####6.API分离

    @interface TeacherService : BaseService
    
    /**查找老师  API*/
    (ServiceControlManager *)teacherSearchDataWithParam:(SearchTeacherParam *)param Success:(void(^)(SearchTeacherResult *result))successBlock andFailed:(FailedBlock)failedBlock;
    .
    .
    .

    @implementation TeacherService

    (ServiceControlManager *)teacherSearchDataWithParam:(SearchTeacherParam *)param Success:(void(^)(SearchTeacherResult *result))successBlock andFailed:(FailedBlock)failedBlock
    {
        JsonCacheContext * jc = [[JsonCacheContext alloc]init];
        return [self baseServiceWithURLString:URL_SEARCH_TEACHERLIST andResultClass:[SearchTeacherResult class] andParam:param andCacheContext:jc andRequestType:ServiceRequestTypeGet success:^(Result *result) {
            successBlock((SearchTeacherResult *)result);
        } andFailed:^(NSError *error) {
            failedBlock(error);
        }];
        
    }


##附件中为业务层文档以及UML类图和PPT。


天天象上团队荣誉出品
http://www.daydays.com

联系邮箱：bihongbo@jiyoutang.com
          jiazhaoyang@jiyoutang.com

###欢迎大家issue我们！！
