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
<title>购物车 - AYE阿野</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">

    .nums{
        display: block;
        padding:5px 0;
        vertical-align: middle;
        a{
            display: inline-block;
            width: 20px;
            height: 20px;
            border:#d0d0d0 solid 1px;
            text-align:center;
            line-height:20px;
            color:#333;
            &.minus{
                 vertical-align: top;
             }
            &.add{
                 vertical-align: top;
             }
        }
        .num{
            display: inline-block;
            width: 40px;
            height: 20px;
            border:#d0d0d0 solid 1px;
            text-align: center;
            vertical-align: top;
            font-size: 14px;
            line-height: 20px;
        }
    }

    .footerdiv{
        width: 100%;
        height: 50px;
        background-color: #fff;
        border-top: 1px solid #CCC;
        position: fixed;
        left: 0px;
        bottom: 55px;
        z-index: 9;
        .checkall{
            display: inline-block;
            line-height: 50px;
            margin-left: 15px;
            padding-left: 24px;
            color: #333;
            background: url(/images/wechat/cart_uncheck.png) no-repeat 0 14px;
            &.selected{
                 background: url(/images/wechat/cart_checked.png) no-repeat 0 14px;
             }
        }
        .sumdiv{
            float: right;
            line-height: 50px;
            color: #666;
        }
        .tobuy{
            display: inline-block;
            width: 30%;
            line-height: 50px;
            text-align: center;
            margin-left: 20px;
            float: right;
            color: #FFF;
            background-color:#e7011f;
            &.disabled{
                 background: #e5e5e5;
                 color: #9c9c9c;
                 cursor: not-allowed;
             }
        }
    }
</style>

<script type="text/javascript">

    /**
     * 计算商品总额 和 应付金额
     */
    function calcMoney(){
        var payablemoney = 0 ;
        var selectednum = 0;
        $('.totalmoney').each(function(){
            var money = parseFloat($(this).html());
            if($(this).closest('.goods').find('.check').hasClass('selected')){
                payablemoney = payablemoney + money;
                selectednum ++;
            }
        });

        $('.payablemoney').html(payablemoney.toFixed(2));
//        $('.selectednum').html(selectednum);

        if(selectednum == 0){
            $('.tobuy').addClass('disabled');
        }else{
            $('.tobuy').removeClass('disabled');
        }
    }

    $(function(){
        // 计算商品金额 和 应付金额
        calcMoney();
        /**
         * 单个商品的选择
         */
        $('.check').on('click', function(){
            if ($(this).hasClass('selected')){
                $(this).removeClass('selected').attr('src', '/images/wechat/cart_uncheck.png');
                if ($('.check.selected').length < $('.goods').length){
                    $('.checkall').removeClass('selected');
                }
            }else{
                $(this).addClass('selected').attr('src', '/images/wechat/cart_checked.png');
                if ($('.check.selected').length == $('.goods').length){
                    $('.checkall').addClass('selected');
                }
            }
            calcMoney();
        });

        /**
         * 全选 全消
         */
        $('.checkall').on('click', function(){
            if ($(this).hasClass('selected')){
                $(this).removeClass('selected');
                $('.check').removeClass('selected').attr('src', '/images/wechat/cart_uncheck.png');
            }else{
                $(this).addClass('selected');
                $('.check').addClass('selected').attr('src', '/images/wechat/cart_checked.png');
            }
            calcMoney();
        });

        var minusflag = false;
        /**
         * 数量减少
         */
        $('.minus').on('click', function () {
            if(minusflag){
                return;
            }
            var numobj = $(this).parent().find('.num');
            var num = parseInt(numobj.val());
            if(num > 1){
                var cartid = $(this).attr('cartid');
                minusflag = true;
                $.post("/cart/minus_buynum",{ cartid:cartid},function(jd){
                    {redirecturl url='home/signin'}
                    if (jd.success) {
                        num = num - 1;
                        numobj.val(num);

                        var price = parseFloat(numobj.closest('.goods').find('.sellprice').html());
                        var totalmoney = price * num ;
                        numobj.closest('.goods').find('.totalmoney').html(totalmoney.toFixed(2));

                        calcMoney();
                        minusflag = false;
                    } else {
                        $.toast('操作失败');
                        minusflag = false;
                    }
                },"json");
            }
        }) ;

        var addflag = false;
        /**
         * 数量增加
         */
        $('.add').on('click', function () {
            if(addflag){
                return;
            }

            var numobj = $(this).parent().find('.num');
            var num = parseInt(numobj.val()) + 1;
            var cartid = $(this).attr('cartid');
            addflag = true;
            $.post("/cart/add_buynum",{ cartid:cartid},function(jd){
                {redirecturl url='home/signin'}
                if (jd.success) {
                    numobj.val(num);

                    var price = parseFloat(numobj.closest('.goods').find('.sellprice').html());
                    var totalmoney = price * num ;
                    numobj.closest('.goods').find('.totalmoney').html(totalmoney.toFixed(2));

                    calcMoney();

                    addflag = false;
                } else {
                    $.toast('操作失败');
                    addflag = false;
                }
            },"json");
        }) ;


        // 删除单一的商品
        $('.cart_del').on('click', function(){
            var cartid = $(this).attr('cartid');
            var parentobj = $(this).closest('.goods');

            $.confirm("您确定要删除该商品吗?", "确认删除?", function() {
                $.post("/cart/del_one_goods",{ cartid:cartid},function(jd){
                    {redirecturl url='home/signin'}
                    if (jd.success) {
                        parentobj.hide('normal', function() {
                            parentobj.remove();
                            calcMoney();
                        });
                    }else{
                        $.toast('删除失败');
                    }
                },"json");
            }, function() {
                //取消操作
            });
        });

        /**
         * 去结算操作
         */
        $('.tobuy').on('click', function(){
            var cartids = '';
            $('.check.selected').each(function(){
                var cartid = $(this).attr('cartid');
                if(cartids == ''){
                    cartids = cartid;
                }else{
                    cartids += ','+cartid;
                }
            });

            $.post('/cart/order_confirm', { cartids:cartids}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    location.href = '/order/confirm';
                }
            }, 'json');


        });
    });
</script>

</head>

<body ontouchstart>

<div class="weui_tab">

    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>购物车
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 150px;">
        {foreach from=$goodslist item="goods"}
            <div class="weui_media_box weui_media_appmsg goods" goodsid = "{$goods->goodsid}" style="border-bottom: 1px solid #e5e5e5;background-color: #fff;">
                <div class="weui_cell_hd">
                    <img class="check selected" src="/images/wechat/cart_checked.png" alt="" cartid="{$goods->id}" style="width:20px;margin-right:15px;display:block;">
                </div>
                <div class="weui_media_hd" style="width: 78px;height: 78px;">
                    <a href="/goods/{$goods->goodsid}"><img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->specpic size = '78x78'}" alt="" style="border: #eee solid 1px;border-radius: 3px;"></a>
                </div>
                <div class="weui_media_bd" style="flex: 5;">
                    <p class="weui_media_desc" style="color: #333;line-height: 24px;-webkit-line-clamp: 1;">{$goods->goodsname}</p>
                    <p class="weui_media_desc" style="color: #999;line-height: 24px;">尺码颜色：{$goods->specname1} {$goods->specname2} </p>
                    <div class="nums">
                        <a class="minus" href="javascript:void(0);" cartid="{$goods->id}">-</a><input readonly="readonly" type="text" class="num" value="{$goods->buynum}" maxlength="3" onkeyup="parseInt(value) == 0 || value == '' ? value = 1 : value = value.replace(/[^\d]/g,'')" style="background-color: #f5f5f5;"/><a class="add" href="javascript:void(0);" cartid="{$goods->id}">+</a>
                    </div>
                </div>
                <div class="weui_media_bd" style="flex: 2;line-height: 24px;font-size: 13px;margin-bottom: 14px;">
                    <p style="text-align: right;color:#f29902;">￥<span class="sellprice">{$goods->sellprice}</span></p>
                    <p style="text-decoration: line-through;color: #999;text-align: right;font-size: 12px;">￥{$goods->marketprice}</p>
                    <p class="totalmoney" style="display: none;">{$goods->sellprice*$goods->buynum }</p>
                    <div style="width: 100%;">
                        <a class="cart_del" href="javascript:;"  cartid="{$goods->id}" style="display: block;float: right;width: 30px;height: 16px;">
                            <img src="/images/wechat/cart_del.png">
                        </a>
                    </div>
                </div>
            </div>
        {/foreach}
    </div>

    <div class="footerdiv">
        <a class="checkall selected" href="javascript:void(0);">全选</a>

        <a href="javascript:;" class="tobuy">去结算</a>
        <span class="sumdiv">总计：<label class="payablemoney" style="color:#e7011f;font-weight: bold;">0.00</label></span>
    </div>

</div>

{$page = 'cart'}
{include file="footer.tpl"}

</body>
</html>