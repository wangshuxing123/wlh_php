<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <meta content="yes" name="apple-mobile-web-app-capable"/>
    <meta content="yes" name="apple-touch-fullscreen"/>
    <meta content="telephone=no" name="format-detection"/>
    <meta content="black" name="apple-mobile-web-app-status-bar-style">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width; initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>修改密码</title>
    <link rel="stylesheet" type="text/css" href="/kit/wechat.css" />
    <link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
    <link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />
    <script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>
    <script type="text/javascript" src="/kit/jquery/jquery.extends.min.js"></script>

    <style type="text/less">
        .weui_cell{
            border-bottom: none;
            font-size: 14px;
            width:100%;
        }
        .weui_cell:before{
            border-top:none;
        }
    </style>

</head>
<body class="yahei relative" style="background:#f4f4f4;">

<div class="tabbox" style="background: #f4f4f4;margin-top:2%;">
    <form id="pwdForm" method="post" style="overflow: hidden;">
        <div class="weui_cell" style="background: #fff;margin-top:1%;">
            <div class="weui_cell_hd"><label class="weui_label">原密码</label></div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input fs14" type="password" name="opassword" placeholder="请输入原密码">
            </div>
        </div>
        <div class="weui_cell" style="background: #fff;margin-top:1%;">
            <div class="weui_cell_hd"><label class="weui_label">新密码</label></div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input" type="password" name="npassword" placeholder="请输入新密码">
            </div>
        </div>
        <div class="weui_cell" style="margin-bottom:5%;background: #fff;margin-top:1%;">
            <div class="weui_cell_hd"><label class="weui_label">确认密码</label></div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input" type="password" name="rpassword" placeholder="请再次输入新密码">
            </div>
        </div>
        <div class="container">
            <a href="javascript:void(0);"  id="submit" class="weui_btn" style="width:80%;margin: 0 auto;line-height:40px;font-size:14px;background:#E70012;border-radius:3px;">确认修改</a>
        </div>
    </form>

</div>
</body>
<script type="text/javascript">
    var pwdSubmited = false;
    $(document).ready(function(){
        $("#submit").on("click",function(){

            var opassword = $.trim($("#pwdForm input[name='opassword']").val());
            if((!$.validator(opassword,'req'))){
                $.toast("请输入原密码","forbidden");
                return false;
            }
            var npassword = $.trim($("#pwdForm input[name='npassword']").val());
            if((!$.validator(npassword,'req'))){
                $.toast("请输入新密码","forbidden");
                return false;
            }
            if(npassword.length<6){
                $.toast("密码长度不能小于6位","forbidden");
                return false;
            }
            var rpassword = $.trim($("#pwdForm input[name='rpassword']").val());
            if((!$.validator(rpassword,'req'))){
                $.toast("请再次输入新密码","forbidden");
                return false;
            }
            if(npassword!=rpassword){
                $.toast("两次新密码输入不一致","forbidden");
                return false;
            }

            pwdSubmited=true;
            $.post("/profile/save_password",$("#pwdForm").serializeObject(),function(jd){
                pwdSubmited=false;
                if(jd.success == 1){ //成功
                    $.toast("修改成功！");
                    location.href="/profile";
                }else if(jd.success == 0){
                    $.toast("修改失败", "forbidden");
                }else if(jd.success == -1){
                    $.toast("原密码错误", "forbidden");
                }
            },"json");
        });


    });
</script>
</html>