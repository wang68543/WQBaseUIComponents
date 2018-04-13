# WQBaseUIComponents
基础组件(自定义UI)
### 支持CocoaPods'
    pod 'WQBaseUIComponents',~>'0.1.6'
---
#### 1.五星评分
><small>支持任意大小的五角星形状，也支持使用图片</small>

```objective-c
 WQStarLevel *starLevel = [[WQStarLevel alloc] init];
[starLevel addTarget:self action:@selector(satrValueChanged:) forControlEvents:UIControlEventValueChanged];
starLevel.half = YES;
[self.StarContentView addSubview:starLevel];
starLevel.backgroundColor = [UIColor whiteColor];
starLevel.starHeight = 40;
```
#### 2.标题与图片位置任意方向排列的按钮
><small>支持本身的自带布局属性</small>

```objective-c
WQEdgeTitleButton *edgeTitle = [[WQEdgeTitleButton  alloc] init];
edgeTitle.titleAliment = ButtonTitleAlimentTop;
edgeTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
edgeTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
edgeTitle.frame = CGRectMake(20, 300, 280 , 120);
```

#### 3.单独页面键盘监听
><small>自动处理界面输入框的键盘这档问题以及便捷的取出输入框的值</small>

```objective-c
_keyboardAdjust = [WQKeyboardAdjustHelp keyboardAdjustWithMoveView:self.scrollView gestureRecognizerView:self.view];
_keyboardAdjust.delegate = self;
```
 当给输入框设置一个dataKey的时候`` [_keyboardAdjust allTFViewsValue]`` 可以一次性获取到moveView上面所有可编辑输入框的以dataKey为key的Value
