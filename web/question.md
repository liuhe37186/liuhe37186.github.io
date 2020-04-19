## div 嵌套img 底部多出空白
```
问题：padding、margin、border都设为0，无效。怎么样都多出3px。
解决方案：
1. 设置div{ font-size: 0}
2. 设置img{ display: block}
3. 设置img{ vertical-align:top;}  
推荐第二种方法，让img对象成为块级元素。
```
## eslint警告：定义未使用，** is defined but never used eslint
```
1. 在package.json里面的eslintConfig里面的规则里面加上"no-unused-vars”:”off"
2. 启动vue ui 在控制台关闭"vue/no-unused-vars": "off"
```
## 图片或文字垂直居中
```
1. div{ display: flex; align-items:center; }
2. margin: auto 0;
## css解决图片统一大小后的拉伸问题
object-fit:scale-down  
scale-down: 以contain或none图片最小尺寸为标准
```
## vue 子组件调用父组件方法
```
父组件定义方法  itemClick(item){}  
子组件调用  this.$parent.itemClick(items)
```
## 启动VUE控制台   
```
vue ui
```
## 隐藏scrollbar
```
::-webkit-scrollbar {
  display: none; /* Chrome Safari */
}
```
## [输入npm install node-sass 报错](https://segmentfault.com/a/1190000010984731)
```
node-sass@4.13.0 postinstall:`node scripts/build.js` Failed at the node-sass@4.13.0  
这个是因为sass安装时获取源的问题，先修改sass安装的源，再运行npm install就成功了
npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass
```