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
<title>在线支付</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style type="text/less">
    .weui_icon_success:before {
         color: #e60012;
    }
</style>

<script type="text/javascript">

    wx.config({
        debug: false,
        appId: '{$appId}',
        timestamp: '{$timestamp}',
        nonceStr: '{$nonceStr}',
        signature: '{$signature}',
        jsApiList: [
            'hideOptionMenu','chooseWXPay'
        ]
    });

    $(function(){

        wx.ready(function(){
            wx.hideOptionMenu();
        });

        $('.topay').on('click', function(){
            var orderid = $(this).attr('orderid');
            var orderno = $(this).attr('orderno');
            var amount = $(this).attr('amount');
            $.post('/order/to_pay', { orderid:orderid,orderno:orderno,amount:amount }, function(jd){
               if(jd.success){
                   wx.chooseWXPay({
                       appId: jd.data.appId,
                       timestamp: jd.data.timeStamp,
                       nonceStr: jd.data.nonceStr,
                       package: jd.data.package,
                       signType: jd.data.signType,
                       paySign: jd.data.paySign,
                       success: function (res) {
                           location.href="/order/" + jd.data.orderid;
                       },
                       fail: function (res) {
                           $.toast('支付失败，请重试！');
                       },
                       cancel: function(){
                           $.toast('微信支付已取消！');
                       }
                   });
               }else{

               }
            }, 'json');

        });
    });
</script>

</head>

<body ontouchstart>

<div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
    <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>在线支付
</div>

<div class="weui_msg">
    {if count($no_stock_goods) eq 0}
    <div class="weui_icon_area"><i class="weui_icon_success weui_icon_msg" style="color: #e60012;"></i></div>
    {/if}
    {if $order->status eq '008001'}
        {if count($no_stock_goods) gt 0}
            <div class="weui_text_area">
                <h2 class="weui_msg_title">订单中商品库存不足，暂不能付款</h2>
                {foreach from=$no_stock_goods item="item"}
                    <p class="weui_msg_desc">{$item->name} {$item->spec} 库存不足</p>
                {/foreach}
            </div>
        {else}
            <div class="weui_text_area">
                <h2 class="weui_msg_title">订单提交成功,请尽快支付！</h2>
                <p class="weui_msg_desc">订单编号：{$order->orderno}</p>
                <p class="weui_msg_desc">支付金额：<span style="color: #e60012;font-weight: bold;">{$order->realamount}</span></p>
            </div>
            <div class="weui_opr_area">
                <p class="weui_btn_area">
                    <a href="javascript:;" class="weui_btn weui_btn_primary topay" orderid="{$order->id}" orderno="{$order->orderno}" amount="{$order->realamount}" style="background-color: #e60012;">微信安全支付</a>
                </p>
            </div>
        {/if}
    {elseif $order->status eq '008002'}
        <div class="weui_text_area">
            <h2 class="weui_msg_title">订单已支付完成！</h2>
            <p class="weui_msg_desc">订单编号：{$order->orderno}</p>
            <p class="weui_msg_desc">支付金额：<span style="color: #e60012;font-weight: bold;">{$order->realamount}</span></p>
        </div>
    {/if}
    <div class="weui_extra_area">
        <a href="/order/{$order->id}">查看详情</a>
    </div>
</div>

</body>
</html>