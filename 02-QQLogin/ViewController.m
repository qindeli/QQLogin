//
//  ViewController.m
//  02-QQLogin
//
//  Created by vera on 16/9/18.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
//坑
#import <TencentOpenAPI/TencentApiInterface.h>

@interface ViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
}

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end

@implementation ViewController

/**
 *  QQ登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)qqLogin:(id)sender
{
    //创建一个授权对象
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105625767"   andDelegate:self];
    
    //权限
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    //登录
    [_tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark - TencentSessionDelegate
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSLog(@"%@",response.jsonResponse);
    
    NSString *imageUrl = response.jsonResponse[@"figureurl_qq_2"];
    NSString *name = response.jsonResponse[@"nickname"];
    
    //昵称
    self.nicknameLabel.text = name;
    //头像
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headImageView.image = [UIImage imageWithData:data];
        });
    });
}

#pragma mark - TencentLoginDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    
    //获取用户的昵称和头像---该方法自动获取accessToken,提交到腾讯服务器
    [_tencentOAuth getUserInfo];
    
    /*
     登录成功后，即可获取到access token和openid。accessToken和 openid
     */
    //凭证，用于后续访问各开放接口
    [_tencentOAuth accessToken] ;
    //用户授权登录后对该用户的唯一标识.最终openId提交到自己服务器
    [_tencentOAuth openId] ;

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"取消登录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
