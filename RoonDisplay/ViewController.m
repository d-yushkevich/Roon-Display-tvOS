#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) id webview;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Загружаем только если webview еще ничего не загружало
    if (![self.webview request]) {
        NSString *savedURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedRoonURL"];
        if (savedURL && ![savedURL isEqualToString:@""]) {
            [self loadURL:savedURL];
        } else {
            NSString *defaultURL = @"http://192.168.21.11:9330/display/";
            [self loadURL:defaultURL];
        }
    }
}
- (void)loadURL:(NSString *)urlString {
    if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
        
        // Сохраняем URL только если он отличается от текущего сохраненного
        NSString *savedURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedRoonURL"];
        if (![savedURL isEqualToString:urlString]) {
            [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:@"SavedRoonURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)initWebView {
    UIColor *customColor = [UIColor colorNamed:@"MyCustomColor"];
    self.view.insetsLayoutMarginsFromSafeArea = NO;
    self.additionalSafeAreaInsets = UIEdgeInsetsZero;
    self.webview = [[NSClassFromString(@"UIWebView") alloc] init];
    [self.webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.webview setClipsToBounds:NO];
    
    [self.webview setBackgroundColor:customColor];
    [self.webview setOpaque:NO];
    
    [self.browserContainerView addSubview:self.webview];
    [self.webview setFrame:self.view.frame];
    [self.webview setDelegate:self];
    [self.webview setLayoutMargins:UIEdgeInsetsZero];
    
    UIScrollView *scrollView = [self.webview scrollView];
    [scrollView setLayoutMargins:UIEdgeInsetsZero];
    scrollView.insetsLayoutMarginsFromSafeArea = NO;
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    // Устанавливаем черный фон для scrollView
    scrollView.backgroundColor = customColor;
    
    scrollView.contentOffset = CGPointZero;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.frame = self.view.frame;
    scrollView.clipsToBounds = NO;
    
    scrollView.bounces = YES;
    scrollView.panGestureRecognizer.allowedTouchTypes = @[ @(UITouchTypeIndirect) ];
    scrollView.scrollEnabled = NO;
    [self.webview setUserInteractionEnabled:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self initWebView];

    // создаём метку для отображения IP/URL
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 30)];
    self.urlLabel.textColor = [UIColor whiteColor];
    self.urlLabel.textAlignment = NSTextAlignmentCenter;
    self.urlLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.view addSubview:self.urlLabel];
}

#pragma mark - Menus

- (void)showSetRoonURLMenu {
    UIAlertController *alertController = [UIAlertController
                                         alertControllerWithTitle:@"Enter Roon Display URL"
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    // Предзаполняем текущий URL если есть
    NSString *currentURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedRoonURL"];
    if (!currentURL || [currentURL isEqualToString:@""]) {
        currentURL = @"http://192.168.21.11:9330/display/";
    }
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeURL;
        textField.placeholder = @"Enter Roon Web Display URL";
        textField.text = currentURL; // Предзаполняем текущим URL
        textField.textColor = [UIColor blackColor];
        textField.backgroundColor = [UIColor whiteColor];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField addTarget:self
                      action:@selector(alertTextFieldShouldReturn:)
            forControlEvents:UIControlEventEditingDidEnd];
    }];
    
    UIAlertAction *loadAction = [UIAlertAction
                                actionWithTitle:@"Load"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    UITextField *urltextfield = alertController.textFields[0];
                                    NSString *toMod = [urltextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    
                                    if (![toMod isEqualToString:@""]) {
                                        [self loadURL:toMod];
                                    }
                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:nil];
    
    [alertController addAction:loadAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextField *urltextfield = alertController.textFields[0];
            [urltextfield becomeFirstResponder];
            // Выделяем весь текст для удобства редактирования
            [urltextfield selectAll:nil];
        });
    }];
}

- (void)showQuickMenu {
    // Получаем текущий URL
    NSString *currentURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedRoonURL"];
    if (!currentURL || [currentURL isEqualToString:@""]) {
        currentURL = @"http://192.168.21.11:9330/display/";
    }
    
    // Создаем сообщение с текущим URL
    NSString *message = [NSString stringWithFormat:@"%@", currentURL];
    
    UIAlertController *alertController = [UIAlertController
                                         alertControllerWithTitle:@"Quick Menu"
                                         message:message  // Добавляем IP в сообщение
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *inputAction = [UIAlertAction
                                 actionWithTitle:@"Set Roon URL"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action) {
                                     [self showSetRoonURLMenu];
                                 }];
    
    UIAlertAction *defaultURLAction = [UIAlertAction
                                      actionWithTitle:@"Load Default URL"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action) {
                                          NSString *defaultURL = @"http://192.168.21.11:9330/display/";
                                          [self loadURL:defaultURL];
                                      }];
    
    UIAlertAction *reloadAction = [UIAlertAction
                                  actionWithTitle:@"Reload Page"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action) {
                                      [self.webview reload];
                                  }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:nil];
    
    UIAlertAction *clearCacheAction = [UIAlertAction
                                      actionWithTitle:@"Clear Cache"
                                      style:UIAlertActionStyleDestructive
                                      handler:^(UIAlertAction *action) {
                                          [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          [self.webview reload];
                                      }];
    
    UIAlertAction *clearCookiesAction = [UIAlertAction
                                        actionWithTitle:@"Clear Cookies"
                                        style:UIAlertActionStyleDestructive
                                        handler:^(UIAlertAction *action) {
                                            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                            for (NSHTTPCookie *cookie in [storage cookies]) {
                                                [storage deleteCookie:cookie];
                                            }
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            [self.webview reload];
                                        }];
    
    [alertController addAction:inputAction];
    [alertController addAction:defaultURLAction];
    
    NSURLRequest *request = [self.webview request];
    if (request != nil && ![request.URL.absoluteString isEqualToString:@""]) {
        [alertController addAction:reloadAction];
    }
    
    [alertController addAction:clearCacheAction];
    [alertController addAction:clearCookiesAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WebView Delegate

- (void)webView:(id)webView didFailLoadWithError:(NSError *)error {
    if (error.code != 999 && error.code != 204) { // Ignore specific error codes
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.presentedViewController == nil) {
                UIAlertController *alertController = [UIAlertController
                                                     alertControllerWithTitle:@"Could Not Load Roon Display URL"
                                                     message:error.localizedDescription
                                                     preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *reloadAction = [UIAlertAction
                                              actionWithTitle:@"Reload Page"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  [self.webview reload];
                                              }];
                
                UIAlertAction *newurlAction = [UIAlertAction
                                              actionWithTitle:@"Set a New URL"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  [self showSetRoonURLMenu];
                                              }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                              actionWithTitle:@"Dismiss"
                                              style:UIAlertActionStyleCancel
                                              handler:nil];
                
                NSURLRequest *request = [self.webview request];
                if (request != nil && ![request.URL.absoluteString isEqualToString:@""]) {
                    [alertController addAction:reloadAction];
                } else {
                    [alertController addAction:newurlAction];
                }
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }
}

- (void)alertTextFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (id)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - Input Handling

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (presses.anyObject.type == UIPressTypePlayPause) {
        UIView *firstResponder = [self findFirstResponder];
        
        if (firstResponder && [firstResponder isKindOfClass:[UITextField class]]) {
            [firstResponder resignFirstResponder];
            return;
        }
        
        UIViewController *presentedVC = self.presentedViewController;
        if (presentedVC) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showQuickMenu];
        });
    }
    
    [super pressesEnded:presses withEvent:event];
}

@end
