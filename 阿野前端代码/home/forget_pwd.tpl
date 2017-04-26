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
    .weui_cell{
        border-bottom: none;
        border-left:1px solid #ECECEC;
        border-right:1px solid #ECECEC;
    }
    .contentBox{
        padding-left:3%;
        padding-right:3%;
    }
    .weui_tab{
        background:url("/images/wechat/v1/home_signin.png") 0 center no-repeat;
        background-size:cover;
        width:100%;
        height:100%;
        margin-top:60px;
    }
</style>

<script type="text/javascript">
    var g_pwdFormSubmited=false;
    $(document).ready(function(){

        //刷新验证码
        $('#imgcode').on('click',function(){
            $.post('/home/getNewVerifyCode',function(data){
                if(data){
                    $("#codeimg").attr('src','/home/generate/'+data.toString());
                    $("#hashcode").val(data.toString());
                }
            },'text');
        });

        /**
         * 发送手机验证码
         */
        var isSubmit = false;
        $(document).on("click",".sendcode",function(){
            if(isSubmit){
                return;
            }
            var mobile = $.trim($("#pwdForm input[name='mobile']").val());
            if((!$.validator(mobile,'req')) || (!$.validator(mobile,'phone')) ){
                $.alert("请输入正确的手机号码！");
                return false;
            }
            var imgcode = $.trim($("#pwdForm input[name='imgcode']").val());
            if(!$.validator(imgcode,'req')){
                $.alert('请输入图形验证码！');
                return false;
            }
            $("#pwdForm .error").html('');
            isSubmit = true;
            $.post('/home/send_sms',{ mobile:mobile,hashcode:$("#pwdForm input[name='hashcode']").val(),imgcode:$("#pwdForm input[name='imgcode']").val()},function(data){
                if(data.success){
                    var i = 60;
                    $('body').everyTime('1s',function(){
                        i--;
                        if(i==0)
                        {
                            $('body').everyTime('1s',function(){
                                isSubmit = false;
                                $(" #pwdForm .sendcode").text("重新获取");
                                $('body').stopTime();
                            });
                        }else{
                            $("#pwdForm .sendcode").text(""+i+"秒后重新发送");
                        }
                    });
                }else{
                    $.alert(data.msg);
                    $("#pwdForm .sendcode").text('重新获取');
                    isSubmit = false;
                    return;
                }
            },'json');
        });
        $("#submit").on('click',function(){
            if(g_pwdFormSubmited==true){
                $.alert('请不要重复提交！');
                return false;
            }
            $('.error').empty();

            var mobile = $.trim($("#pwdForm input[name='mobile']").val());
            if((!$.validator(mobile,'req')) || (!$.validator(mobile,'phone')) ){
                $.alert('请输入正确的手机号码！');
                return;
            }
            var code = $.trim($("#pwdForm input[name='imgcode']").val());
            if((!$.validator(code,'req'))){
                $.alert('请输入图形验证码！');
                return;
            }
            var code = $.trim($("#pwdForm input[name='code']").val());
            if((!$.validator(code,'req'))){
                $.alert('请输入验证码！');
                return;
            }

            var password = $.trim($("#pwdForm input[name='password']").val());
            if((!$.validator(password,'req'))){
                $.alert('请输入密码！');
                return;
            }

            if((!$.validator(password,'alnum'))){
                $.alert('密码应包含字母和数字！');
                return;
            }
            if(password.length<6){
                $.alert('密码长度不能小于6位！');
                return;
            }
            var npassword = $.trim($("#pwdForm input[name='npassword']").val());
            if(npassword!=password){
                $.alert('两次输入密码不一致！');
                return;
            }

            g_pwdFormSubmited=true;
            $.post("/home/resetPwd",$("#pwdForm").serializeObject(),function(jd){
                g_pwdFormSubmited=false;
                if(jd.success){ //成功
                    $.alert("重置成功，请重新登录");
                }else{  //失败
                    $.alert(jd.msg,"forbidden");
                }
            },"json");
        });
    })


</script>

</head>

<body ontouchstart style="background-color: #f8f9f8;">
<div class="weui_navbar">
    <div class="weui_navbar_item" style="background-color: #fff;font-size: 16px;line-height: 24px;color:#888;">
        忘记密码
    </div>
</div>
<div class="weui_tab">
    <div class="contentBox">
        <form id="pwdForm" method="post" class="tabbox mt10 container" >
            <input type="hidden" value="tp">
            <input id="hashcode" type="hidden" name="hashcode" value="{if isset($verifycode) }{$verifycode}{/if}" />
            <div class="weui_cells weui_cells_form fs14" style="margin-top:0;">
                <div class="weui_cell relative" style="padding: 0 0 0 15px;line-height:40px;">
                    <div class="fl" style="width: 50%;">
                        <input name="mobile" class="weui_input" type="text" placeholder="手机号" style="font-size:14px;">
                    </div>
                    <div  class="fr" style="width: 50%;">
                        <a href="javascript:void(0);" class="fs12 fr tac sendcode" style="line-height:43px;:100px;height:43px;display:block;padding:0 10%;color:#fff;background:#E70111;">发送验证码</a>
                    </div>
                </div>
            </div>
            <div class="weui_cells weui_cells_form" style="margin-top:2%;">
                <div class="weui_cell" style="padding: 0px;">
                    <input type="text"  name="imgcode"  class="weui_input fs12" placeholder="请输入右侧验证码"  autocomplete="off" style="font-size: 14px;padding-left: 15px;"/>
                    <a id="imgcode" href="javascript:void(0);" class="fs12 tar" style="display: inline-block;">
                        <img id="codeimg" src="/home/generate/{$verifycode}" title="看不清？换一张" style="padding-top:3px;width: 90px;height:39px;"/>
                    </a>
                </div>
            </div>
            <div class="weui_cells weui_cells_form fs14" style="margin-top:2%;">
                <div class="weui_cell">
                    <input name="code" class="weui_input" type="text" placeholder="验证码" style="font-size:14px;">
                </div>
            </div>
            <div class="weui_cells weui_cells_form fs14" style="margin-top:2%;">
                <div class="weui_cell">
                    <input name="password" class="weui_input" type="password" placeholder="请输入新密码" style="font-size:14px;">
                </div>
            </div>
            <div class="weui_cells weui_cells_form fs14" style="margin-top:2%;">
                <div class="weui_cell">
                    <input name="npassword" class="weui_input" type="password" placeholder="请再次输入新密码" style="font-size:14px;">
                </div>
            </div>
            <p class="error mb1"></p>
            <a href="javascript:void(0);" id="submit" class="weui_btn fs14" style="font-size:16px;display:block;line-height:40px;width:80%;margin: 0 auto;color: #797875;border:1px solid #D3D4D2;background:none;margin-top:10%;border-radius:25px;">确 定</a>
        </form>

    </div>
</div>


</body>
</html>