# UIView详解

## 概述

视图是应用程序中用户界面的基本组成部分，`UIView`类定义了所有视图的通用行为。视图在其边界矩形内呈现内容，并处理与该内容有关的任何交互。`UIView`类是一个具体类，可以使用其实例对象来显示一个固定的背景颜色，也可以子类化`UIView`来绘制更复杂的内容。要展示应用程序中常见的标签、图像、 按钮 和其它界面元素，应首先选择使用UIKit框架提供的视图子类。

视图对象是应用程序与用户交互的主要方式，其主要职责有：
- 绘制图形和执行动画
    - 使用UIKit框架或者Core Graphics框架在视图的矩形区域中绘制内容。
    - 视图的一些属性值可以用来执行动画。
- 布局和管理子视图
    - 视图可能包含多个子视图。
    - 视图可以调整子视图的大小和位置。
    - 使用Auto Layout定义调整视图大小和重新定位视图的规则，并以此规则来响应视图层的更改。
- 事件处理
    - 视图对象是`UIResponder`类的子类对象，能够响应触摸事件和其它类型的事件。
    - 视图可以附加手势识别器来处理常见的手势。

## 创建和管理视图层次结构

管理视图层次结构是开发应用程序用户界面的关键部分，视图层次结构会影响应用程序用户界面的外观以及应用程序如何响应更改和事件。下图显示了时钟应用程序的视图层次结构，标签栏和导航视图是标签栏和导航视图控制器对象提供的特殊视图层次结构，用于管理整个用户界面的各个部分。

![图2-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/Art/windowlayers.jpg)

### 添加和移除视图

Interface Builder是创建视图层次结构最便捷的方式，因为我们可以使用图形方式来组装视图，查看视图之间的关系，并确切了解在运行时将如何显示这些视图。如果以编程方式创建视图，可以使用以下方法来排列视图层次结构：
- 要将子视图添加到父视图，请调用父视图的`addSubview:`方法，此方法将子视图添加到父级子视图层的最上层。
- 要在父视图和子视图中间插入子视图，请调用父视图的任一`insertSubview:...`方法，此方法会将子视图插入到父视图和给定子视图之间的视图层的最上层。
- 要对父视图中的现有子视图进行重新排列，请调用父视图的`bringSubviewToFront:`、`sendSubviewToBack:`或者`exchangeSubviewAtIndex:withSubviewAtIndex:`方法，使用这些方法比删除子视图并重新插入它们效率要快。
- 要从父视图移除子视图，请调用**子视图**的`removeFromSuperview`方法。

子视图的`frame`属性值决定了视图在其父视图坐标系中的原点和尺寸，`bounds`属性值决定了视图的内部尺寸。默认情况下，当子视图的可见区域超出其父视图的矩形区域时，不会对子视图内容作裁剪，但可以设置父视图对象的`clipsToBounds`属性值来更改默认行为。

可以在视图控制器的`loadView`或者`viewDidLoad`方法中添加子视图到当前视图层。如果是以编程方式创建视图，则在视图控制器的`loadView`方法中创建添加视图。无论是以编程方式创建视图还是从**nib文件**中加载视图，都可以放在视图控制器的`viewDidLoad`方法中执行。

将子视图添加到另一个视图时，UIKit会通知父视图和子视图。在实现自定义视图时，可以通过覆写`willMoveToSuperview:`、`willMoveToWindow:`、`willRemoveSubview:`、`didAddSubview:`、`didMoveToSuperview`或者`didMoveToWindow`方法中一个或者多个来拦截这些通知。可以使用这些通知来更新与视图层次结构相关的任何状态信息或者执行其它任务。

### 隐藏视图

要以可视化方式隐藏视图，可以将视图的`hidden`属性值设为`YES`或者将其`alpha`属性值设为`0.0`。被隐藏的视图不会从系统接收到触摸事件，但是可以参与与视图层次结构相关的自动调整和其它布局操作。如果想要动画隐藏或呈现视图，必须使用视图的`alpha`属性，`hidden`属性不支持动画。

### 在视图层中定位视图

在视图层中定位视图有2种方法：
- 在适当位置存储视图对象的指针，例如在拥有此视图的视图控制器中。
- 为每个视图的`tag`属性分配一个**唯一的整数**，并调用其父视图或者其父视图的更下层父视图的`viewWithTag:`方法来定位它。

`viewWithTag:`方法会从调用该方法的视图的视图分支遍历视图获取对应`tag`值的视图，在使用该方法定位视图时，调用其父视图的`viewWithTag:`方法比调用其父视图的更下层父视图的`viewWithTag:`方法的效率要快。

### 平移、 缩放和旋转视图

每个视图对象都关联有一个`transform`仿射变换属性，可以通过配置`transform`属性值来平移、 缩放和旋转视图的内容。`UIView`的`transform`属性包含一个`CGAffineTransform`结构体，默认情况下，不会修改视图的外观。我们可以随时分配一个新的转换，例如将视图旋转45度，可以使用以下代码：
```
CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI/4.0);

self.view.transform = xform;
```
将多个转换同时应用于视图时，将这些转换添加到`CGAffineTransform`结构体的顺序非常重要。先旋转视图然后平移视图与先平移视图然后旋转视图的最终效果是不一样的，即使在每种情况下旋转和平移的数值都是一样的。此外，任何转换都是相对于视图的中心点而变换的。缩放和旋转视图时，不会改变视图的中心点。有关创建和使用仿射变换的更多信息，可以参看[Quartz 2D Programming Guide](https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html#//apple_ref/doc/uid/TP30001066)中的[Transforms](https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_affine/dq_affine.html#//apple_ref/doc/uid/TP30001066-CH204).

### 坐标转换

在某些情况下，特别是在处理触摸事件时，应用程序可能需要将视图的坐标参考系从一个视图转移到另一个视图。例如触摸事件会报告每次触摸在`window`坐标系中位置，但通常我们只需要视图在其所在视图层分支中的视图坐标系中的位置。`UIView`类定义了以下转换视图坐标参考系的方法：
- `convertPoint:fromView:`
- `convertRect:fromView:`
- `convertPoint:toView:`
- `convertRect:toView:`

`convert...:fromView:`方法将坐标点的坐标参考系从给定视图的坐标系转换为调用此方法的视图的局部坐标系，而`convert...:toView:`则将坐标点的坐标参考系从调用此方法的视图的局部坐标系转换为给定视图的坐标系。如果这两类方法的给定参考视图为`nil`，则会自动指定参考视图为当前视图所在的`window`。

`UIWindow`也定义了几种转换坐标参考系的方法：
- `convertPoint:fromWindow:`
- `convertRect:fromWindow:`
- `convertPoint:toWindow:`
- `convertRect:toWindow:`

在被旋转过的视图中转换坐标时，UIKit会假定一个大小刚好包含此被旋转过视图的屏幕区域为坐标点的坐标参考系，如下图所示：

![图2-2](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/Art/uiview_convert_rotated.jpg)

## 在运行时调整视图的大小和位置

每当视图的大小发生变化时，其子视图的大小和位置都必须相应地改变。`UIView`类支持视图层中的视图自动和手动布局。通过自动布局，我们可以设置每个视图在其父视图调整大小时应遵循的布局规则，使其可以自动调整大小和位置。通过手动布局，我们可以根据需要手动调整视图的大小和位置。

### 布局更改

视图发生以下任何更改时，可能会使视图的布局发生更改：
- 视图边界矩形的大小发生变化。
- 屏幕方向的变换，通常会使根视图的边界矩形发生更改。
- 与视图的图层相关联的核心动画子图层组发生更改，并且需要布局。
- 调用视图的`setNeedsLayout`或者`layoutIfNeeded`方法来强制执行布局。
- 调用视图图层的`setNeedsLayout`方法来强制布局。

### 自动调整视图布局

当视图的大小发生更改时，通常需要更改其子视图的位置和大小以适配其父视图的大小。父视图的`autoresizesSubviews`属性决定子视图是否调整大小，如果此属性值为`YES`，则该父视图会根据其子视图的`autoresizingMask`属性来确定如何调整和定位该子视图。对任何子视图的大小进行更改也会触发子视图的子视图的布局调整。

对于视图层中的每个视图，要使其支持自动布局，就必须将其`autoresizingMask`属性设置为合适的值。下表列出了可应用于视图的自动调整布局选项，并描述了其在布局操作期间所起的效果。为`autoresizingMask`属性分配值时，可以使用**OR运算符组合这些常量**，或者将这些常量相加后再赋值。

| Autoresizing mask | 描述 |
| --------------------- | ------ |
| UIViewAutoresizingNone | 视图不会自动调整大小(默认值) |
| UIViewAutoresizingFlexibleHeight | 根据需要调整视图的高度，以保证上边距和下边距不变。 |
| UIViewAutoresizingFlexibleWidth | 根据需要调整视图的宽度，以保证左边距和右边距不变。 |
| UIViewAutoresizingFlexibleLeftMargin | 视图左边距根据需要增大或减小，以保证视图右边距不变。 |
| UIViewAutoresizingFlexibleRightMargin | 视图右边距根据需要增大或减小，以保证视图左边距不变。 |
| UIViewAutoresizingFlexibleBottomMargin | 视图下边距根据需要增大或减小，以保证视图上边距不变。 |
| UIViewAutoresizingFlexibleTopMargin | 视图上边距根据需要增大或减小，以保证视图下边距不变。 |

![图3-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/Art/uiview_autoresize.jpg)

### 手动调整视图布局

当视图的大小更改时，UIKit就会应用其子视图的自动调整行为，之后会调用视图的`layoutSubviews`方法。当自定义视图的子视图的自动调整行为不能满足我们的需要时，可以实现该自定义视图的`layoutSubviews`方法并在其中执行以下任何操作：
- 调整任何子视图的大小和位置。
- 添加或删除子视图或者核心动画图层。
- 通过调用子视图的`setNeedsDisplay`或者`setNeedsDisplayInRect:`方法强制其执行重绘。
- 在实现一个大的可滚动区域时，经常需要手动布局子视图。由于直接用一个足够大的视图来呈现可滚动内容是不切实际的，所以应用程序通常会实现一个根视图，其中包含许多较小的视图块。每个小视图块代表可滚动内容的一部分。当滚动事件发生时，根视图调用其`setNeedsLayout`方法来执行重绘，之后调用`layoutSubviews`方法并在该方法中根据发生的滚动量重新定位平铺小视图块。

## 与核心动画图层进行交互

每个视图对象都拥有一个用于管理屏幕上视图内容的显示和动画的核心动画图层。虽然我们可以使用视图对象做很多事情，但也可以根据需要直接使用其图层对象。视图的图层对象存储在视图的`layer`属性中。

### 更改与视图关联的图层对象的所属类型

与视图关联的图层对象所属类型在创建视图之后就无法被更改了，所以视图使用`layerClass`类方法来指定其图层对象的所属类。此方法的默认实现返回`CALayer`类，更改此方法返回值的唯一方法就是子类化`UIView`并重写该方法返回一个不同的类。例如，如果使用平铺来显示大的可滚动区域，则可能需要使用`CATiledLayer`类来支持视图，代码如下：
```
+ (Class)layerClass
{
    return [CATiledLayer class];
}
```
视图会在其初始化前先调用其`layerClass`类方法，并使用返回的类来创建其图层对象。另外，视图总是将自己指定为其图层对象的委托对象。视图持有图层，视图和图层之间的关系不能改变，也不能在指定该视图为另一个图层对象的委托对象。否则，会导致绘制图形时出问题，应用程序有可能崩溃。

有关**Core Animation**提供的不同类型的图层对象的更多信息，可以参看[Core Animation Reference Collection](https://developer.apple.com/documentation/quartzcore)。

### 在视图中嵌入图层对象

如果要使用图层对象而不用视图，则可以根据需要将自定义图层对象添加到图层中。自定义图层对象是属于`CALayer`类的任何实例，通常以编程方式来创建自定义图层，并使用Core Animation的规则将其合并。自定义图层不会接收到事件，也不会参与响应者链，但能根据Core Animation的规则绘制自己的图形并响应其父视图或父图层中的大小更改。

使用自定义图层对象显示静态图片的代码如下：

```
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create the layer.
    CALayer* myLayer = [[CALayer alloc] init];

    // Set the contents of the layer to a fixed image. And set
    // the size of the layer to match the image size.
    UIImage layerContents = [[UIImage imageNamed:@"myImage"] retain];
    CGSize imageSize = layerContents.size;

    myLayer.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    myLayer = layerContents.CGImage;

    // Add the layer to the view.
    CALayer*    viewLayer = self.view.layer;
    [viewLayer addSublayer:myLayer];

    // Center the layer in the view.
    CGRect        viewBounds = backingView.bounds;
    myLayer.position = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));

    // Release the layer, since it is retained by the view's layer
    [myLayer release];
}
```
可以添加任意数量的子图层到视图的图层，有关如何直接使用图层的信息，可以参看[Core Animation Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514)。

## 视图绘图周期

当首次显示视图时，或者由于布局更改而全部或部分视图变为可见时，系统会调用视图的`drawRect:`方法来绘制其内容。可以在此方法中将视图的内容绘制到当前图形上下文中，该图形上下文在调用此方法之前由系统自动设置。**注意，系统每次设置当前图形上下文可能并不相同，所以在每次绘制时，需要使用`UIGraphicsGetCurrentContext`方法来重新获取当前图形上下文。**

当视图的实际内容发生变化时，需要调用视图的`setNeedsDisplay`或者`setNeedsDisplayInRect:`方法来通知系统当前视图需要重新绘制。这些方法会标记当前视图需要更新，系统会在下一个绘图周期中更新视图。由于在调用这些方法后，系统会等到下一个绘图周期才更新视图，所以可以在多个视图中调用这些方法来同时更新它们。

**注意：如果使用OpenGL ES来执行绘图，则应使用`GLKView`类，有关如何使用OpenGL ES进行绘制的更多信息，可以参看[OpenGL ES Programming Guide](https://developer.apple.com/library/content/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008793)。**

## 动画更改视图的属性

视图的`frame`、`bounds`、`center`、`transform`、`alpha`和`backgroundColor`属性是可以用来执行动画。

### 使用基于Block的方法执行动画

iOS 4 以后，可以使用使用基于Block的方法来执行动画。有以下几种基于Block的方法为动画块提供不同级别的配置：
- `animateWithDuration:animations:`
- `animateWithDuration:animations:completion:`
- `animateWithDuration:delay:options:animations:completion`

这些方法都是类方法，使用它们创建的动画块不会绑定到单个视图。因此，可以使用这些方法创建一个包含对多个视图进行更改的动画。例如，在某个时间段淡入淡出执行视图显示和隐藏动画。其代码如下：
```
[UIView animateWithDuration:1.0 animations:^{

    firstView.alpha = 0.0;
    secondView.alpha = 1.0;
}];
```
程序执行以上代码时，会在另一个线程执行指定的动画，以避免阻塞当前线程或应用程序的主线程。

如果要更改默认的动画参数，则必须使用`animateWithDuration:delay:options:animations:completion`方法来执行动画。可以通过该方法来自定义以下动画参数：
- 延迟开始执行的动画的时间
- 动画时使用的时间曲线的类型
- 动画重复执行的次数
- 当动画执行到最后时，动画是否自动反转
- 在动画执行过程中，视图是否能接收触摸事件
- 动画是否应该中断任何正在执行的动画，或者等到正在执行的动画完成之后才开始

另外，`animateWithDuration:animations:completion:`和`animateWithDuration:delay:options:animations:completion`方法可以指定动画完成后的执行代码块，可以在块中将单独的动画链接起来。例如，第一次调用`animateWithDuration:delay:options:animations:completion`方法设置一个淡出动画，并配置一些动画参数。当动画完成后，在动画完成后的执行代码块中延迟执行淡入动画。其代码如下：
```
// Fade out the view right away
[UIView animateWithDuration:1.0
                      delay:0.0
                    options:UIViewAnimationOptionCurveEaseIn
animations:^{

    thirdView.alpha = 0.0;

}completion:^(BOOL finished){

    // Wait one second and then fade in the view
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseOut
    animations:^{

        thirdView.alpha = 1.0;

    }completion:nil];
}];
```
> **重要：当正在对视图的某个属性执行动画时，此时更改该属性值不会停止当前动画。相反，当前动画会继续执行，并动画到刚分配给该属性的新值。**

### 使用Begin/Commit方法执行动画

iOS 4 之前，只能使用`UIView`类的`beginAnimations:context:`和`commitAnimations`类方法来定义动画块，这两个方法用来标记动画块的开始和结束。在调用`commitAnimations`方法之后，在这两个方法之间更改的任何动画属性都会动画过渡到其新值。动画会在辅助线程上执行，以避免阻塞当前线程或应用程序的主线程。

使用Begin/Commit方法在某个时间段淡入淡出执行视图显示和隐藏动画。其代码如下：
```
[UIView beginAnimations:@"ToggleViews" context:nil];
[UIView setAnimationDuration:1.0];

// Make the animatable changes.
firstView.alpha = 0.0;
secondView.alpha = 1.0;

// Commit the changes and perform the animation.
[UIView commitAnimations];
```
默认情况下，在动画块中的所有动画属性更改都是动画过渡的。如果想让某些属性更改不支持动画过渡，可以先调用`setAnimationsEnabled:`来临时禁用动画，然后执行不需要动画过渡的更改。之后，再次调用`setAnimationsEnabled:`方法重新启用动画。可以通过调用`areAnimationsEnabled`类方法来判断动画是否被启用。

> **注意：当正在对视图的某个属性执行动画时，此时更改该属性值不会停止当前动画。相反，当前动画会继续执行，并动画到刚分配给该属性的新值。**

可以使用以下类方法为Begin/Commit动画块配置动画参数：
- `setAnimationStartDate:`：设置开始执行动画的时间。如果设置的日期是过去时间，则会立即执行动画。
- `setAnimationDelay:`：设置当前时间延迟多少秒后开始执行动画。
- `setAnimationDuration:`：设置动画时长。
- `setAnimationCurve:`：设置动画时使用的时间曲线的类型。
- `setAnimationRepeatCount:`：设置动画重复次数。
- `setAnimationRepeatAutoreverses:`：设置动画完成后是否自动反转。

如果想要在动画开始前或完成后执行某些操作，则必须将委托对象和操作方法与动画块关联起来。使用`UIView`类的`setAnimationDelegate:`类方法设置委托对象，并使用`setAnimationWillStartSelector:`和`setAnimationDidStopSelector:`类方法来设置动画开始前和完成后要执行的方法。系统会在适当的时候调用委托方法，让我们有机会执行需要执行的代码。

动画委托方法的方法名类似于一下：
```
- (void)animationWillStart:(NSString *)animationID context:(void *)context;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
```
这两个方法的`animationID`和`context`参数与调用`beginAnimations:context:`方法开启动画时传入的参数相同：
- `animationID`——用于识别动画的字符串。
- `context`——使用该上下文对象传递信息给委托对象。

调用`setAnimationDidStopSelector:`类方法关联的动画停止时执行的方法有一个额外的`finished`参数，其是一个布尔值。如果动画运行完成，为`YES`。如果动画被其他动画提前取消或停止，则为`NO`。

### 嵌套动画块

可以通过在动画块内嵌套其他动画块来为动画块的某些部分分配不同的时序和配置选项。嵌套动画会与任何父动画同时启动，但根据它们各自的配置参数来执行。默认情况下，嵌套动画会继承父级动画的持续时间和动画曲线，但可以根据需要重置嵌套动画的这些选项。

以下代码展示了一个如何使用嵌套动画块来改变动画组中的某些动画的开启时间，持续时间和行为的例子。有两个视图正在被淡化为完全透明，但其中一个视图的透明度会在动画结束前来回多次改变。在嵌套动画块中配置的`UIViewAnimationOptionOverrideInheritedCurve`和`UIViewAnimationOptionOverrideInheritedDuration`参数将允许嵌套动画使用自己的动画曲线和持续时间值。如果没有配置这些参数，嵌套动画将使用父级动画块的动画曲线和持续时间。

```
[UIView animateWithDuration:1.0
                      delay:1.0
                    options:UIViewAnimationOptionCurveEaseOut
                 animations:^{

    aView.alpha = 0.0;

    // Create a nested animation that has a different
    // duration, timing curve, and configuration.
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionOverrideInheritedCurve |
                                UIViewAnimationOptionCurveLinear |
                                UIViewAnimationOptionOverrideInheritedDuration |
                                UIViewAnimationOptionRepeat |
                                UIViewAnimationOptionAutoreverse
    animations:^{

        [UIView setAnimationRepeatCount:2.5];
        
        anotherView.alpha = 0.0;
    }
    completion:nil];
}
completion:nil];
```
如果是使用Begin/Commit方法创建动画，其嵌套使用与基于Block的方法类似。在已经创建的动画块中调用`beginAnimations:context:`方法继续创建一个新的动画块，并根据需要进行配置。任何配置更改都适用于最新创建的动画块。在提交和执行动画前，所有嵌套动画块都必须调用`commitAnimations`方法提交动画。

### 反转动画

创建可重复执行的可反转动画时，要注意将重复次数指定为非整数值。对于可反转动画，每个动画周期内都包含从原始值到新值，然后再还原为原始值的动画。如果希望动画在新值上结束，则重复执行次数要加0.5以增加半个额外动画周期。


## 视图过渡转换动画

视图过渡转换可以隐藏在视图层中添加、删除或显示视图带来的视觉上的突然变化。可以使用视图过渡转换来实现以下类型的更改：
- 更改现有视图的可见子视图，使父视图在不同状态之间切换。
- 当想使界面有很大的改变时，使用不同的视图替换视图层中的某个视图。

> **注意：不要将视图转换与视图控制器的跳转相混淆，视图转换仅影响视图层。**

### 更改视图的子视图

在iOS 4之后，使用`transitionWithView:duration:options:animations:completion:`方法为视图启动过渡动画。通常情况下，在此方法指定的动画块中，应执行与显示、隐藏、添加或者删除子视图相关的动画。这样就能允许视图对象创建视图在更改之前和更改之后的截图，并且会在这两张截图之间创建动画。这种方式更加高效，但是，如果还需要对其他更改执行动画，则可以在调用此方法时配置`UIViewAnimationOptionAllowAnimatedContent`选项，这样就可以防止视图对象创建截图，并直接对所有更改执行动画。

以下代码是如何使用过渡转换动画使用户界面看起来好像添加了新的文本输入页面的示例。用户界面包含两个嵌入的文本视图，文本视图的配置相同，但其中一个始终可见，另一个隐藏。当永华点击按钮创建一个新页面时，这个方法切换了两个视图的可见性，导致一个空的文本视图的新空白页面准备接收文本。转换完成后，视图使用私有方法保存旧页面中的文本，并重置现在隐藏的文本视图，以便稍后重新使用。
```
- (IBAction)displayNewPage:(id)sender
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
    animations:^{

        currentTextView.hidden = YES;
        swapTextView.hidden = NO;
        
    }completion:^(BOOL finished){

        // Save the old text and then swap the views.
        [self saveNotes:temp];

        UIView*    temp = currentTextView;
        currentTextView = swapTextView;
        swapTextView = temp;
    }];
}
```
iOS 4之前的版本可以使用`setAnimationTransition:forView:cache:`方法执行视图转换动画，代码如下：
```
[UIView beginAnimations:@"ToggleSiblings" context:nil];
[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
[UIView setAnimationDuration:1.0];

// Make your changes


[UIView commitAnimations];
```
另外，还需要设置好委托对象和动画停止后执行的回调方法。

### 用不同的视图替换视图层中的某个视图

iOS 4之后，使用`transitionFromView:toView:duration:options:completion:`方法在两个视图间过渡转换。此方法实际上是从当前视图层中删除第一个视图，然后插入另一个视图。如果要隐藏视图而不是从视图层中删除视图，可以在调用此方法时配置`UIViewAnimationOptionShowHideTransitionViews`选项。

以下代码展示了如何在单个视图控制器管理的两个主视图之间交换显示。视图控制器的根视图总是显示两个子视图中的一个，每个视图呈现的内容相同，但界面布局不同。视图控制器使用`displayingPrimary`成员变量(布尔值)来跟踪在任何给定时间显示哪个视图。翻转方向根据正在显示的视图而改变。
```
- (IBAction)toggleMainViews:(id)sender {

    [UIView transitionFromView:(displayingPrimary ? primaryView : secondaryView)
                        toView:(displayingPrimary ? secondaryView : primaryView)
                      duration:1.0
                       options:(displayingPrimary UIViewAnimationOptionTransitionFlipFromRight :
                       UIViewAnimationOptionTransitionFlipFromLeft)
    completion:^(BOOL finished) {
                    
        if (finished)
        {
            displayingPrimary = !displayingPrimary;
        }
    }];
}
```
> **注意：除了交换视图之外，还需要在视图控制器中执行代码来管理主视图和辅助视图的加载和卸载。有关如何通过视图控制器加载和卸载视图的信息，可以参看[View Controller Programming Guide for iOS](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457)。**

## 视图和视图的图层一起动画更改

应用程序可以根据需要自由地混合基于视图和基于图层的动画代码，但配置动画参数的过程取决于谁拥有图层。更改视图拥有的图层与更改视图本身相同，并且应用于图层属性的任何动画都根据当前基于视图的动画块的动画参数来执行。自定义图层对象会忽略基于视图的动画块参数，而是使用默认的Core Animation参数。

如果要为所创建的图层自定义动画参数，则必须直接使用Core Animation。通常，使用Core Animation动画化图层需要创建一个`CABasicAnimation`对象或者`CAAnimation`的其他子类对象，然后将该动画对象添加到相应的图层。

以下代码实现了一个动画，其同时修改一个视图和一个自定义图层。视图在其边界的中心包含一个自定义`CALayer`对象。动画顺时针旋转视图，同时逆时针旋转图层。由于旋转方向相反，图层相对于屏幕保持其原始角度，看上去并没有旋转。
```
[UIView animateWithDuration:1.0
                      delay:0.0
                    options:UIViewAnimationOptionCurveLinear
animations:^{
                 
    // Animate the first half of the view rotation.
    CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-180));
    backingView.transform = xform;

    // Rotate the embedded CALayer in the opposite direction.
    CABasicAnimation*    layerAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    layerAnimation.duration = 2.0;
    layerAnimation.beginTime = 0; //CACurrentMediaTime() + 1;
    layerAnimation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    layerAnimation.timingFunction = [CAMediaTimingFunction
    functionWithName:kCAMediaTimingFunctionLinear];
    layerAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    layerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360.0)];
    layerAnimation.byValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180.0)];
    [manLayer addAnimation:layerAnimation forKey:@"layerAnimation"];
    
}completion:^(BOOL finished){
    // Now do the second half of the view rotation.
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
    animations:^{
                     
        CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-359));
        backingView.transform = xform;
                     
    }completion:^(BOOL finished){

        backingView.transform = CGAffineTransformIdentity;
    }];
}];
```
> **注意：也可以在基于视图的动画块之外创建并应用`CABasicAnimation`对象，以获得相同的结果。所有的动画最终都依靠Core Animation来执行。因此，如果动画几乎被同时提交，它们就会一起执行。**


## 其他

**对应用程序用户界面的操作必须在主线程上执行，也就是说必须在主线程中执行`UIView`类的方法。创建视图对象不一定要放在主线程，但其他所有操作都应该在主线程上进行。**

自定义打印输出视图信息，可以实现`drawRect:forViewPrintFormatter:`方法。有关如何支持打印输出视图的详细信息，可以参看[Drawing and Printing Guide for iOS](https://developer.apple.com/library/content/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010156)。

## Demo

示例代码下载地址：https://github.com/zhangshijian/UIViewDemo
