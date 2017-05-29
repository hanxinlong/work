# Html知识总结

### 什么是HTML？

1. 超文本标记语言（英语：HyperText Markup Language, 简称:HTML）是一种用于创建网页的标准标记语言。
2. 后缀: .html 或者 .htm
3. HTML不是一种编程语言，而是一种标记语言
4. 标记语言是一套标记标签（Markup Tag）
5. HTML使用标记签来描述网页 
6. HTML文档包含了HTML标签以及文本内容
7. HTML文档也叫做web页面
8. 对于中文网页需要使用下面的代码来声明编码，否则会出现乱码

```html
<meta charset='utf-8'>
```

### HTML标签

HTML标记标签通常被陈伟HTML标签（HTML tag）

1. HTML标签是有尖括号包围的关键词，eg：<html>
2. HTML标签通常是成对出现的，比如<b>和</b>
3. 标签对中的第一个标签是开始标签，第二个标签是结束标签
4. 、开始和结束标签也称为开放标签和闭合标签

```html
<tag>content</tag>
```

### Web浏览器

Web浏览器（如谷歌浏览器geogle, Internet Explorer, Firefox, Safari）是用于读取HTML文件，并将其作为网页显示

浏览器并不是直接显示的HTML标签，但可以使用标签来决定如何展现HTML页面的内容给用户

### HTML编辑器推荐

1. Notepad++
2. Sublime

### HTML格式

```html
<!DOCTYPE html>
<html>
  <head>
    <title>文档标题</title>
  </head>
  <body>
  </body>
</html>
```

### HTML<meta>标签

1. 为搜索引擎定义关键词

   ```html
   <meta name="keywords" content="HTML, CSS" />
   ```

2. 为网页定义描述内容

   ```html
   <meta name="description" content="Free Web tutorials" />
   ```

3. 定义网页作者

   ```html
   <meta name="author" content="hanxinlong" />
   ```

4. 每30秒钟刷新当前页面

   ```html
   <meta http-equive="refresh" content="30"
   ```

## CSS

#### css: (Cascading Style Sheets)用于渲染HTML元素标签的样式

css是在HTML4开始使用的，是为了更好的渲染HTML元素而引入的。

Css可以通过以下方式添加到HTML中：

内敛样式-在HTML元素中使用‘style’属性

内部样式表-在HTML文档头部<head>区域中使用<style>元素来包含CSS

外部引用：使用外部的CSS样式

### BS和CS简单认识

1、BS: browser-server	

2、CS:client-server

​	特点：交互性强、具有安全的存储模式、网络通信量低、响应速度快、利用

