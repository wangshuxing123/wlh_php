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
<title>评价商品</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style type="text/less">

</style>

<script type="text/javascript">

    wx.config({
        debug: false,
        appId: '{$appId}',
        timestamp: '{$timestamp}',
        nonceStr: '{$nonceStr}',
        signature: '{$signature}',
        jsApiList: [
            'hideOptionMenu'
        ]
    });

    $(function(){

        wx.ready(function(){
            wx.hideOptionMenu();
        });

    });
</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>评价商品
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">
        <div class="weui_panel weui_panel_access" style="margin-top: 15px;">
    <div class="weui_panel_bd">
        {foreach from=$goodslist item="item"}
            <div class="weui_media_box weui_media_appmsg">
                <div class="weui_media_hd">
                    <img class="weui_media_appmsg_thumb" src="{imageurl pic = $item->imgurl size = '80x80'}" alt="">
                </div>
                <div class="weui_media_bd">
                    <p class="weui_media_desc" style="height: 31px;">{$item->goodsname}</p>
                    {if $item->iscomment eq '1'}
                        <p class="weui_media_desc fr">已评价</p>
                    {else}
                        <a href="/order/comment_one?orderid={$item->orderid}&goodsid={$item->goodsid}" class="weui_btn weui_btn_mini weui_btn_primary" style="float: right;margin-top: 5px;background-color:#fff;border: #e60111 solid 1px;color: #e60111;">去评价</a>
                    {/if}
                </div>
            </div>
        {/foreach}
    </div>
</div>
    </div>
    {$page = 'order'}
    {include file="footer.tpl"}
</div>
</body>
</html>