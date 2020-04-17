# 使用Dart语言实现快速排序

```
import 'dart:math';
// 快速排序
// 时间复杂度O(n*log n)
void main() {
  var list = List<int>();
  Random random = new Random();
  for (var i = 0; i < 20; i++) {
    list.add(random.nextInt(100));
  }
  print('排序前：'+list.toString());
  print('排序后：'+quickSort(list).toString());
}

List<int> quickSort(List<int> list) {
  if (list.length < 2) {
    //如果只有一个值不需要排序
    return list;
  } else {
    //获取比较的标准（参考）值
    var pivot = list[0];
    //创建一个集合用来存储小于等于标准值的数值
    // 没有元素，需要显式指定泛型参数为 int 否则报错 List<dynamic>' is not a subtype of type 'List<int>
    var less = <int>[]; 
    //创建一个集合用来存储比标准值大的数值
    var greater = <int>[];
    //将标准值从集合中移除
    list.removeAt(0);
    //遍历整个集合
    for (var i in list) {
      if (i <= pivot) {
        //如果小于等于标准值放入less集合中
        less.add(i);
      } else {
        //如果大于标准值放入greater集合中
        greater.add(i);
      }
    }
    //使用递归的方式，对less 和 greater 再进行排序，最终返回排序好的集合
    return quickSort(less) + [pivot] + quickSort(greater);
  }
}

```
#### 牵扯到语法：
List的操作
```
// 使用构造函数创建对象
// 跟 var list = new List<int>(); 一样
var list = List<int>();
list.add(1);
list.add(2);

// 通过字面量创建对象，list 的泛型参数可以从变量定义推断出来。
// 推荐使用字面量方式创建对象
var list2 = [1, 2];
// 没有元素，显式指定泛型参数为 int
var list3 = <int>[];
list3.add(1);
list3.add(2);

var list4 = const[1, 2];
// list4 指向的是一个常量，我们不能给它添加元素（不能修改它）
list4.add(3);       // error
// list4 本身不是一个常量，所以它可以指向另一个对象
list4 = [4, 5];     // it's fine

const list5 = [1, 2];
// 相当于 const list5 = const[1, 2];
list5.add(3);       // error

```
for循环 和 if语句
```
var success = true;
if (success) {
  print('done');
} else {
  print('fail');
}

for (var i = 0; i < 5; ++i) {
  print(i);
}

// Dart 同样提供了 for-in 循环。
// 因为语音设计时就考虑到了这个需求，in 在 Dart 里是一个关键字
var list6 = [1, 3, 5, 7];
for (var e in list6) {
  print(e);
}
```
参考：
[Flutter学习指南：熟悉Dart语言](https://mp.weixin.qq.com/s?__biz=MzIwMTAzMTMxMg==&mid=2649493277&idx=1&sn=83cae5e71af5a1ba486add4824e51e91&chksm=8eec84e2b99b0df4fc5f9f56719fc5edcdaeac2851b7147ebbe331f21f9f7d13f32ab104d2f7&scene=21#wechat_redirect)
[A Tour of the Dart Language](https://www.dartlang.org/guides/language/language-tour#lists)