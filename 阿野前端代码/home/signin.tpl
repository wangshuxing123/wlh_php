<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<link rel="shortcut icon" href="/images/favicon.ico"/>
<meta content="yes" name="apple-mobile-web-app-capable"/>
<meta content="yes" name="apple-touch-fullscreen"/>
<meta content="telephone=no" name="format-detection"/>
<meta content="black" name="apple-mobile-web-app-status-bar-style">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>AYE阿野</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/jquery/jquery.extends.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
   input[type="text"],input[type="tel"],input[type="password"]{
       width:100%;
       box-sizing: border-box;
       font-size: 14px;
       line-height: 20px;
       border:#e3e3e3 solid 1px;
       border-radius: 3px;
       padding: 14px 0 14px 50px;
       margin-top: 20px;
       background-color: #fff;
   }

   .account{
       background: url(/images/wechat/signin_account.png) no-repeat 10px 7px;

   }
   .pwd{
       background: url(/images/wechat/signin_pwd.png) no-repeat 10px 7px;
   }

   .checkall{
       display: inline-block;
       font-size: 14px;
       line-height: 24px;
       color: #666;
       padding-left: 20px;
       vertical-align: top;
       background: url(/images/www/check.png) no-repeat 0 4px;
       &.selected{
            background: url(/images/www/check_selected.png) no-repeat 0 4px;
        }
   }
</style>

<script type="text/javascript">
    $(function(){
        $('.checkall').on('click',function(){
            $(this).toggleClass('selected');
            if($(this).hasClass('selected')){
                $("input[name='iskeeplogining']").val('1');
            }else{
                $("input[name='iskeeplogining']").val('0');
            }
        });

        var g_loginFormSubmited=false;
        $('.login').on('click',function(){
            if(g_loginFormSubmited==true){
                alert("请不要重复提交！");
                return false;
            }
            if(!$.validator($(".account").val(),'required')){
                $.alert('请输入您的手机号码！');
                return;
            }
            if(!$.validator($(".pwd").val(),'required')){
                $.alert('请输入您的密码！');
                return;
            }

            g_loginFormSubmited=true;
            $.post("/home/login",$("#loginForm").serializeObject(),function(jd){
                g_loginFormSubmited=false;
                if(jd.success == 1){ //成功
                    location.href=jd.msg;
                }else if(jd.success == -1){  //失败
                    $.alert('该账户不存在！');
                }else if(jd.success == -2){  //失败
                    $.alert('您输入的密码不正确！');
                }
            },"json");
            return false;
        });
    });
</script>

</head>

<body ontouchstart style="background-color: #f8f9f8;">

<div class="weui_tab">
    <div class="weui_navbar">
        <div class="weui_navbar_item" style="background-color: #fff;font-size: 16px;line-height: 24px;color:#888;    padding: 8px 0 8px 60px;">
            登录
            <a class="fr"  href="/home/signup" style="margin-right: 15px;color:#888;font-size: 16px;">注册</a>
        </div>
    </div>
    <div class="weui_tab_bd" style="padding-bottom: 50px;">
        <div style="width:100%;text-align: center;padding:30px 0 10px 0;">
            <img src="/images/wechat/sign_top_logo.png" style="width: 24%;">
        </div>
        <form id="loginForm" style="width: 80%;margin: 0 auto;">
            <input type="hidden" name="iskeeplogining" value="1">
            <input type="hidden" name="jumpurl" value="{$jumpurl}">
            <input type="tel" class="account" name="mobile" placeholder="请输入您的手机号码">
            <input type="password" class="pwd" name="pwdhash" placeholder="请输入您的密码">
            <div style="margin-top: 10px;">
                <a href="javascript:void(0);" class="checkall selected">自动登录</a>
                <a href="/home/forget_pwd" style="color:#f39e0c;float: right;font-size: 14px; ">忘记密码?</a>
            </div>
            <a href="javascript:void(0);" class="login weui_btn weui_btn_primary" style="margin-top: 10px;background-color:#e70111;">登录</a>
        </form>
    </div>
</div>


</body>
</html>