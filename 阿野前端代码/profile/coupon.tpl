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
<title>我的优惠券</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
    .couponitem{
        width: 92%;
        margin: 0 auto;
        background-color: #ff504e;
        border-radius: 5px;
        margin-top: 15px;
        cursor: pointer;
        position:relative;
        .leftdiv{
            display: inline-block;
            width: 30%;
            text-align: center;
            padding:10px;
            .amount{
                font-size:30px;
                color: #fff;
            }
            .limit{
                background-color: #fff;
                border-radius: 12px;
                line-height: 24px;
                color: #ff504e;
                margin: 0 auto;
            }
        }
        .rightdiv{
            display: inline-block;
            font-size: 14px;
            color: #fff;
        }

        &.disabled{
             color:#ebe9e7;
             background-color: #999;
            .limit{
                color: #b6b2ad;
                background-color: #f9f9f7;
            }
        }
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
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>我的优惠券
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 150px;padding-top: 0;">
        {if count($couponlist) eq 0}
            <div style="margin: auto 0;line-height: 100px;width: 100%;text-align: center;">您没有优惠券</div>
        {/if}

        {foreach from=$couponlist item="item"}
            <div class="couponitem {if $item->expiredate lt $smarty.now|date_format:"%Y-%m-%d"}disabled{/if}" id="{$item->id}" amount="{$item->amount}">

                {if $item->expiredate lt $smarty.now|date_format:"%Y-%m-%d"}
                   {if $item->status eq '024001'}
                       <img src="/images/wechat/coupon_expire.png" style="position: absolute;right: 0;top:0;width: 80px;">
                   {elseif $item->status eq '024002'}
                       <img src="/images/wechat/coupon_used.png" style="position: absolute;right: 0;top:0;width: 80px;">
                   {/if}
                {/if}

                <div class="leftdiv">
                    <div class="amount"><span style="font-size: 16px;">￥</span>{$item->amount|string_format:"%.0f"}</div>
                    <div class="limit">满{$item->lowerlimit|string_format:"%.0f"}元可用</div>
                </div>
                <div class="rightdiv">
                    <p>优惠券</p>
                    <p>{$item->info}</p>
                    <p>{$item->begindate}至{$item->expiredate}</p>
                </div>
            </div>
        {/foreach}
    </div>

    {$page = 'profile'}
    {include file="footer.tpl"}
</div>

</body>
</html>