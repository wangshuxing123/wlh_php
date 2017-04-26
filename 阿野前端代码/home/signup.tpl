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
<script type="text/javascript" src="/kit/jquery/jquery.timers.js"></script>

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
    .imgvalidcodeinput{
        background: url(/images/wechat/signup_valid.png) no-repeat 10px 7px;
        display: inline-block;
    }
    .verifycodeinput{
        background: url(/images/wechat/signup_code.png) no-repeat 10px 7px;
        display: inline-block;
    }
    .getCode{
        width: 120px;
        color:#f3a425;
        font-size: 12px;
        line-height: 42px;
        text-align: center;
        border: #f2f3f2 solid 1px;
        float: right;
        margin-top: -47px;
        border-radius: 3px;
    }
    .getCodeDisable{
        width: 120px;
        font-size: 12px;
        line-height: 42px;
        text-align: center;
        color: #fff;
        border-radius: 3px;
        border: #bdbdbd solid 1px;
        background-color: #bdbdbd;
        float: right;
        margin-top: -47px;
    }

    .pwd{
        background: url(/images/wechat/signin_pwd.png) no-repeat 10px 7px;
    }
    .confirmpwd{
        background: url(/images/wechat/signup_pwd.png) no-repeat 10px 7px;
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

    .register{
        display: block;
        text-align: center;
        color: #fff;
        width: 100%;
        font-size: 20px;
        line-height: 50px;
        margin-top: 10px;
        border-radius: 5px;
        background-color:#e70111;
        &.disabled{
             background-color: #eee;
             color: #999;
         }
    }
</style>

<script type="text/javascript">
    $(function(){

        $('.agree').on('click',function(){
            $(this).toggleClass('selected');
            $('.register').toggleClass('disabled');
        });


        //刷新验证码
        $('#imgcode').on('click',function(){
            $.post('/home/getNewVerifycode',function(data){
                if(data){
                    $("#codeimg").attr('src','/home/generate/'+data.toString());
                    $("#vcode").val(data.toString());
                }
            },'text');
        });

        /**
         * 手机号输入框
         */
        $('.account').blur(function(){
            var mobile = $.trim($(".account").val());
            $.post('/home/checkMobile',{ mobile:mobile},function(jd){
                if(jd.success){
                    $.toptip('该手机号已注册！');
                }
            },'json');
        });


        var isSubmit = false;
        //获取手机验证码
        $('#acode').on('click',function(){
            if(isSubmit){
                return;
            }
            isSubmit = true;

            var mobile = $.trim($(".account").val());
            if(mobile == ''){
                $.alert('请输入您的手机号码！');
                isSubmit = false;
                return;
            }
            if(!$.validator(mobile,'phone')){
                $.alert('请输入正确格式的手机号！');
                isSubmit = false;
                return;
            }
            var code = '{$vcode}';
            var imgcode = $.trim($("#registerForm input[name='imgvalidcode']").val());
            var vcode = $.trim($("#registerForm input[name='vcode']").val());
            if(imgcode == ''){
                $.alert('请输入图片验证码！');
                isSubmit = false;
                return;
            }
            var params = {
                mobile : mobile,
                code : code,
                imgcode:imgcode,
                vcode:vcode
            };
            $("#acode").removeClass('getCode');
            $("#acode").addClass('getCodeDisable');
            $.post('/home/requestSms',params,function(data){
                if(parseInt(data) == 1){
                    $.toast('短信已发送！');
                    var i = 60;
                    $('body').everyTime('1s',function(){
                        i--;
                        if(i==0){
                            $('body').everyTime('1s',function(){
                                isSubmit = false;
                                $("#acode").removeClass('getCodeDisable');
                                $("#acode").addClass('getCode');
                                $("#acode").html("重新获取");
                                $('body').stopTime();
                            });
                        }else{
                            $("#acode").html("重新获取("+i+")");
                        }
                    });
                }else{
                    if(parseInt(data) == 0){
                        isSubmit = false;
                        $("#acode").removeClass('getCodeDisable');
                        $("#acode").addClass('getCode');
                        $('#acode').text('失败,点击重发');
                    }else if(parseInt(data) == -2){
                        $("#acode").removeClass('getCodeDisable');
                        $("#acode").addClass('getCode');
                        $('#acode').text('获取验证码');

                        $.alert('请输入图片验证码！');
                    }
                }
            },'text');
        });

        var g_signupFormSubmited=false;
        $(".register").on('click',function(){
            if($(this).hasClass('disabled')){
                return;
            }
            if(g_signupFormSubmited==true){
                alert("请不要重复提交！");
                return false;
            }

            var mobile = $.trim($("#registerForm input[name='mobile']").val());
            var validcode = $.trim($("#registerForm input[name='imgvalidcode']").val());
            var verifycode = $.trim($("#registerForm input[name='verifycode']").val());
            var pwdhash = $.trim($("#registerForm input[name='pwdhash']").val());
            var confirmpwd = $.trim($("#registerForm input[name='confirmpwd']").val());
            if(!$.validator(mobile,'req')){
                $.alert('请输入您的手机号!');
                return false;
            }else if(!$.validator(mobile,'phone')){
                $.alert('请输入正确格式的手机号!');
                return false;
            }else if(!$.validator(validcode,'req')){
                $.alert('请输入图片验证码!');
                return false;
            }else if(!$.validator(verifycode,'req')){
                $.alert('请输入短信验证码!');
                return false;
            }else if(!$.validator(pwdhash,'req')){
                $.alert('请设置您的密码!');
                return false;
            }else if(pwdhash.length<6||pwdhash.length>16){
                $.alert('密码只能输入6-16个字符!');
                return false;
            }else if(!$.validator(confirmpwd,'req')){
                $.alert('请输入您的确认密码!');
                return false;
            }else if(confirmpwd != pwdhash){
                $.alert('两次密码输入不一致!');
                return false;
            }else{
                g_signupFormSubmited=true;
                $.post("/home/register",$("#registerForm").serializeObject(),function(data){
                    g_signupFormSubmited=false;
                    if(data.success == 1){ //成功
                        location.href = '/home/index';
                    }else if(data.success == 0){
                        $.alert('该手机号已注册!');
                    }else if(data.success == -1){
                        $.alert('信息填写不完整，请重新提交!');
                    }else if(data.success == -2){
                        $.alert('短信验证码无效!');
                    }else if(data.success == -3){
                        $.alert('图片验证码失效!');
                    }
                },"json");
            }
        });

    });
</script>

</head>

<body ontouchstart style="background-color: #f8f9f8;">

<div class="weui_tab">
    <div class="weui_navbar">
        <div class="weui_navbar_item" style="background-color: #fff;font-size: 16px;line-height: 24px;color:#888;    padding: 8px 0 8px 60px;">
            注册
            <a class="fr"  href="/home/signin" style="margin-right: 15px;color:#888;font-size: 16px;">登录</a>
        </div>
    </div>
    <div class="weui_tab_bd" style="padding-bottom: 50px;">
        <div style="width:100%;text-align: center;padding-top: 10px;">
            <img src="/images/wechat/sign_top_logo.png" style="width: 24%;">
        </div>
        <form id="registerForm" style="width: 80%;margin: 0 auto;">
            <input id="vcode" type="hidden" name="vcode" value="{if isset($verifycode) }{$verifycode}{/if}" />
            <input type="tel" class="account" name="mobile" placeholder="请输入您的手机号码">


            <div style="width: 100%;">
                <input type="text"  class="imgvalidcodeinput"  name="imgvalidcode" placeholder="请输入右侧验证码"  autocomplete="off" style="width: 65%;"/>
                <a id="imgcode" href="javascript:void(0);" style="font-size: 12px;line-height: 40px;text-align: right;float: right;margin-top:24px; display: inline-block;width: 32%;">
                    <img id="codeimg" src="/home/generate/{$verifycode}" title="换一张" style="width: 100%;"></a>
                </a>
            </div>

            <div style="width: 100%;">
                <input class="verifycodeinput" type="tel" name="verifycode" placeholder="请输入验证码" autocomplete="off" style="width: 65%;"/>
                <a id="acode" href="javascript:void(0);" class="getCode" style="display: inline-block;width: 32%;">获取验证码</a>

            </div>

            <input type="password" class="pwd" name="pwdhash" placeholder="请设置您的密码">
            <input type="password" class="confirmpwd" name="confirmpwd" placeholder="请确认您的密码">
            <div style="margin-top: 10px;">
                <a href="javascript:void(0);" class="checkall agree selected">我已阅读并同意</a><a href="/home/service" style="color: #f5bd60;font-size: 14px;">《阿野服务协议》</a>
            </div>
            <a href="javascript:void(0);" class="register">注册</a>
        </form>
    </div>
</div>


</body>
</html>