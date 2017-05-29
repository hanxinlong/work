## Curl

### 定义

##### curl：CommandLine Uniform Resource Locator 命令行统一资源定位器

### 配置

curl是基于php里面的扩展，使用是需要开启

  ### 功能

#### 1、获取页面

```php
 <?php
   //1.初始化，创建一个新cURL资源  
    $ch = curl_init();  
    //2.设置URL和相应的选项  
    curl_setopt($ch, CURLOPT_URL, “http://www.lampbrother.net/”);  
    curl_setopt($ch, CURLOPT_HEADER, 0);  
    //3.抓取URL并把它传递给浏览器  
    curl_exec($ch);  
    //4.关闭cURL资源，并且释放系统资源  
    curl_close($ch);  
```

