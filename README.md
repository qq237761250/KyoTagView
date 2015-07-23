# KyoTagView
带边框的TagView

# 创建方式：

1.通过xib或storyboard拖拽一个UIView，设置其Class为KyoTagView，最后通过Kyo Tag View属性栏设置其属性。

2.通过代码创建

  KyoTagView *tagView = [[KyoTagView alloc] initWithTitle:@"代码创建" withFrame:CGRectMake(200, 200, 56, 28)];
    [self.view addSubview:tagView];
