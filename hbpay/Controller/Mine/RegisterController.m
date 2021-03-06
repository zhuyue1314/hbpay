#import "RegisterController.h"
#import "PlaceholderTextView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "Public.h"
#import "Constant.h"
#import "TitleView.h"
#import "AgreeController.h"
#import "APRoundedButton.h"
#import "NetworkSingleton.h"
#import "SMSCodeRstModel.h"
#import "RegisterRstModel.h"
@interface RegisterController ()<UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) PlaceholderTextView *feedbackTextView;
@property (nonatomic, strong) MBProgressHUD       *HUD;
@property (nonatomic,retain)  TitleView *titleView;
@property (nonatomic,retain)  UILabel *topLabel;
@property (nonatomic,assign) BOOL          isRead;
@property (nonatomic,strong) UITableView *registerTableView;
#pragma mark Register TextField Tag enum
enum TAG_REGISTER_TEXTFIELD{
    
  
    Tag_AccountTextField = 100,        //用户名
    Tag_SMSCodeTextField,
    Tag_TempPasswordTextField,    //登录密码
    Tag_ConfirmPasswordTextField, //确认登录密码
    Tag_RecommadTextField
};



#pragma mark - protocol Btn Tag 协议有关的btn的tag值
enum TAG_PROTOCOL_BUTTON{
    
    Tag_isReadButton = 200,   //是否已阅读
    Tag_servicesButton,       //服务协议
   
};

@end
@implementation RegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, (title_height+20-40)/2, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"tital_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    _titleView = [[TitleView alloc] initWithFrame:@"注 册" leftMenuItem:backBtn rightMenuItem:nil ];
    [self.view addSubview:_titleView];
    
    _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, H(_titleView), screen_width, screen_height) style:UITableViewStyleGrouped];
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.dataSource = self;
    _registerTableView.separatorStyle = NO;
    [self.view addSubview:_registerTableView];
    UITapGestureRecognizer *hideKeyboardRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allEditActionsResignFirstResponder)];
    [_registerTableView addGestureRecognizer:hideKeyboardRecognizer];
    hideKeyboardRecognizer.cancelsTouchesInView = NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]   ;
    
    if (indexPath.section == 0){
        
        cell.imageView.image = PNGIMAGE(@"register_user@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
        textField.tag = Tag_AccountTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"手机号码,必填";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        [cell addSubview:textField];
        
        
    }
    
    if (indexPath.section == 1){
        
        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, screen_width-150, 21.f)];
        textField.tag = Tag_SMSCodeTextField;
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"验证码,必填";
        [cell addSubview:textField];
        
        
        APRoundedButton *verifyBtn = [APRoundedButton buttonWithType:UIButtonTypeCustom];
        verifyBtn.frame = CGRectMake(screen_width-90, 5, 80, 34.f);
        
        [verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [verifyBtn   setBackgroundColor:RGB(84,188,223)];
        [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [verifyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [verifyBtn addTarget:self action:@selector(verifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        verifyBtn.style=10;
        [verifyBtn awakeFromNib];
        [cell addSubview:verifyBtn];
        
    }

    
    if (indexPath.section == 2){
        
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
            textField.tag = Tag_TempPasswordTextField;
            textField.keyboardType=UIKeyboardAppearanceDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"密码,必填";
            [cell addSubview:textField];
            
            
        }else if (indexPath.row == 1){
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
            textField.tag = Tag_ConfirmPasswordTextField;
            textField.keyboardType=UIKeyboardAppearanceDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"确认密码,必填";
            [cell addSubview:textField];
            
        }

        
        
    }
    if (indexPath.section ==3){
        
        cell.imageView.image = PNGIMAGE(@"register_recommand_people@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
        textField.tag = Tag_RecommadTextField;
        textField.keyboardType=UIKeyboardAppearanceDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"推荐码,(可选填)";
        [cell addSubview:textField];
        
    }
    if (indexPath.section == 4){
        [cell   setBackgroundColor:RGB(235, 235, 241)];

        APRoundedButton *registerBtn = [APRoundedButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake( 15.f, 0.f, screen_width-30, 44.f);
        [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn   setBackgroundColor:RGB(84,188,223)];

        registerBtn.style=10;
        
        //[registerBtn setBackgroundImage:[UIImage imageNamed:@"bg_paipian_date@2x"] forState:UIControlStateNormal];
        [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [registerBtn awakeFromNib];
        [cell addSubview:registerBtn];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"浙江电信11位手机号码" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        
        return  footerView ;
        
        //
    }
    if (section == 1){
        return nil;
        
    }
    if (section == 2){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"6位字符以上，可包含数字、字母（区分大小写）" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        return  footerView  ;
        
        
    }
    
    if (section == 4){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *isReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isReadBtn.frame = CGRectMake(10.f, 4.f, 21.f, 21.f);
        [isReadBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
        [isReadBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        isReadBtn.tag = Tag_isReadButton;
        [footerView addSubview:isReadBtn];
        
        
        UILabel *label1 = [Utils labelWithFrame:CGRectMake(35.f, 4.f, 95.f, 21.f) withTitle:@"我已阅读并同意" titleFontSize:[UIFont systemFontOfSize:13.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label1];
        
        UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        servicesBtn.frame = CGRectMake(130, 4.f, 80.f, 21.f);
        [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        servicesBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [servicesBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        servicesBtn.tag = Tag_servicesButton;
        [footerView addSubview:servicesBtn];
        
        
        
        
        
        return  footerView ;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 21.f;
    }
    if (section == 1) {
        return 1.f;
    }
    if(section == 2){
        
        return 21.f;
        
    }
    if(section == 4){
        
        return 40.f;
        
    }
    if(section == 3){
        return 10.f;
    }
    return 1.f;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [[UIView alloc] initWithFrame:CGRectZero]  ;
}


#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Tag_isReadButton:
        {
            //是否阅读协议
            if (_isRead) {
                
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
                
                _isRead = YES;
            }
        }
            break;
        case Tag_servicesButton:
        {
            AgreeController  *agreeController=[[AgreeController alloc]init];
            [self.navigationController pushViewController:agreeController animated:YES];
        }
        break;
            
            
        default:
            break;
    }
    
}
- (void)verifyBtnClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    
    NSString *phoneNumber=[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text];
    phoneNumber=[Utils trim:phoneNumber];
    if(![Utils isPhoneNumber:phoneNumber]){
        [Utils alertTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return ;
        
    }
    
   
    NSDictionary *paraInfo = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber, @"PhoneNumber", @"register", @"MessageType",nil];
    
    
    _HUD = [Utils createHUD];
    _HUD.labelText = @"";
    
    
    [[NetworkSingleton sharedManager] getSMSCode:paraInfo   successBlock:^(id responseBody){
        
        
        [_HUD hide:YES];
        SMSCodeRstModel *smsCodeRstModel = [SMSCodeRstModel objectWithKeyValues:responseBody];
        if(smsCodeRstModel.respCode==0){
             [self startTime:btn];
            
        }else{
            [Utils alertTitle:@"提示" message:smsCodeRstModel.respInfo delegate:self cancelBtn:@"确定" otherBtnName:nil];
            
        }
        
    } failureBlock:^(NSString *error){
        
        _HUD = [Utils createHUD];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _HUD.labelText =error;
        [_HUD hide:YES afterDelay:1.0];
    }];
    
}


- (void)startTime:(UIButton *)btn{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [btn  setBackgroundColor:RGB(84,188,223)];
                [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 100;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [btn  setBackgroundColor:RGB(235, 235, 241)];
                [btn  setTitleColor:RGB(84,225,223) forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}




#pragma mark - RegisterBtnClicked Method
- (void)registerBtnClicked:(id)sender{
    
    
    if (!_isRead) {
        [Utils alertTitle:@"提示" message:@"请勾选阅读协议选项框" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
        return;
    }
    NSString *phoneNumber,*smsValiCode,*from=@"00001";
    NSString *password,*encodePassword,*confirmPassword,*recommendCode;
    
    
    
    
    
    phoneNumber=[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text];
    phoneNumber=[Utils trim:phoneNumber];
    
    smsValiCode=[(UITextField *)[self.view viewWithTag:Tag_SMSCodeTextField] text];
    smsValiCode=[Utils trim:smsValiCode];
    
    password=[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text];
    password=[Utils trim:password];
    
    confirmPassword=[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text];
    confirmPassword=[Utils trim:confirmPassword];
    
    recommendCode=[(UITextField *)[self.view viewWithTag:Tag_RecommadTextField] text];
    recommendCode=[Utils trim:recommendCode];
    
    if(![Utils isPhoneNumber:phoneNumber]){
        [Utils alertTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return ;
        
    }
    if ( [smsValiCode length]<6) {
        
        [Utils alertTitle:@"提示" message:@"请输入正确的验证码" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return  ;
    }
    if(! [password isEqualToString:confirmPassword]){
        [Utils alertTitle:@"提示" message:@"两次密码输入不一致" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return  ;
    }
    
    
    
    _HUD = [Utils createHUD];
    _HUD.labelText = @"";
    
    encodePassword=[Utils md5:password];
    encodePassword=[Utils encodeBase64String:encodePassword];
    
    
   
    
    
    NSDictionary *paraInfo = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber, @"PhoneNumber", encodePassword, @"Password",smsValiCode, @"SmsValiCode",from, @"From",recommendCode, @"RecommendCode",nil];
    [[NetworkSingleton sharedManager] userRegister:paraInfo   successBlock:^(id responseBody){
        
        [_HUD hide:YES];
        
        RegisterRstModel *registerRstModel = [RegisterRstModel objectWithKeyValues:responseBody];
        if(registerRstModel.respCode==0){
            [Utils setStoreValue:STORE_PHONENUMBER storeValue:phoneNumber];
            [Utils setStoreValue:STORE_PASSWORD storeValue:password];
            [Utils alertTitle:@"提示" message:@"注册成功！！" delegate:self cancelBtn:@"确 定" otherBtnName:nil];
          
            //[self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [Utils alertTitle:@"提示" message:registerRstModel.respInfo delegate:self cancelBtn:@"确定" otherBtnName:nil];
            
        }
    } failureBlock:^(NSString *error){
        
        _HUD = [Utils createHUD];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _HUD.labelText =error;
        [_HUD hide:YES afterDelay:1.0];
    }];
    
    

    
    

    
}

/**
 *	@brief	验证文本框是否为空
 */
#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    
    
    if ([(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户名不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == Tag_RecommadTextField) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:nil] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
            
        /*case Tag_EmailTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if (![Utils isValidateEmail:textField.text]) {
                    
                    [Utils alertTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;*/
        case Tag_TempPasswordTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if ([[textField text] length] < 6) {
                    
                    [Utils alertTitle:@"提示" message:@"用户密码小于6位！" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_RecommadTextField:
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.view.frame = CGRectMake(0.f, iOS7?0.f:20.f, self.view.frame.size.width, self.view.frame.size.height);
                
            }completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //推荐人
    [[self.view viewWithTag:Tag_RecommadTextField] resignFirstResponder];
}



/**
 *	@brief	键盘出现
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil] ;
    
}

/**
 *	@brief	键盘消失
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}

- (void)OnTapBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
  {
     NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
     if ([btnTitle isEqualToString:@"确 定"]) {
         [self.navigationController popViewControllerAnimated:YES];

     }
  }

@end

