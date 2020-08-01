### JS数组函数

![](https://i.loli.net/2020/08/01/Djvco3V1ETNrpCx.png)

#### JS数组函数

#### 1.改变原数组

通过打印Array对象，可以看到Array中共有31个函数，现在对这些函数进行一下分类

> vue->src->core->instance->observer->array.js
>
> 在vue2.6.1 源码中 vue为了实现对数组的变化进行监测，对Array中的7个方法进行了重写。为什么是这7个呢？因为只有这7个方法才会改变原数组。

```javascript
const arrayProto = Array.prototype
export const arrayMethods = Object.create(arrayProto)

const methodsToPatch = [
  'push',
  'pop',
  'shift',
  'unshift',
  'splice',
  'sort',
  'reverse'
]

/**
 * Intercept mutating methods and emit events
 */
methodsToPatch.forEach(function (method) {
  // cache original method
  const original = arrayProto[method]
  def(arrayMethods, method, function mutator (...args) {
    const result = original.apply(this, args)
    const ob = this.__ob__
    let inserted
    switch (method) {
      case 'push':
      case 'unshift':
        inserted = args
        break
      case 'splice':
        inserted = args.slice(2)
        break
    }
    if (inserted) ob.observeArray(inserted)
    // notify change
    ob.dep.notify()
    return result
  })
})
```

- `push`

  在最后一位新增一或多个数据，返回数组长度

- `pop`

  删除最后一位，并返回删除的数据

- `shift`

  删除第一位，并返回删除的数据

- `unshift`

  在第一位新增一或多个数据，返回长度

- `splice`

  删除指定位置，并替换，返回删除的数据

- `sort`

  排序（字符规则），返回结果

- `reverse`

  反转数组，返回结果

