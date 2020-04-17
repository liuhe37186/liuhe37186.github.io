# VUE新建项目

## 安装cli

```bash
sudo npm install -g @vue/cli
sudo npm install -g --unsafe-perm @vue/cli //mac 安装报异常使用这个
vue create vue-demo
$ cd vue-demo
$ npm run serve

```

## 安装 router

```
npm install vue-router --save-dev
```

## 使用router

```vue
//创建router.js
import Vue from 'vue';
import Router from 'vue-router';
Vue.use(Router);
export default new Router({
    routes: [
        {
            path: '/',
            redirect:'/HelloWorld'
        },
        {
            path:'/HelloWorld',
            component: resolve => require(['../components/HelloWorld.vue'], resolve),
        },
    ]
})

//在APP.vue使用router-view
<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>
<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
* {
  padding: 0; /*清除内边距*/
  margin: 0; /*清除外边距*/
}
</style>
在main.js中配置router
import Vue from 'vue'
import App from './App.vue'
import router from './router/router.js'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
  router,
}).$mount('#app')
```

## 创建Banner.vue组件

```vue
安装swiper组件
npm install vue-awesome-swiper
<template>
  <div class="banner">
    <swiper :options="options">
      <swiper-slide v-for="item in bannerItem" :key="item.id">
        <div @click="bannerClick(item)">
          <img :src="item.visitUrl" alt />
          <!-- <div>{{item.visitUrl}}</div> -->
        </div>
      </swiper-slide>
      <div class="swiper-pagination" slot="pagination"></div>
    </swiper>
  </div>
</template>

<script>
import "swiper/css/swiper.min.css"; //引入swiper的css样式
import { swiper, swiperSlide } from "vue-awesome-swiper";
export default {
  name: "banner",
  props: ["imgs"], //获取传递进来的数据
  components: {
    swiper,
    swiperSlide
  },
  data() {
    return {
      bannerItem: this.imgs,
      //swiper的配置参数
      options: {
        //自动滚动
        autoplay: {
          delay: 5000, //自动滚动间隔时间
          disableOnInteraction: false //是否允许用户打断滑动，默认为true
        },
        pagination: {
          el: ".swiper-pagination",
          clickable: true
        },
        centeredSlides: true,
        paginationClickable: true
      }
    };
  },
  methods: {
    bannerClick(item) {
      console.log("点击banner", item);
    }
  }
};
</script>

<style >
.banner {
  height: 170px;
  padding: 10px;
}
.banner img {
  width: 100%;
  height: 170px;
  min-height: 170px;
  min-width: 100%;
  border-radius: 5px;
}
</style>
```

## 使用Banner.vue

```vue
<template>
  <div>
    <!-- <h1>这是title</h1> -->
    <banner :imgs="bannerItem"></banner>
  </div>
</template>

<script>
import banner from "./Banner.vue";
export default {
  name: "home",
  components: {
    banner
  },

  data() {
    return {
      bannerItem: [
        {
          visitUrl:
            "https://tk-conline-20190225-1257840667.cos.ap-beijing.myqcloud.com/conline-test/banner.jpg",
          id: 1
        },
        {
          visitUrl:
            "https://tk-conline-20190225-1257840667.cos.ap-beijing.myqcloud.com/online-customer/1581478851959758.png",
          id: 2
        }
      ]
    };
  }
};
</script>
```



##移动端适配

1. 安装px2rem-loader(devDependencies)

```
npm install px2rem-loader --save-dev
```

2. 移动端适配解决npm包 "lib-flexible" (dependencies)

```
npm install lib-flexible --save
```

3. main.js中引入 "lib-flexible"

```
import 'lib-flexible' // 移动端适配 (目录: vue-demo/src/main.js)
```

4. 创建 "vue.config.js"  (目录:vue-demo/vue.config.js)

```
 module.exports = {
     chainWebpack: (config) => {
         config.module
         .rule('css')
         .test(/\.css$/)
         .oneOf('vue')
         .resourceQuery(/\?vue/)
         .use('px2rem')
         .loader('px2rem-loader')
         .options({
             remUnit: 75
         })
     
     }
 }
```

5. Banner.vue等页面中根据750px设计图写页面

6. 使用

   ```text
   直接写px，编译后会直接转化成rem      —- 除开下面两种情况，其他长度用这个
   在px后面添加/*no*/或者将px大写PX，不会转化px，会原样输出。      — 一般border需用这个
   在px后面添加/*px*/,会根据dpr的不同，生成三套代码。—-      一般字体需用这个
   ```

## 微信设置文字大小影响网页布局

需要引入下列代码
如果在vue中将代码写在index.html文件里

```vue
 @RenderBody()
  <script type="text/javascript">
    (function () {
      if (typeof WeixinJSBridge == "object" && typeof WeixinJSBridge.invoke == "function") {
        handleFontSize();
      } else {
        if (document.addEventListener) {
          document.addEventListener("WeixinJSBridgeReady", handleFontSize, false);
        } else if (document.attachEvent) {
          document.attachEvent("WeixinJSBridgeReady", handleFontSize);
          document.attachEvent("onWeixinJSBridgeReady", handleFontSize);
        }
      }
      function handleFontSize() {
        WeixinJSBridge.invoke('setFontSizeCallback', { 'fontSize': 0 });
        WeixinJSBridge.on('menu:setfont', function () {
          WeixinJSBridge.invoke('setFontSizeCallback', { 'fontSize': 0 });
        });
      }
    })();
    (function() {
      if (typeof WeixinJSBridge == "object" && typeof WeixinJSBridge.invoke == "function") {
        handleFontSize();
      } else {
        if (document.addEventListener) {
          document.addEventListener("WeixinJSBridgeReady", handleFontSize, false);
        } else if (document.attachEvent) {
          document.attachEvent("WeixinJSBridgeReady", handleFontSize);
          document.attachEvent("onWeixinJSBridgeReady", handleFontSize);  }
      }
      function handleFontSize() {
        // 设置网页字体为默认大小
        WeixinJSBridge.invoke('setFontSizeCallback', { 'fontSize' : 0 });
        // 重写设置网页字体大小的事件
        WeixinJSBridge.on('menu:setfont', function() {
          WeixinJSBridge.invoke('setFontSizeCallback', { 'fontSize' : 0 });
        });
      }
    })();
  </script>
```

需要注意的是，这段代码在Android微信环境中会延时生效。如果预先设置字号大小不是“标准”，打开网页时页面会按照设置的缩放效果展示约1秒（等WeixinJSBridge对象初始化完成）后才调整到正常。这个时间差的问题目前暂时没有合适的解决方式，只能通过增加loading动画、延迟展示时间等方式来尽量消除用户的不适感

## 部署到github Page

1. 在github新建项目 vue-demo

2. 在github创建一个类似liuhe37186.github.io这样格式的GitHub仓库

3. 在 `vue.config.js` 中设置正确的 `publicPath`。

   如果打算将项目部署到 `https://<USERNAME>.github.io/` 上, `publicPath` 将默认被设为 `"/"`，你可以忽略这个参数。

   如果打算将项目部署到 `https://<USERNAME>.github.io/<REPO>/` 上 (即仓库地址为 `https://github.com/<USERNAME>/<REPO>`)，可将 `publicPath` 设为 `"/<REPO>/"`。举个例子，如果仓库名字为“vue-demo”，那么 `vue.config.js` 的内容应如下所示：

   ```js
   module.exports = {
     publicPath: process.env.NODE_ENV === 'production'
       ? '/vue-demo/'
       : '/'
   }
   ```

4. 然后将本地项目push到远程master （非必须）

   ```
   #git init
   #git add README.md
   #git commit -m "first commit"
   git remote add origin https://github.com/liuhe37186/vue-demo.git
   git push -u origin master
   ```

5. 主要是下面这一步，将打包后的dist文件夹push到gh-pages

   ```
   npm run build
   git checkout -b gh-pages
   git add -f dist
   git commit -m 'first commit'
   git subtree push --prefix dist origin gh-pages
   ```

   

6. 在Setting里设置，用哪个分支部署，默认是gh-pages分支

   ###  自动部署

   1. 在项目根目录创建脚本deploy.sh 

   ```shell
   # !/usr/bin/env sh
   
   # 当发生错误时中止脚本
   set -e
   
   # 构建
   npm run build
   
   # cd 到构建输出的目录下 
   cd dist
   
   # 部署到自定义域域名
   # echo 'www.example.com' > CNAME
   
   git init
   git add -A
   git commit -m '部署page'
   
   # 部署到 https://<USERNAME>.github.io
   git push -f https://github.com/liuhe37186/vue-demo.git master:gh-pages
   
   # 部署到 https://<USERNAME>.github.io/<REPO>
   # git push -f https://github.com/xjinky/hello-world.git master:gh-pages  # 提交到gh-master分支
   
   # git push -f https://github.com/liuhe37186/vue-demo.git master    # 提交到master分支
   
   cd -
   ```

   2. 在项目根目录执行命令 sh deploy.sh 自动部署

   3. 在package.json文件中添加脚本命令

      ```
      "scripts": {
          "dev": "vue-cli-service serve --open",
          "build": "vue-cli-service build",
          "lint": "vue-cli-service lint",
          "pro": "sh deploy.sh"
        },
      ```

   4. 执行 npm run pro 可自动部署

## 网络请求

1. 安装axios

   ```
   $ npm install axios --save
   ```

2. 引入

   ```
   import axios from 'axios';
   ```

3. 配置请求参数

   ```javascript
   //设置超时时间
   axios.defaults.timeout = 15000;
   //设置全局的请求次数，请求的间隙
   axios.defaults.retry = 4;
   axios.defaults.retryDelay = 1000;
   //设置请求baseURL地址
   axios.defaults.baseURL = process.env.VUE_APP_BASEURL;
   ```

   

4. get请求

   ```javascript
   /**
    * 封装get方法
    * @param url
    * @param data
    * @returns {Promise}
    */
   
   export function get(url, params = {}) {
       return new Promise((resolve, reject) => {
           axios.get(url, {
               params: params
           }).then(response => {
               resolve(response.data);
           }).catch(err => {
               reject(err)
           })
       })
   }
   ```

4. post请求

   ```javascript
   /**
    * 封装post请求
    * @param url
    * @param data
    * @returns {Promise}
    */
   export function post(url, data = {},config={currContentType:"") {
       console.log("--------post$url:",url)
       console.log("-------post$data:",data)
       return new Promise((resolve, reject,config) => {
           axios.post(url, data).then(response => {
               console.log("--------post$response-----",response,"-------response$end------")
               resolve(response.data);
           }, error => {
               console.log("--------post$error-----",error,"-------error$end------")
               reject(error)
           })
       })
   }
   ```

5. 请求拦截器

   ```javascript
   const currContentType = {
     urlencoded: "application/x-www-form-urlencoded;charset=utf-8",
     fromData: "ipart/form-data;charset=utf-8",
     json: "application/json;charset=utf-8",
     xml: "text/xml;charset=utf-8",
     form:"multipart/form-data;charset=utf-8"
   };
   //http request 请求拦截器
   axios.interceptors.request.use(
     config => {
       console.log("--------interceptors$request$enter--------",config)
           
           if (config.currContentType == "json") {
               config.headers = {
                 "Content-Type": currContentType.json
               };
           } else {
               //不传走表单
               config.headers = {
                 "Content-Type": currContentType.urlencoded
               };
               config.data = qs.stringify(config.data);
             } 
         
       console.log("--------interceptors$request$config--------",config,"--------end--------")  
       return config;
     },
     error => {
       return Promise.reject(error);
     }
   );
   ```

   

6. 响应拦截器

   ```javascript
   //添加响应之后拦截器
   axios.interceptors.response.use(function(response) {
       //对响应数据做些事
       console.log("------interceptors$response$response------")
       return response;
   }, function(error) {
       //请求错误时做些事
       console.log("------interceptors$response$error------")
       return Promise.reject(error);
   });
   ```

