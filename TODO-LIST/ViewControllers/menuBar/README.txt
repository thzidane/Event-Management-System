12/1
    gesture增加，tap取消


11/29
    取消了gesture的手势，为了避免和主界面delegate和gesture的冲突，有时间再改进
    所以
    打开和关闭的方法就是menuButton的点击
    [self toggleMenu]




11/24
    基本搞定了这个MENU BAR, 还有图标的样式没弄好，不过可以外部传递NSMutableArray的形式
    使用方法：
        1. import这个文件夹到你的project
        2. 主VC里h文件
                import其header文件，并修改interface
                @interface ViewController : UIViewController <menuBarDelegate>
                {
                    menuBarController *menuBar;
                }
            m文件
                - (void)viewDidLoad
                {
                    [super viewDidLoad];
                    // Do any additional setup after loading the view.
                    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"], 
                                           [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
                    menuBar = [[menuBarController alloc] initWithImages:imageList];
                    menuBar.delegate = self;
                    
                }

                - (void)viewDidAppear:(BOOL)animated
                {
                    [super viewDidAppear:animated];
                    
                    [menuBar insertMenuButtonOnView:self.view atPosition:CGPointMake(10, 50)];
                    //[menuBar showMenu];
                }

		- (void)menuButtonClicked:(int)index
		{
   		// Execute what ever you want
    		NSLog(@"index = %d", index);
		}



        3. 要打开menu的话，一是可以点那个menu按钮，二是可以直接[menuBar showMenu], 三是考虑手势滑。
	4. Over