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
<title>我的专属二维码</title>

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style type="text/less">

</style>

<script type="text/javascript">
    wx.config({
        debug: false,
        appId: '{if isset($appId)}{$appId}{/if}',
        timestamp: '{if isset($timestamp)}{$timestamp}{/if}',
        nonceStr: '{if isset($nonceStr)}{$nonceStr}{/if}',
        signature: '{if isset($signature)}{$signature}{/if}',
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

<body style="margin: 0;">
<div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
    <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>我的专属二维码
</div>
{if $user->isdistribution eq '1' && isset($qrcode_url)}
    <img src="{$qrcode_url}" style="width: 100%;">
{else}
    <div style="line-height: 100px;width: 100%;text-align: center;">您还不是代言人！</div>
{/if}

</body>
</html>