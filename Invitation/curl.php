<?php
 

$num1=3.14;   
$num2=(int)$num1;   
var_dump($num1); //输出float(3.14)   
var_dump($num2); //输出int(3)   

//第二种转换方式：  intval()  floatval()  strval()

 

$str="123.9abc";   
$int=intval($str);     //转换后数值：123   
$float=floatval($str); //转换后数值：123.9   
$str=strval($float);   //转换后字符串："123.9"    

//第三种转换方式：  settype();


$num4=12.8;   
$flg=settype($num4,"int");   
var_dump($flg);  //输出bool(true)   
var_dump($num4); //输出int(12)   
