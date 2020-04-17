# Flutter进阶：路由、路由栈详解及案例分析

## 路由初体验

路由（Routes）是什么？路由是屏幕或应用程序页面的抽象。

Flutter 使我们能够优雅地管理路由主要依赖的是 Navigator（导航器）类。这是一个用于管理一组具有某种进出规则的页面的 Widget，也就是说用它我们能够实现各个页面间有规律的切换。而这里的规则便是在其内部维护的一个“ 路由栈”。

学习 Android 的同学知道 Activity 的启动模式可以实现各种业务需求，iOS 中也有嵌套路由的功能，Flutter 作为最有潜力的跨平台框架当然要吸取众家之精华，它当然完全有能力实现原生的各种效果！

我们先尝试实现一个小的功能。

## 组件路由

当我们第一次打开应用程序，出现在眼前的便是路由栈中的第一个也是最底部实例：

```
void main() {
  runApp(MaterialApp(home: Screen1()));
}
```

要在堆栈上推送新的实例，我们可以调用导航器 `Navigator.push` ，传入当前 context 并且使用构建器函数创建 MaterialPageRoute 实例，该函数可以创建您想要在屏幕上显示的内容。 例如：

```
new RaisedButton(
   onPressed:(){
   Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('My Page')),
          body: Center(
            child: FlatButton(
              child: Text('POP'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    ));
   },
   child: new Text("Push to Screen 2"),
),
```

点击执行上方操作，我们将成功打开第二个页面。

## 命名路由

在一般应用中，我们用的最多的还是命名路由，它是将应用中需要访问的每个页面命名为不重复的字符串，我们便可以通过这个字符串来将该页面实例推进路由。

> 例如，’/ home’ 表示 HomeScreen， ‘/ login’ 表示 LoginScreen。 ‘/‘ 表示主页面。 这里的命名规范与 REST API 开发中的路由类似。 所以 ‘/‘ 通常表示的是我们的根页面。

请看下方案例：

```
new MaterialApp(
  home: new Screen1(),
  routes: <String, WidgetBuilder> {
    '/screen1': (BuildContext context) => new Screen1(),
    '/screen2' : (BuildContext context) => new Screen2(),
    '/screen3' : (BuildContext context) => new Screen3(),
    '/screen4' : (BuildContext context) => new Screen4()
  },
)
```

*Screen1()、Screen2()等是每个页面的类名。*

我们同样可以实现前面的功能：

```
new RaisedButton(
   onPressed:(){
     Navigator.of(context).pushNamed('/screen2');
   },
   child: new Text("Push to Screen 2"),
),
```

或者：

```
new RaisedButton(
   onPressed:(){
     Navigator.pushNamed(context, "/screen2")
   },
   child: new Text("Push to Screen 2"),
),
```

同样可以实现上方效果。

## Pop

实现上面两种方法，此时，路由栈中的情况如下：





1_RKtC1MKJbjSfMjUlR-2K7g

现在，当我们想要回退的到主屏幕时，我们则需要使用 pop 方法从 Navigator 的堆栈中弹出 Routes。

```
Navigator.of(context).pop();
```





1_hq7qfAer0wCCSyIBKr7sfg

使用 Scaffold 时，通常不需要显式弹出路径，因为 Scaffold 会自动向其 AppBar 添加一个“后退”按钮，按下时会调用 `Navigator.pop()`。

在 Android 中，按下设备后退按钮也会这样做。但是，我们也有可能需要将此方法用于其他组件，例如在用户单击“取消”按钮时弹出 AlertDialog。

> **这里要注意的是：**切勿用 push 代替 pop，有同学说我在 Screen2 push Screen1 部照样能实现这个功能吗？其实不然啊，请看下图：





1_Xsyo5c8s1JwO6f2OQ1nNEg

> 所以 **push 只用于向栈中添加实例，pop 弹出实例！（特殊需求除外）**

# 详解路由栈

前面，我们已经知道如何简单在路由栈中 push、pop 实例，然而，当遇到一些特殊的情况，这显然不能满足需求。学习 Android 的同学知道 Activity 的各种启动模式可以完成相应需求，Flutter 当然也有类似的可以解决各种业务需求的实现方式！

请看下面使用方法与案例分析。

## pushReplacementNamed 与 popAndPushNamed

```
RaisedButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, "/screen4");
  },
  child: Text("pushReplacementNamed"),
),
RaisedButton(
  onPressed: () {
    Navigator.popAndPushNamed(context, "/screen4");
  },
  child: Text("popAndPushNamed"),
),
```

*我们在 Screen3 页面使用 pushReplacementNamed 与 popAndPushNamed 方法 push 了 Screen4。*

此时路由栈情况如下：





1_cr77kgOgz7KRjwvMAVXoAg

**Screen4 代替了 Screen**。

`pushReplacementNamed` 与 `popAndPushNamed` 的区别在于： `popAndPushNamed` 能够执行 Screen2 弹出的动画与 Screen3 推进的动画而 `pushReplacementNamed` 仅显示 Screen3 推进的动画。





1_cr77kgOgz7KRjwvMAVXoAg

案例：

> **pushReplacementNamed**：当用户成功登录并且现在在 `HomeScreen` 上时，您不希望用户还能够返回到 `LoginScreen`。因此，登录应完全由首页替换。另一个例子是从 `SplashScreen` 转到 `HomeScreen`。 它应该只显示一次，用户不能再从 `HomeScreen` 返回它。 在这种情况下，由于我们要进入一个全新的屏幕，我们可能需要借助此方法。
>
> **popAndPushNamed**：假设您正在有一个 `Shopping` 应用程序，该应用程序在 `ProductsListScreen` 中显示产品列表，用户可以在 `FiltersScreen` 中应用过滤商品。 当用户单击“应用筛选”按钮时，应弹出 `FiltersScreen` 并使用新的过滤器值推回到 `ProductsListScreen`。 这里 `popAndPushNamed` 显然更为合适。

## pushNamedAndRemoveUntil

> 用户已经登陆进入 `HomeScreen` ，然后经过一系列操作回到配合只界面想要退出登录，你不能够直接 Push 进入 `LoginScreen` 吧？**你需要将之前路由中的实例全部删除是的用户不会在回到先前的路由中。**

pushNamedAndRemoveUntil 可实现该功能：

```
Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
```

这里的 `(Route<dynamic> route) => false` 能够确保删除先前所有实例。





Logging out removes all routes and takes user back to LoginScreen

现在又有一个需求：我们不希望删除先前所有实例，**我们只要求删除指定个数的实例**。

> 我们有一个需要付款交易的购物应用。在应用程序中，一旦用户完成了支付交易，就应该从堆栈中删除所有与交易或购物车相关的页面，并且用户应该被带到 `PaymentConfirmationScreen` ,单击后退按钮应该只将它们带回到 `ProductsListScreen` 或 `HomeScreen`：





1_aaZxoLUbKdFPgiIkBAmw7w

```
Navigator.of(context).pushNamedAndRemoveUntil('/screen4', ModalRoute.withName('/screen1'));
```

通过代码，我们推送 `Screen4` 并删除所有路由，直到 `Screen1`：





1_D81iZF-BikxXJHak7_NkhA

## popUntil

想象一下，我们在应用程序中要填写一系列信息，表单分布在多个页面中。假设需要填写三个页面的表单一步接着一步。 然而，在表单的第 3 部分，用户取消了填写表单。 用户单击取消并且应弹出所有之前与表单相关的页面，并且应该将用户带回 `HomeScreen` 或者 `DashboardScreen`，这种情况下数据属于数据无效！ 我们不会在这里推新任何新东西，只是回到以前的路由栈中。





1_qV7mF0Kow2zch-fjksmA_Q

```
Navigator.popUntil(context, ModalRoute.withName('/screen2'));
```

## Popup routes（弹出路由）

路由不一定要遮挡整个屏幕。 [PopupRoute](https://docs.flutter.io/flutter/widgets/PopupRoute-class.html)s 使用 [ModalRoute.barrierColor](https://docs.flutter.io/flutter/widgets/ModalRoute/barrierColor.html) 覆盖屏幕，[ModalRoute.barrierColor](https://docs.flutter.io/flutter/widgets/ModalRoute/barrierColor.html) 只能部分不透明以允许当前屏幕显示。 弹出路由是“模态”的，因为它们阻止了对下面其他组件的输入。

有一些方法可以创建和显示这类弹出路由。 例如：showDialog，showMenu 和 showModalBottomSheet。 如上所述，这些函数返回其推送路由的 Future（异步数据，参考下面的数据部分）。 执行可以等待返回的值在弹出路由时执行操作。

还有一些组件可以创建弹出路由，如 PopupMenuButton 和 DropdownButton。 这些组件创建 PopupRoute 的内部子类，并使用 Navigator 的 push 和 pop 方法来显示和关闭它们。

## 自定义路由

您可以创建自己的一个窗口z组件库路由类（如 PopupRoute，ModalRoute 或 PageRoute）的子类，以控制用于显示路径的动画过渡，路径的模态屏障的颜色和行为以及路径的其他各个特性。

PageRouteBuilder 类可以根据回调定义自定义路由。 下面是一个在路由出现或消失时旋转并淡化其子节点的示例。 此路由不会遮挡整个屏幕，因为它指定了opaque：false，就像弹出路由一样。

```
Navigator.push(context, PageRouteBuilder(
  opaque: false,
  pageBuilder: (BuildContext context, _, __) {
    return Center(child: Text('My PageRoute'));
  },
  transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: RotationTransition(
        turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
));
```





ezgif-3-14c32a6d8764

路由两部分构成，“pageBuilder”和“transitionsBuilder”。 该页面成为传递给 buildTransitions 方法的子代的后代。 通常，页面只构建一次，因为它不依赖于其动画参数（在此示例中以_和__表示）。 过渡是建立在每个帧的持续时间。

## 嵌套路由

一个应用程序可以使用多个路由导航器。将一个导航器嵌套在另一个导航器下方可用于创建“内部旅程”，例如选项卡式导航，用户注册，商店结帐或代表整个应用程序子部分的其他独立个体。

iOS应用程序的标准做法是使用选项卡式导航，其中每个选项卡都维护自己的导航历史记录。因此，每个选项卡都有自己的导航器，创建了一种“并行导航”。

除了选项卡的并行导航之外，还可以启动完全覆盖选项卡的全屏页面。例如：入职流程或警报对话框。因此，必须存在位于选项卡导航上方的“根”导航器。因此，每个选项卡的 Navigators 实际上都是嵌套在一个根导航器下面的 Navigators。

用于选项卡式导航的嵌套导航器位于 WidgetApp 和 [CupertinoTabView](https://docs.flutter.io/flutter/cupertino/CupertinoTabView-class.html) 中，因此在这种情况下您无需担心嵌套的导航器，但它是使用嵌套导航器的真实示例。

以下示例演示了如何使用嵌套的 Navigator 来呈现独立的用户注册过程。

尽管此示例使用两个 Navigators 来演示嵌套的 Navigators，但仅使用一个 Navigato r就可以获得类似的结果。

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...some parameters omitted...
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/signup': (BuildContext context) => SignUpPage(),
      },
    );
  }
}

class SignUpPage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   // SignUpPage builds its own Navigator which ends up being a nested
   // Navigator in our app.
   return Navigator(
     initialRoute: 'signup/personal_info',
     onGenerateRoute: (RouteSettings settings) {
       WidgetBuilder builder;
       switch (settings.name) {
         case 'signup/personal_info':
           // Assume CollectPersonalInfoPage collects personal info and then
           // navigates to 'signup/choose_credentials'.
           builder = (BuildContext _) => CollectPersonalInfoPage();
           break;
         case 'signup/choose_credentials':
           // Assume ChooseCredentialsPage collects new credentials and then
           // invokes 'onSignupComplete()'.
           builder = (BuildContext _) => ChooseCredentialsPage(
             onSignupComplete: () {
               // Referencing Navigator.of(context) from here refers to the
               // top level Navigator because SignUpPage is above the
               // nested Navigator that it created. Therefore, this pop()
               // will pop the entire "sign up" journey and return to the
               // "/" route, AKA HomePage.
               Navigator.of(context).pop();
             },
           );
           break;
         default:
           throw Exception('Invalid route: ${settings.name}');
       }
       return MaterialPageRoute(builder: builder, settings: settings);
     },
   );
 }
}
```

Navigator.of 在给定 BuildContext 中最近的根 Navigator 上运行。 确保在预期的 Navigator 下面提供BuildContext，尤其是在创建嵌套 Navigators 的大型构建方法中。 Builder 组件可用于访问组件子树中所需位置的 BuildContext。

# 页面间数据传递

## 数据传递

在上面的大多数示例中，我们推送新路由时没有发送数据，但在实际应用中这种情况应用很少。 要发送数据，我们将使用 Navigator 将新的 MaterialPageRoute 用我们的数据推送到堆栈上（这里是 `userName`）

```
String userName = "John Doe";
Navigator.push(
    context,
    new MaterialPageRoute(
        builder: (BuildContext context) =>
        new Screen5(userName)));
```

要在 `Screen5` 中得到数据，我们只需在 `Screen5` 中添加一个参数化构造函数：

```
class Screen5 extends StatelessWidget {

  final String userName;
  Screen5(this.userName);
  @override
  Widget build(BuildContext context) {
  print(userName)
  ...
  }
}
```

这表示我们不仅可以使用 `MaterialPageRoute` 作为 `push` 方法，还可以使用 `pushReplacement`，`pushAndPopUntil` 等。基本上从我们描述的上述方法中路由方法，第一个参数现在将采用 `MaterialPageRoute` 而不是 `namedRoute` 的 `String`。

## 数据返回

我们可能还想从新页面返回数据。 就像一个警报应用程序，并为警报设置一个新音调，您将显示一个带有音频音调选项列表的对话框。 显然，一旦弹出对话框，您将需要所选的项目数据。 它可以这样实现：

```
new RaisedButton(onPressed: ()async{
  String value = await Navigator.push(context, new MaterialPageRoute<String>(
      builder: (BuildContext context) {
        return new Center(
          child: new GestureDetector(
              child: new Text('OK'),
              onTap: () { Navigator.pop(context, "Audio1"); }
          ),
        );
      }
  )
  );
  print(value);

},
  child: new Text("Return"),)
```

*在 Screen4 中尝试并检查控制台的打印值。*

另请注意：当路由用于返回值时，路由的类型参数应与 pop 的结果类型匹配。 这里我们需要一个 String 数据，所以我们使用了 `MaterialPageRoute <String>`。 不指定类型也没关系。

# 其他效果解释

## maybePop

源码：

```
static Future<bool> maybePop<T extends Object>(BuildContext context, [ T result ]) {
    return Navigator.of(context).maybePop<T>(result);
  }

@optionalTypeArgs
  Future<bool> maybePop<T extends Object>([ T result ]) async {
    final Route<T> route = _history.last;
    assert(route._navigator == this);
    final RoutePopDisposition disposition = await route.willPop();
    if (disposition != RoutePopDisposition.bubble && mounted) {
      if (disposition == RoutePopDisposition.pop)
        pop(result);
      return true;
    }
    return false;
  }
```

如果我们在初始路由上并且有人错误地试图弹出这个唯一页面怎么办？ 弹出堆栈中唯一的页面将关闭您的应用程序，因为它后面已经没有页面了。这显然是不好的体验。 这就是 `maybePop()` 起的作用。 点击 `Screen1` 上的 `maybePop` 按钮，没有任何效果。 在 `Screen3` 上尝试相同的操作，可以正常弹出。

这种效果也可通过 canPop 实现：

## canPop

源码：

```
static bool canPop(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context, nullOk: true);
    return navigator != null && navigator.canPop();
  }

bool canPop() {
    assert(_history.isNotEmpty);
    return _history.length > 1 || _history[0].willHandlePopInternally;
  }
```

如果占中实例大于 1 或 willHandlePopInternally 属性为 true 返回 true，否则返回 false。

我们可以通过判断 canPop 来确定是否能够弹出该页面。

## 如何去除默认返回按钮

```
AppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation = 4.0,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  }) : assert(automaticallyImplyLeading != null),
       assert(elevation != null),
       assert(primary != null),
       assert(titleSpacing != null),
       assert(toolbarOpacity != null),
       assert(bottomOpacity != null),
       preferredSize = Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
       super(key: key);
```

将 `automaticallyImplyLeading`置为 `false`

# 参考链接

https://docs.flutter.io/flutter/widgets/Navigator-class.html

https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31