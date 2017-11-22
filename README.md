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
- 调用视图的图层的`setNeedsLayout`方法来强制布局。



