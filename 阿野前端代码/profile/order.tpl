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
<title>我的订单</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
    .weui_navbar{
        background-color:#fff;
    }

    .weui_navbar_item.weui_bar_item_on {
        color: #E60111;
        background-color:#fff;
    }

</style>

<script type="text/javascript">
    $(function(){
        $('.weui_navbar_item').on('click', function(){
//           $(this).addClass('weui_bar_item_on').siblings().removeClass('weui_bar_item_on');
            var status = $(this).attr('status');
            if(status == ''){
                location.href = '/profile/order';
            }else{
                location.href = '/profile/order?status='+status;
            }
        });

        // 取消订单
        $('.cancel_order').on('click', function(){
            var orderid = $(this).attr('orderid');
            $.confirm("您确定要取消该订单吗?", "确认取消?", function() {

                $.post('/order/cancel_order', { orderid:orderid}, function(jd){
                    if (jd.success){
                        $('.stausname[orderid="'+orderid+'"]').html('订单已取消');
                        $('.operatediv[orderid="'+orderid+'"]').html('');

                        $.toast("订单已取消!");
                    }else{ //
                        $.toast(jd.msg);
                    }

                }, 'json');

            }, function() {
                //取消操作
            });
        });
    });
</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>我的订单
    </div>

    <div class="weui_navbar" style="margin-top: 48px;">
        <div class="weui_navbar_item {if $status eq ""}weui_bar_item_on{/if}" status = "">
            全部
        </div>
        <div class="weui_navbar_item {if $status eq "008001"}weui_bar_item_on{/if}" status = "008001">
            待付款
        </div>
        <div class="weui_navbar_item {if $status eq "008002,008003"}weui_bar_item_on{/if}" status = "008002,008003">
            待发货
        </div>
        <div class="weui_navbar_item {if $status eq "008004"}weui_bar_item_on{/if}" status = "008004">
            待收货
        </div>
        <div class="weui_navbar_item {if $status eq "008005,008006"}weui_bar_item_on{/if}" status = "008005,008006">
            待评价
        </div>
    </div>
    <div class="weui_tab_bd" style="padding-bottom:110px;">

        {if count($orderlist) eq 0}
            <div style="width: 100%;line-height: 100px;text-align: center;color: #666;">您还没有该类型订单</div>
        {/if}

        {foreach from = $orderlist item="item"}
        <div class="weui_panel weui_panel_access orderdiv" style="margin-top: 1.17em;">
            <div class="weui_cells" style="margin-top: 0;">
                <div class="weui_cell">
                    <div class="weui_cell_bd weui_cell_primary">
                        <p style="font-size: 14px;">订单编号：{$item->orderno}</p>
                    </div>
                    <div class="weui_cell_ft stausname" orderid="{$item->id}" style="color: #e91021;font-size: 14px;">{$item->statusname}</div>
                </div>
            </div>

            <div class="weui_panel_bd">
                {foreach from=$item->goods item="goods"}
                    <a href="/order/{$item->id}" class="weui_media_box weui_media_appmsg" style="cursor: default;">
                        <div class="weui_media_hd">
                            <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->imgurl size = '78x78'}" alt="" style="border: #eee solid 1px;border-radius: 3px;">
                        </div>
                        <div class="weui_media_bd" style="flex: 2;">
                            <p class="weui_media_desc" style="color: #333;line-height: 20px;font-size: 14px;">{$goods->goodsname}</p>
                        </div>
                        <div class="weui_media_bd" style="font-size: 14px;">
                           <div class="fr">￥{$goods->realprice}</div><br>
                           <div class="fr" style="text-decoration: line-through;color: #999;">￥{$goods->marketprice}</div><br>
                           <div class="fr" style="color: #999;">X {$goods->goodsnums}</div>
                        </div>
                    </a>
                {/foreach}
            </div>
            <div class="weui_cells">
                <div class="weui_cell">
                    <div class="weui_cell_bd weui_cell_primary">

                    </div>
                    <div class="weui_cell_ft" style="font-size: 16px;">
                        <div style="color: #666;">共{count($item->goods)}件商品 合计：<span style="color:#f28f00; ">￥{$item->payableamount}</span></div>
                        <div style="color: #999;">(含运费：￥{$item->realfreight})</div>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_bd weui_cell_primary">

                    </div>
                    <div class="weui_cell_ft operatediv" orderid="{$item->id}">
                        {if $item->status eq '008001'}
                            <a href="javascript:;" class="weui_btn weui_btn_mini weui_btn_default cancel_order" orderid="{$item->id}" style="line-height: 2;background-color:#fff;border: #a1a1a1 solid 1px;color: #a1a1a1;border-radius: 10px;">取消订单</a>
                            <a href="/order/online_charge/{$item->id}" class="weui_btn weui_btn_mini weui_btn_primary" style="line-height: 2;background-color:#fff;border: #e60111 solid 1px;color: #e60111;border-radius: 10px;">立即支付</a>
                        {/if}
                        {if $item->status eq '008002' || $item->status eq '008003'}
                            <a href="javascript:;" class="weui_btn weui_btn_mini weui_btn_default cancel_order" orderid="{$item->id}" style="line-height: 2;background-color:#fff;border: #a1a1a1 solid 1px;color: #a1a1a1;border-radius: 10px;">取消订单</a>
                        {/if}
                        {if $item->status eq '008005' || $item->status eq '008006'}
                            <a href="/order/comment_list/{$item->id}" class="weui_btn weui_btn_mini weui_btn_primary" style="line-height: 2;background-color:#fff;border: #e60111 solid 1px;color: #e60111;border-radius: 10px;">去评价</a>
                        {/if}

                    </div>
                </div>
            </div>
        </div>
        {/foreach}

    </div>

    {$page = 'order'}
    {include file="footer.tpl"}
</div>


</body>
</html>