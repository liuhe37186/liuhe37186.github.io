# Flutter 深入理解 State

本文主要介绍 *Flutter* 应用程序中 `Widget`，`State`，`Context` 和 `InheritedWidget` 等重要概念。 尤其注意的是 `InheritedWidget`，它是最重要且介绍较少的 `Widget` 之一。

------

## 前言

每个 `Flutter` 开发人员都需要完全理解 `Widget`，`State` 和 `Context` 概念。

虽然，有很多文档可以查询，但想要清晰地解释这些概念，还是有一定难度。

本文会对这些概念进行剖析，力图使你能够进一步了解这些概念：

- 有状态和无状态 `Widegt` 的区别
- `Context` 是什么
- `State` 是什么以及如何使用它
- `Context` 与其 `State` 对象之间的关系
- `InheritedWidget` 以及在 `Widgets` 树中传递信息的方式
- `rebuild` 概念

## 第一部分：概念

### Widget

在 `Flutter` 中，一切都是 `Widget`。

将 `Widget` 视为可视化组件（或可视化交互的组件）。

当您需要构建直接或间接布局关系时，您正在使用 `Widget`。

### Widget 树

`Widget` 是以树结构组织起来的。

包含其他 `Widget` 的 `Widget` 称为父 `Widget`（或 `Widget` 容器）。包含在父 `Widget` 中的 `Widget` 称为子 `Widget`。

以 `Flutter` 自动生成的应用程序来进行说明。 构建代码：

```
@override
Widget build(BuildContext){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
}
```

我们将获得以下 `Widget` 树（仅限代码中存在的 `Widget` 列表）：

![img](https://user-gold-cdn.xitu.io/2019/1/22/16874d0cec93c2ef?w=1518&h=1180&f=png&s=280148)

### Context 上下文

另一个重要的概念是 `Context`。

`Context` 是构建所有 `Widgets` 树结构中的 `Widget` 的位置引用。

> 简而言之，将 `Context` 视为 `Widgets` 树的一部分。

一个 `Context` 仅属于一个 `Widget`。同样具有父子关系，如果 `Widget A` 具有子 `Widgets`，则 `Widget A` 的 `Context` 将成为子 `Widget` 的 `Context` 的父 `Context`。

很明显，`Context` 是关联在一起，组成一个 `Context` 树（父子关系）。

现在，我们使用上图说明 `Context` 的概念，每种颜色代表一个 `Context`（除了 `MyApp`，它是不同的）：

![img](https://user-gold-cdn.xitu.io/2019/1/22/16874e6d531d0d19?w=1692&h=1294&f=png&s=684662)

> `Context` 可见性：某些属性只能在其自己的 `Context` 中或在其父 `Context` 中可见。

使用这种语法，我们可以从子 `Context` 追根溯源，很容易找到一个祖先（或者父）`Widget`。

> 举例，考虑 `Scaffold > Center > Column > Text：context.ancestorWidgetOfExactType（Scaffold）=>` 通过从 `Text Context`向上查找到顶部 `Scaffold`。

从父 `Context` 中，也可以找到后代（=子） `Widget`，但不建议这样做（我们稍后会讨论）。

### 两种 Widgets

### 无状态 StatelessWidget

这些可视组件，只依赖它们自己的配置信息，并不依赖于任何外部信息。这些配置信息在构建时由其父组件提供。

换句话说，这些 `Widgets` 一旦创建就不关心任何变化。

这些 `Widgets` 被称为无状态 `Widgets`。

这些 `Widgets` 的典型示例是 `Text，Row，Column，Container ......` 在构建时，我们只是将一些参数传递给它们。

参数可以是文本，尺寸甚至其他 `Widgets`。 唯一重要的是这个配置信息一旦应用，在下一个构建过程之前不会改变。

> 无状态 `Widget` 只能在加载或者构建 `Widget` 时绘制一次，这意味着无法基于任何事件或用户操作重绘该 `Widget`。

### StatelessWidget 生命周期

无状态 `Widget` 相关的代码的典型结构如下。

如您所见，我们可以将一些额外的参数传递给它的构造函数。 但是，请记住，这些参数不会在以后阶段发生变化，只能按原样使用。

```
class MyAppStatelessWidget extends StatelessWidget {

	MyAppStatelessWidget({
		Key key,
		this.parameter,
	}): super(key:key);

	final parameter;

	@override
	Widget build(BuildContext context){
		return new ...
	}
}
```

`StatelessWidget` 的另一个方法 `createElement` 也可以被复写，但你几乎不会这样做。 唯一需要被复写的是 · `build` 函数。

这种无状态 `Widget` 的生命周期很简单：

- 初始化
- 通过 `build` 进行渲染

### 有状态 StatefulWidget

某些 `Widget` 需要处理一些在 `Widget` 生命周期内会发生变化的内部数据。

这些 `Widget` 保存的数据集在 `Widget` 的生命周期中可能会有所不同，这样的数据集被称为 `State`。

这样的 `Widget` 被称为有状态 `Widget`。

此类 `Widget` 的示例可以是复选框列表，也可以是根据条件禁用的 `Button`。

### State

`State` 定义 `StatefulWidget` 实例的 `行为` 部分。

它包含 `Widget` **交互** 的信息：

- **行为**
- **布局**

> 施加于 State 的任何更改都会强制 `Widget` 重建。

### State 与 Context 之间的关系

对于有状态 `Widgets`，`State` 与 `Context` 相关联。 此关联是永久性的，`State` 对象永远不会更改其 `Context`。

即使可以在 `Widgets` 树内移动 `Widget` `Context` ，`State` 仍将与该 `Context` 相关联。

当 `State` 与 `Context` 关联时，`State` 被视为已挂载。

> **至关重要：**

> 由于`State` 对象与 `Context` 相关联，这意味着 `State` 对象不能（直接）通过另一个 `Context` 访问！ （我们将在稍后讨论这个问题）。

### 有状态 Widget 生命周期

基本概念已经介绍过了，是时候深入了解了。

由于本文的主要意图是用 “变量” 数据来解释 `State` 的概念，因此会故意跳过某些与 `Stateful Widget` 可复写方法相关的任何解释，这些方法与此没有特别的关系。 这些可复写的方法是 `didUpdateWidget`，`deactivate`，`reassemble`。

```
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

下面时序图显示了创建有状态 `Widget` 相关的操作。 在图的右侧，标注了 `State` 对象的内部状态。 同时您可以看 `Context` 与 `State` 关联的时刻，从而变为有效的（挂载）。

![img](https://user-gold-cdn.xitu.io/2019/1/24/1687e6d4abb66b83?w=715&h=676&f=png&s=60959)

### initState()

`initState()` 方法是在创建 `State` 对象后要调用的第一个方法（在构造函数之后）。需要执行自定义初始化内容时，需要复写此方法。 通常初始化，动画，逻辑控制等。如果重写此方法，需要先调用 `super.initState()` 方法。

在这个方法中，Context 可用但你还不能真正使用它，因为框架还没有完全将 `State` 与它相关联。

一旦 `initState()` 方法执行完成，`State` 对象完成初始化并且 `Context` 可用。

在`State` 对象的生命周期内，不会再调用 `initState()` 方法。即 `initState()` 只被调用一次。

### didChangeDependencies()

`didChangeDependencies()` 方法是要调用的第二个方法。

在此阶段，由于 `Context` 可用，您可以使用它。

如果您的 `Widget` 链接到 `InheritedWidget`，并且需要初始化某些侦听器（基于 `Context`），则需要复写此方法。

请注意，如果您的 `Widget` 关联到 `InheritedWidget`，则每次重建此 `Widget` 时都会调用此方法。

如果重写此方法，则应首先调用 `super.didChangeDependencies()`。

### build()

`build(BuildContext context)` 方法在 `didChangeDependencies()`（和`didUpdateWidget`）之后调用。

这是您构建 `Widgets`（可能还有任何子树）的地方。

每次 `State` 对象更改时（或者当 `InheritedWidget` 需要通知 “已注册” 的 `Widget` 时）都会调用此方法！

如果要主动重建，您可以调用 `setState ( () {...})` 方法。

### dispose()

当 `Widget` 废弃时调用 `dispose()` 方法。

如果需要执行一些清理（例如侦听器）工作，需要复写此方法，之后调用 `super.dispose()`。

## 有状态和无状态 Widget 如何选择

Widget无状态或有状态？如何选择。

为了回答这个问题，请问问自己：

> 在我的 `Widget` 生命周期中，是否需要考虑一个变量, 将要更改，何时更改，从而强制重建 `Widget`？

如果问题的答案是肯定的，那么您需要一个有状态 `Widget`，否则，您需要一个无状态 `Widget`。

举例：

- 用于显示复选框列表的 `Widget`。要显示复选框，您需要考虑一系列 `item`。每个 `item` 都是一个具有 `title` 和 `status` 的对象。如果单击复选框，则会切换相应的 `item.status`。

  在这种情况下，您需要使用有状态 `Widget` 来记住项目的状态，以便能够重绘复选框。

- 单一表格, 该表格 `Widget` 允许用户输入，并将输入之后的表格发送到服务器。

  在这种情况下，除非您需要在提交表单之前验证表单或执行任何其他操作，否则无状态 `Widget` 可能就足够了。

## 有状态 Widget 由两部分组成

### Widget 定义

```
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}
```

第一部分 `MyStatefulWidget` 通常是 `Widget` 的公共部分。 当您要将其添加到 `Widget` 树，可以实例化此`Widget`。此部分在 `Widget`的生命周期内不会发生变化，但可以接受其相应的 `State` 实例参数。

请注意，在 `Widget` 的第一部分定义的任何变量通常在其生命周期内不会更改。

### `State` 定义

```dart
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    ...
	@override
	Widget build(BuildContext context){
	    ...
	}
}
```

第二部分 `_MyStatefulWidgetState` 是在 `Widget` 的生命周期中变化的部分，并在每次应用修改时强制重建 `Widget`实例。 名称开头的 `_` 字符表示该类对当前 `.dart` 文件是私有的。

如果需要在 `.dart` 文件之外引用此类，去掉 `_` 前缀即可。

`_MyStatefulWidgetState `类可以使用` widget.{变量名}` 访问存储在 `MyStatefulWidget`中的任何变量。 示例：`widget.color`

### Widget 的唯一标识 - Key

在Flutter中，每个Widget都是唯一标识的。这个唯一标识由框架在**构建/渲染**时定义。

此唯一标识对应为可选的 `Key` 参数。 如果省略，Flutter将为您生成一个。

在某些情况下，您可能需要使用此 `Key`，以便可以通过 `Key` 访问 `Widget`。

为此，您可以使用以下类之一：`GlobalKey`，`LocalKey`，`UniqueKey` 或 `ObjectKey`。

GlobalKey确保 `Key` 在整个应用程序中是唯一的。

使用 `Widget` 的唯一标识 `Key`：

```
GlobalKey myKey = new GlobalKey();
    ...
    @override
    Widget build(BuildContext context){
        return new MyWidget(
            key: myKey
        );
    }
```

------

## 第二部分， 如何访问 State

如前所述，State 关联一个 `Context`，`Context` 关联一个 `Widget` 实例。

### 1. Widget 本身

从理论上讲，唯一能够访问状态的是 `Widget State` 本身。

在这种情况下，没有困难。 `Widget State` 类访问其任何内部变量。

### 2. 子 Widget

有时候，父 `Widget` 可能需要根据其子 `Widget` 的状态执行特定任务。

在Flutter中，每个Widget都有一个唯一的标识，由框架在构建/渲染时确定。

如前所示，您可以使用 `key` 参数强制标识 `Widget`,

```
...
   GlobalKey<MyStatefulWidgetState> myWidgetStateKey = new GlobalKey<MyStatefulWidgetState>();
   ...
   @override
   Widget build(BuildContext context){
       return new MyStatefulWidget(
           key: myWidgetStateKey,
           color: Colors.blue,
       );
   }
```

一旦确定，父 `Widget` 可以通过以下方式访问其子 `Widget` 的状态：

> myWidgetStateKey.currentState

让我们考虑一个基本示例，当用户点击按钮时显示 `SnackBar`。 由于 `SnackBar` 是 `Scaffold`的子 `Widget`，它不能直接访问 `Scaffold`的任何其他子 `Widget`。 因此，访问它的唯一方法是 `ScaffoldState`，公开一个公共方法来显示 `SnackBar`。

```
class _MyScreenState extends State<MyScreen> {
        /// the unique identity of the Scaffold
        final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

        @override
        Widget build(BuildContext context){
            return new Scaffold(
                key: _scaffoldKey,
                appBar: new AppBar(
                    title: new Text('My Screen'),
                ),
                body: new Center(
                    new RaiseButton(
                        child: new Text('Hit me'),
                        onPressed: (){
                            _scaffoldKey.currentState.showSnackBar(
                                new SnackBar(
                                    content: new Text('This is the Snackbar...'),
                                )
                            );
                        }
                    ),
                ),
            );
        }
    }
```

### 3. Widget 祖先

![img](https://user-gold-cdn.xitu.io/2019/1/23/16879cf976983156?w=752&h=775&f=png&s=43865)

#### 1. `带状态的 Widget`（红色）需要暴露其状态

为了公开它的状态，Widget需要在创建时记录它，如下所示：

```
class MyExposingWidget extends StatefulWidget {

   MyExposingWidgetState myState;
	
   @override
   MyExposingWidgetState createState(){
      myState = new MyExposingWidgetState();
      return myState;
   }
}
```

#### 2. `Widget State` 需要暴露 getters/setters

为了让其他 `Widget`可以 设置/获取 State属性，`Widget State` 需要通过以下方式授权访问：

- public 属性 (不推荐)
- getter / setter

例子：

```
class MyExposingWidgetState extends State<MyExposingWidget>{
   Color _color;
	
   Color get color => _color;
   ...
}
```

#### 3. 蓝色 `Widget` 获得 State 引用

```
class MyChildWidget extends StatelessWidget {
   @override
   Widget build(BuildContext context){
      final MyExposingWidget widget = context.ancestorWidgetOfExactType(MyExposingWidget);
      final MyExposingWidgetState state = widget?.myState;
		
      return new Container(
         color: state == null ? Colors.blue : state.color,
      );
   }
}
```

这个解决方案很容易实现，但子 `Widget` 无法知道它何时需要重建，

它必须等待重建才能刷新其内容，这将导致UI无法及时刷新。

下一节将讨论 `Inherited Widget` 概念，它可以解决这个问题。

## InheritedWidget

简而言之，`InheritedWidget` 允许在 `Widget` 树中有效地传递（和共享）信息。

`InheritedWidget` 是一个特殊的 `Widget`，您可以将其插入 `Widget` 树中，作为一个 `Widget` 子树的父节点。 该子树的所有 `Widget` 都能够访问 `InheritedWidget` 公开的数据。

### 基础知识

为了解释 `InheritedWidget`，让我们考虑以下代码：

```
class MyInheritedWidget extends InheritedWidget {
   MyInheritedWidget({
      Key key,
      @required Widget child,
      this.data,
   }): super(key: key, child: child);
	
   final data;
	
   static MyInheritedWidget of(BuildContext context) {
      return context.inheritFromWidgetOfExactType(MyInheritedWidget);
   }

   @override
   bool updateShouldNotify(MyInheritedWidget oldWidget) => data != oldWidget.data;
}
```

此代码定义了一个名为 `MyInheritedWidget` 的 Widget，目的是 “共享” 所有 `Widget` 中的某些数据。

如前所述，为了能够**传递/共享**某些数据，需要将 `InheritedWidget` 定位在 `Widget` 树的顶部，这解释为什么 `InheritedWidget` 构造函数设置 `Widget` 为 `@required` 。

静态方法 `MyInheritedWidget(BuildContext context)` 允许所有子 `Widget` 获取最近包含 `Context` 的 `MyInheritedWidget` 实例（参见后面的内容）。

最后重写 `updateShouldNotify` 方法，用于设置 `InheritedWidget` 是否必须通知所有子 `Widget`（已注册/已订阅），如果数据发生修改（请参阅下文）。

因此，我们需要将它放在树节点上，如下所示：

```
class MyParentWidget... {
   ...
   @override
   Widget build(BuildContext context){
      return new MyInheritedWidget(
         data: counter,
         child: new Row(
            children: <Widget>[
               ...
            ],
         ),
      );
   }
}
```

### 子 `Widget` 如何访问 `InheritedWidget` 的数据

在构建子 `Widget` 时，将获得 `InheritedWidget` 的引用，如下所示：

```
class MyChildWidget... {
   ...
	
   @override
   Widget build(BuildContext context){
      final MyInheritedWidget inheritedWidget = MyInheritedWidget.of(context);
		
      ///
      /// From this moment, the widget can use the data, exposed by the MyInheritedWidget
      /// by calling:  inheritedWidget.data
      ///
      return new Container(
         color: inheritedWidget.data.color,
      );
   }
}
```

### 如何在 `Widget` 之间进行交互 ？

思考下面 `Widget` 树。

![img](https://user-gold-cdn.xitu.io/2019/1/23/1687a730eb729412?w=728&h=528&f=png&s=37579)

为了说明一种交互方式，我们假设如下：

- `Widget A` 是一个按钮，点击时将货物添加到购物车;
- `Widget B` 是一个文本，显示购物车中商品数量;
- `Widget C` 位于 `Widget B` 旁边，是一个文本;
- 我们希望在按下 `Widget A` 时自动在 `Widget B` 购物车中显示正确数量的项目，但我们不希望重建 `Widget C`，`InheritedWidget`应用场景正式于此！

> [示例代码 github](https://github.com/hongruqi/inheritedDemo)

**main.dart:**

```
import 'package:flutter/material.dart';
import 'package:flutter_app_demo/inherited.dart';
import 'package:flutter_app_demo/widgetA.dart';
import 'package:flutter_app_demo/widgetB.dart';
import 'package:flutter_app_demo/widgetC.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('I am Tree'),
        ),
        body: Column(
          children: <Widget>[
            WidgetA(),
            Padding(padding: EdgeInsets.all(15.0),),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  WidgetB(),
                  WidgetC(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

**inherited.dart**

```
import 'package:flutter/material.dart';

class MyInheritedWidget extends StatefulWidget{
  MyInheritedWidget({Key key, this.child,}):super(key: key);

  final Widget child;

  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }

}

class MyInheritedWidgetState extends State<MyInheritedWidget>{

  List<Item> _items = <Item>[];

  int get itemsCount => _items.length;

  void addItem(String name){
    setState(() {
      _items.add(new Item(name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInherited(child:  widget.child, data: this);
  }
}

class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class Item{
  String name;

  Item(this.name);
}
```

**Widgets:**

```
class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    return new Container(
      child: new RaisedButton(
        child: new Text('WidgetA Add Item',
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        onPressed: () {
          state.addItem('new item');
        },
      ),
    );
  }
}

class WidgetB extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    return new Container(
      child: Row(
        children: <Widget>[
          Icon(Icons.shopping_cart),
          Text('${state.itemsCount}',
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetC extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Text(
        'Widget C',
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
//          fontWeight: FontWeight.bold,
        color: Colors.green[200],
      ),
    );
  }
}
```

## 解释说明

在这个非常基本的例子中，

- `_MyInherited` 是一个 `InheritedWidget`，每次我们点击 `Widget A` 按钮添加一个 `Item` 时都会被重新创建。
- `MyInheritedWidget` 是一个 `Widget`，其状态包含 `Items` 列表。 可以通过`MyInheritedWidgetState of(BuildContext context)`静态方法访问此状态。
- `MyInheritedWidgetState` 公开一个 getter（itemsCount）和一个 `addItem` 方法，以便它们可以被 `Widget` 使用。
- 每次我们将一个 `Item` 添加到 `State`，`MyInheritedWidgetState` 都会重建。
- `MyStatefulWidget` 类只是构建一个 `Widget` 树，将 `MyInheritedWidget` 作为树的根节点。
- `WidgetA` 是一个简单的 `RaisedButton`，当按下它时，调用 `MyInheritedWidget` 的 `addItem` 方法。
- `WidgetB` 是一个简单的文本，显示 `MyInheritedWidget` 的 `item`数。

**这一切是如何运作 ？**

### 注册 Widget 以供以后通知

当子 `Widget` 调用 `MyInheritedWidget.of(context)`时，它调用 `MyInheritedWidget` 的以下方法，将 ‘Context’ 作为参数进行传递。

```
static MyInheritedWidgetState of(BuildContext context) {
	return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
```

在内部，除了简单地返回 `MyInheritedWidgetState` 的实例之外，它还向 `Widget` 订阅更改通知。

在场景后面，对这个静态方法的简单调用实际上做了两件事：

- `Widget` 被自动添加到订阅列表中，当对 `_MyInherited` 进行修改时， 将自动重建。
- `MyInheritedWidgetState` 中引用的数据将返回给使用者。

由于 `Widget A` 和 `Widget B` 都已使用 `InheritedWidget` 订阅，因此如果对 `_MyInherited` 进行修改，即当单击 `Widget A` 的 `RaisedButton` 时，大致操作流程如下：

1. 调用 `MyInheritedWidgetState` 的 `addItem` 方法。
2. `MyInheritedWidgetState.addItem` 方法将新项添加到 `List`。
3. 调用 `setState()` 重建 `MyInheritedWidget`。
4. 使用`List`的新内容创建 `_MyInherited` 的新实例。
5. `_MyInherited` 记录新 `State`。
6. 作为 `InheritedWidget`，它检查是否需要通知订阅者（答案是需要）。
7. 它遍历整个订阅者列表（这里是 `Widget A` 和 `Widget B` ）并要求他们重建。
8. 由于 `Wiget C` 不是订阅者，因此不会重建。

`Widget A` 和 `Widget B` 都重建了，而重建 `Wiget A` 却没用，因为它没有任何改变。如何防止这种情况发生？

### 访问 InheritedWidget 时阻止某些 Widget 重建

`Widget A` 也被重建的原因是访问 `MyInheritedWidgetState` 的方式。

如前所述，调用 `context.inheritFromWidgetOfExactType()` 方法会自动将 `Widget` 订阅到订阅列表中。

防止此自动订阅同时仍允许 `Widget A` 访问 `MyInheritedWidgetState` 的解决方案是更改`MyInheritedWidget` 的静态方法，如下所示：

```
static MyInheritedWidgetState of([BuildContext context, bool rebuild = true]){
    return (rebuild ? context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited
                    : context.ancestorWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
```

添加额外布尔参数:

- 如果 `rebuild` 参数为 `true`（默认情况下），Widget将被添加到订阅者列表中。
- 如果 `rebuild` 参数为 `false`，我们仍然可以访问数据，但不使用 `InheritedWidget` 的内部实现。

因此，要完成解决方案，我们还需要稍微更新 `Widget A` 的代码，如下所示（我们添加 `false` 参数）：

```
class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context, false);
    return new Container(
      child: new RaisedButton(
        child: new Text('Add Item'),
        onPressed: () {
          state.addItem('new item');
        },
      ),
    );
  }
}
```

现在，按下 `button` 不会重建 `Widget A`.

## 总结

通篇，我们介绍了 `Flutter` 的核心概念， Widget， State， Context， InheritedWidget。

并且，完成了 State 之间交互的介绍。并使用 `InheritedWidget` 进行了 Demo制作。希望这篇文章，能够帮助您，深入了解 `Flutter`。