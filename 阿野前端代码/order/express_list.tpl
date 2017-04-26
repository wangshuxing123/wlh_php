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
<title>物流跟踪</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>


<style type="text/less">
    .weui_icon_success:before {
         color: #e60012;
    }
</style>

<script type="text/javascript">

    $(function(){

    });
</script>

</head>

<body ontouchstart>
<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>物流跟踪
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">
        <div class="weui_msg" style="padding: 15px;">

            {if count($express_list) gt 0}
                {foreach from=$express_list item="item"}
                    <div style="padding: 10px 0;border-bottom: #ccc solid 1px;">
                        <div style="display: inline-block;width: 30%;vertical-align: middle;">{$item->Upload_Time}</div>
                        <div style="display: inline-block;width: 60%;text-align: left;vertical-align: middle;">{$item->ProcessInfo}</div>
                    </div>
                {/foreach}
            {else}
                <p style="text-align: center;margin-top: 30px;">没有查询到物流信息</p>
            {/if}
        </div>
    </div>

    {$page = 'order'}
    {include file="footer.tpl"}
</div>

</body>
</html>