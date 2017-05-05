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
<title>订单确认</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style type="text/less">
    .invoiceinfo{
        padding-top: 10px;
        padding-left: 20px;
        padding-bottom: 20px;
        font-size: 16px;
        line-height: 28px;
        color: #666;

        .companyname{
            width: 90%;
            border: #ccc solid 1px;
            border-radius: 3px;
            padding: 5px;
            margin-top: 10px;
        }
    }


    .hidden{
        display: none;
    }

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

        .img_selected{
            position: absolute;
            right: 0;
            top:10px;
            display: none;
            width: 80px;
        }

        &.selected{
            .img_selected{
                display: block;
            }
         }

        &.disabled{
             color:#ebe9e7;
             background-color: #9b9791;
            .limit{
                color: #b6b2ad;
                background-color: #f9f9f7;
            }
        }
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
            'hideOptionMenu'
        ]
    });

    $(function(){

        wx.ready(function(){
            wx.hideOptionMenu();
        });

        calcTotalMoney();

        // 选择其他地址
        $('.address').on('click', function(){
            var addressid = $(this).attr('addressid');
           var acceptname = $(this).find('.acceptname').html();
           var mobile = $(this).find('.mobile').html();
           var fuladdr = $(this).find('.fuladdr').html();

            var strHtml = '';
            strHtml += '<h4 class="weui_media_title">收货人：'+acceptname+'</h4><p class="weui_media_desc"style="font-size: 14px;line-height: 20px;">联系电话：'+mobile+'</p><p class="weui_media_desc" style="font-size: 14px;line-height: 20px;">收货地址：'+fuladdr+'</p>';
            $('.selected_address').html(strHtml);
            $('input[name=addressid]').val(addressid);

            $('#address_popup .close-popup').trigger('click');
        });

        // 选择配送时间
        $('.delivery .weui_check_label').on('click', function(){
            var tp = $('input[name="deliverytime"]:checked').attr('tp');
            var tpname = $('input[name="deliverytime"]:checked').attr('tpname');

            $('input[name=deliverytimetp]').val(tp);
            $('.deliverytext').html(tpname);

            $('#delivery_popup .close-popup').trigger('click');
        });

        // 是否需要开发票 变化事件
        $('input[name="invoicetitle"]').change(function(){
            $('.companyname').toggleClass('hidden');
        });

        // 优惠券选择事件
        $('.couponitem').on('click', function(){
            if($(this).hasClass('disabled')){
                $.toptip('该优惠券不可用！', 'warning');
                return;
            }

            if (!$(this).hasClass('selected')){
                var cur_lower_limit = parseInt($(this).attr('lowerlimit'));
                var totalmoney = parseInt($(this).attr('totalmoney'));

                var total_limit_amount = 0;
                var nums = 0;
                var has_cash_coupon = false;
                $('.couponitem.selected').each(function(){
                    nums++;
                    if(parseInt($(this).attr('lowerlimit')) == 0){
                        has_cash_coupon = true;
                    }
                    total_limit_amount = total_limit_amount + parseInt($(this).attr('lowerlimit'));
                });

                if((has_cash_coupon || cur_lower_limit ==0) && nums > 0){
                    $.toptip('现金券不能和其他优惠券同时使用！', 'warning');
                    return;
                }

                if (total_limit_amount + cur_lower_limit > totalmoney){
                    $.toptip('该优惠券不可用！', 'warning');
                    return;
                }else{
                    $(this).addClass('selected');
                }
            }else{
                $(this).removeClass('selected');
            }


            // 单张优惠券 实现算法
//            var id = $(this).attr('id');
//            var amount = $(this).attr('amount');
//            $('#confirm_form input[name=couponids]').val(id);
//            $('#confirm_form input[name=couponamount]').val(amount);
//
//            $('.coupontext').html('[' + amount + '元优惠券' + ']');
//            $('#coupon_popup .close-popup').trigger('click');
//            calcTotalMoney();
        });
        // 完成优惠券选择
        $('.cancel_coupon').on('click', function(){
            if ($('.couponitem.selected').length == 0){
                $('#confirm_form input[name=couponids]').val('');
                $('#confirm_form input[name=couponamount]').val('0');
                $('.coupontext').html('[不使用优惠券]');
            }else{
                var total_coupon_amount = 0;
                var couponids = '';
                $('.couponitem.selected').each(function(){
                    total_coupon_amount += parseInt($(this).attr('amount'));
                    if (couponids == ''){
                        couponids = $(this).attr('couponid');
                    }else{
                        couponids += ',' + $(this).attr('couponid');
                    }
                });
                $('#confirm_form input[name=couponids]').val(couponids);
                $('#confirm_form input[name=couponamount]').val(total_coupon_amount);
                $('.coupontext').html(total_coupon_amount + '元优惠券');
            }

            $('#coupon_popup .close-popup').trigger('click');
            calcTotalMoney();
        });

        // 是否积分抵扣 改变事件
        $('#ispointdk').change(function(){
            $('.pointdk').toggleClass('hidden');
            calcTotalMoney();
        });

        // 是否佣金抵扣 改变事件
        $('#iscommissiondk').change(function(){
            $('.commissiondk').toggleClass('hidden');
            calcTotalMoney();
        });

        var submitflag = false;
        // 提交订单并微信支付
        $('.submit_order').on('click', function(){
            if(submitflag){
                return;
            }

            var addressid = parseInt($('input[name = addressid]').val());
            if(addressid == 0){
                $.alert('请选择收货地址！');
                return;
            }

            if($('#isinvoice').is(':checked')){
                $('#confirm_form input[name=isinvoice]').val('1');
                var invoicetp = $('input:radio[name=invoicetitle]:checked').val();
                if(invoicetp == '1'){
                    $('#confirm_form input[name=invoicetitle]').val('个人');
                }else{
                    var companyname = $.trim($('.companyname').val());
                    if(companyname == '')
                    {
                        $.alert('请输入发票抬头的单位名称！');
                        return;
                    }
                    $('#confirm_form input[name=invoicetitle]').val(companyname);
                }
            }else{
                $('#confirm_form input[name=isinvoice]').val('0');
                $('#confirm_form input[name=invoicetitle]').val('');
            }

            var userremark = $('.userremark').val();
            $('#confirm_form input[name=userremark]').val(userremark);

            submitflag = true;
            $.post('/order/submit_order', $('#confirm_form').serialize(), function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    submitflag = false;
                    location.href = '/order/online_charge/' + jd.data;
                }else{
                    $.alert(jd.msg);
                    submitflag = false;
                }
            }, 'json');
        });

    });

    // 计算应支付金额
    function calcTotalMoney(){
        var level = $('#userlevel').val();
        var totalmoney =  parseFloat($('#totalmoney').val());
        //应付金额
        $('#confirm_form input[name=payableamount]').val(totalmoney);

        // 判断是否超过了88 不满88收取5元快递费用
        var expressfee = 0;
        if(totalmoney < 88 && level != '017005'){ // 黑卡会员全部包邮
            expressfee = 5;
            $('.express span').html('+￥5.00');
            $('#confirm_form input[name=realfreight]').val('5');
        }else{
            $('.express span').html('+￥0.00');
            $('#confirm_form input[name=realfreight]').val('0');
        }

        // 处理优惠券
        var couponids = $('#confirm_form input[name=couponids]').val();
        if(couponids != ''){
            var couponamount = parseFloat($('#confirm_form input[name=couponamount]').val());
            if (couponamount > totalmoney){
                $('.coupondk span').html('-￥' + totalmoney.toFixed(2));
                $('#confirm_form input[name=couponamount]').val(totalmoney);
                totalmoney = 0;
            }else{
                totalmoney = totalmoney - couponamount;
                $('.coupondk span').html('-￥' + couponamount.toFixed(2));
            }
            $('.coupondk').removeClass('hidden');
        }else{
            $('.coupondk span').html('-￥0.00');
            $('.coupondk').addClass('hidden');
        }

        //如果是黑卡会员 执行88折价格
        if(level == '017005'){ // 黑卡会员 88折
            totalmoney = totalmoney*0.88;
            $('.blackzk span').html('￥' + totalmoney);
            $('.blackzk').removeClass('hidden');
        }
        // 会员折扣价
        $('#confirm_form input[name=discountamount]').val(totalmoney);

        // 返佣金基数
        $('#confirm_form input[name=commissionbase]').val(totalmoney);

        // 商品折扣价格 加上运费
        totalmoney = totalmoney + expressfee;
        var realmoney = totalmoney;

        // 处理积分抵扣
        var points = $('#pointmoney').attr('points');
        var pointmoney = parseFloat($('#pointmoney').attr('money'));

        if(!$('.pointdk').hasClass('hidden')){
            pointmoney = pointmoney <= totalmoney ? pointmoney : totalmoney;
            totalmoney -= pointmoney;
            realmoney -= pointmoney;
            $('.pointdk span').html('-￥'+pointmoney);
            $('#confirm_form input[name=points]').val(pointmoney*100);
            $('#confirm_form input[name=pointsamount]').val(pointmoney);
        }else{
            $('#confirm_form input[name=points]').val('0');
            $('#confirm_form input[name=pointsamount]').val('0');
        }

        // 处理佣金抵扣
        var commission = parseFloat($('#iscommissiondk').attr('commission'));
        if(!$('.commissiondk').hasClass('hidden')){
            if(totalmoney > 0){
                commission = commission <= totalmoney ? commission : totalmoney;
                totalmoney -= commission;
                realmoney -= commission;
            }else{
                commission = 0;
            }

            $('.commissiondk span').html('-￥' + commission);

            $('#confirm_form input[name=commissionamount]').val(commission);
        }else{
            $('#confirm_form input[name=commissionamount]').val('0');
        }

        //实付金额
        realmoney = realmoney < 0 ? 0 : realmoney;
        $('#confirm_form input[name=realamount]').val(realmoney.toFixed(2));

        // 核算最终价格
        $('.lastmoney span').html('￥'+totalmoney.toFixed(2));
        $('#confirm_form input[name=totalamount]').val(totalmoney.toFixed(2));
    }
</script>

</head>

<body ontouchstart>
<input id="userlevel" type="hidden" value="{$user->level}">
<form id="confirm_form">
    {if count($addresslist) gt 0}
        <input type="hidden" name="addressid" value="{$defaultaddress->id}">
    {else}
        <input type="hidden" name="addressid" value="0">
    {/if}

    <input type="hidden" name="deliverytimetp" value="015003">
    <input type="hidden" name="isinvoice" value="0">
    <input type="hidden" name="invoicetitle" value="">
    <input type="hidden" name="payableamount" value="0">
    <input type="hidden" name="discountamount" value="0">
    <input type="hidden" name="couponids" value="">
    <input type="hidden" name="couponamount" value="0">
    <input type="hidden" name="commissionbase" value="0">
    <input type="hidden" name="points" value="0">
    <input type="hidden" name="pointsamount" value="0">
    <input type="hidden" name="commissionamount" value="0">
    <input type="hidden" name="realamount" value="0">
    <input type="hidden" name="realfreight" value="0">
    <input type="hidden" name="totalamount" value="0">
    <input type="hidden" name="userremark" value="">
    <input type="hidden" name="cartids" value="{if isset($cartids)}{$cartids}{/if}">
</form>

<div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
    <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>订单确认
</div>

<div class="weui_panel weui_panel_access">

    <div class="weui_panel_bd">

        <a href="{if count($addresslist) eq 0}/profile/edit_address/0?from=confirm{else}javascript:;{/if}" class="weui_media_box weui_media_appmsg weui_cell {if count($addresslist) gt 0}open-popup{/if}" data-target="#address_popup">
            <div class="weui_media_hd" style="width: 20px;">
                <img class="weui_media_appmsg_thumb" src="/images/wechat/location.png" alt="">
            </div>
            <div class="weui_media_bd selected_address">
                {if count($addresslist) gt 0}
                    <h4 class="weui_media_title">收货人：{$defaultaddress->acceptname}</h4>
                    <p class="weui_media_desc" style="font-size: 14px;line-height: 20px;">联系电话：{$defaultaddress->mobile}</p>
                    <p class="weui_media_desc" style="font-size: 14px;line-height: 20px;">收货地址：{$defaultaddress->address}</p>
                {else}
                    <h4 style="color: #999;">点击添加新地址</h4>
                {/if}
            </div>
        </a>
    </div>
</div>

<div class="weui_panel weui_panel_access">
    <div class="weui_panel_bd">
        {$totalmoney = 0}
        {foreach from=$goodslist item="goods"}
            {$totalmoney = $totalmoney + $goods->totalmoney}
            <a href="/goods/{$goods->goodsid}" class="weui_media_box weui_media_appmsg" style="cursor: default;">
                <div class="weui_media_hd">
                    <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->specpic size = '78x78'}" alt="">
                </div>
                <div class="weui_media_bd" style="flex: 2;">
                    <p class="weui_media_desc" style="color: #333;line-height: 20px;">{$goods->goodsname}</p>
                </div>
                <div class="weui_media_bd">
                    <div class="fs20 fr">￥{$goods->sellprice}</div><br>
                    {*<div class="fs20 fr" style="text-decoration: line-through;color: #999;">￥{$goods->marketprice}</div><br>*}
                    <div class="fs20 fr" style="color: #999;">X {$goods->buynum}</div>
                </div>
            </a>
        {/foreach}
    </div>

    <div class="weui_cells weui_cells_form">
        <div class="weui_cell">
            <div class="weui_cell_bd weui_cell_primary">
                <textarea class="weui_textarea userremark" placeholder="请输入备注信息" rows="2"></textarea>
            </div>
        </div>
    </div>

</div>

<div class="weui_cells weui_cells_access">
    <a class="weui_cell open-popup" href="javascript:;"  data-target="#delivery_popup">
        <div class="weui_cell_bd weui_cell_primary">
            <p>配送时间</p>
        </div>
        <div class="weui_cell_ft deliverytext" style="font-size: 14px;">工作日、周末、节假日均可</div>
    </a>
</div>

<div class="weui_cells weui_cells_form" style="margin-top: 0; display: none;">
    <div class="weui_cell weui_cell_switch" style="">
        <div class="weui_cell_hd weui_cell_primary">开具发票</div>
        <div class="weui_cell_ft">
            <input id="isinvoice" class="weui_switch" type="checkbox" onchange="$('.invoiceinfo').toggleClass('hidden');">
        </div>
    </div>
    <div class="invoiceinfo hidden">
        <div>发票类型：普通发票（纸质）</div>
        <div>发票内容：明细</div>
        <div>发票抬头：<input id="private" name="invoicetitle" type="radio" value="1" checked style="margin-left: 10px;"/><label for="private">个人</label><input id="company" class="ml10" name="invoicetitle" type="radio" value="2" style="margin-left: 10px;"/><label for="company">单位</label> </div>
        <input class="weui_input companyname hidden" type="text" placeholder="请输入单位名称">
    </div>

</div>

<div class="weui_cells weui_cells_access" style="margin-top: 0;">
    <a class="weui_cell open-popup" href="javascript:;"  {if count($couponlist) gt 0}data-target="#coupon_popup"{/if}>
        <div class="weui_cell_bd weui_cell_primary">
            <p>优惠券</p>
        </div>
        <div class="weui_cell_ft coupontext" style="font-size: 14px;">{if count($couponlist) eq 0}无可用优惠券{else}请选择{/if}</div>
    </a>
</div>

{if $user->points gt 0}
    <div class="weui_cells weui_cells_form" style="margin-top: 0;">
        <div class="weui_cell weui_cell_switch" style="">
            <div class="weui_cell_hd weui_cell_primary">积分 <div style="display: inline-block;margin-left: 15px;">共<span style="color:#e60012;">{$user->points}</span>分，{if $user->points gte 1000} 可抵<span id = "pointmoney" style="color:#e60012;" points="{$user->points}" money="{($user->points/100.00)|string_format:"%.2f"}">￥{$user->points/100.00}</span>{else} 满1000分可用{/if}</div> </div>
            {if $user->points gte 1000}
                <div class="weui_cell_ft">
                    <input id="ispointdk" class="weui_switch" type="checkbox">
                </div>
            {/if}
        </div>
    </div>
{/if}

{if $user->commission gt 0}
    <div class="weui_cells weui_cells_form" style="margin-top: 0;">
        <div class="weui_cell weui_cell_switch" style="">
            <div class="weui_cell_hd weui_cell_primary">佣金 <div style="display: inline-block;margin-left: 15px;">共<span style="color:#e60012;">￥{$user->commission}</span> </div></div>
            <div class="weui_cell_ft">
                <input id="iscommissiondk" commission="{$user->commission}" class="weui_switch" type="checkbox">
            </div>
        </div>
    </div>
{/if}




<div class="weui_panel weui_panel_access">
    <div class="weui_panel_bd" style="padding: 10px 15px; color: #333;line-height: 26px;">
        <input id="totalmoney" type="hidden" value="{$totalmoney|string_format:"%.2f"}">
        <div>商品总金额：<span style="float: right;">￥{$totalmoney|string_format:"%.2f"}</span></div>
        <div class="coupondk hidden">优惠券：<span style="float: right;">-￥0.00</span></div>
        <div class="blackzk hidden">会员折扣价：<span style="float: right;">￥0.00</span></div>
        <div class="express">运费：<span style="float: right;">+￥0.00</span></div>
        <div class="pointdk hidden">积分抵扣：<span style="float: right;">-￥0.00</span></div>
        <div class="commissiondk hidden">佣金抵扣：<span style="float: right;">-￥0.00</span></div>
        <div class="lastmoney" style="color: #666;">总额（含运费）：<span style="float: right;color:#e60012;font-size: 18px;font-weight: bold;">￥0.00</span></div>

    </div>
</div>

<a href="javascript:void(0);" class="submit_order weui_btn weui_btn_primary" style="width: 90%; margin-top: 20px;margin-bottom: 50px;background-color: #e60012;">提交订单</a>

<div style="height: 30px;width: 100%;">

</div>


<div id="address_popup" class='weui-popup-container'>
    <div class="weui-popup-modal addresslist" style="background-color: #FFF;">
        <div class="weui_cells_title">请选择送货地址 <a class="fr  close-popup" href="/profile/address" style="color: #e70012;">管理</a> </div>
        {foreach from=$addresslist item="item"}
            <div class="weui_panel weui_panel_access address" addressid="{$item->id}" style="cursor: pointer;">
                <div class="weui_panel_bd">
                    <div class="weui_media_box weui_media_text">
                        <h4 class="weui_media_title" style="font-size:16px;color: #666;line-height: 30px;"><span class="acceptname">{$item->acceptname}</span><span class="fr mobile">{$item->mobile}</span></h4>
                        <p class="weui_media_desc fuladdr" style="font-size: 16px;color: #666;line-height: 30px;">{if $item->isdefault eq '1'}<span style="color: #e70012;font-size: 14px;">[默认地址]</span>{/if}{$item->address}</p>
                    </div>
                </div>
            </div>
        {/foreach}

        {*<div style="padding: 0 20px;margin-top: 50px;">*}
            {*<a href="/profile/address" class="weui_btn weui_btn_plain_primary manage_address" style="color:#e80212; font-size: 16px; border: #e80212 solid 1px;">管理收货地址</a>*}
        {*</div>*}
    </div>
</div>

<div id="delivery_popup" class='weui-popup-container popup-bottom' style="background-color: rgba(0,0,0,0.5);">
    <div class="weui-popup-modal">
        <div class="toolbar">
            <div class="toolbar-inner">
                <a href="javascript:;" class="picker-button close-popup">完成</a>
                <h1 class="title">请选择配送时间</h1>
            </div>
        </div>
        <div class="modal-content">
            <div class="weui_cells weui_cells_radio delivery">
                <label class="weui_cell weui_check_label" for="x11">
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>仅工作日送货</p>
                    </div>
                    <div class="weui_cell_ft">
                        <input type="radio" class="weui_check" name="deliverytime" id="x11"  tp="015001" tpname="仅工作日">
                        <span class="weui_icon_checked"></span>
                    </div>
                </label>
                <label class="weui_cell weui_check_label" for="x12">

                    <div class="weui_cell_bd weui_cell_primary">
                        <p>仅周末送货</p>
                    </div>
                    <div class="weui_cell_ft">
                        <input type="radio" name="deliverytime" class="weui_check" id="x12" checked="checked" tp="015002" tpname="仅周末">
                        <span class="weui_icon_checked"></span>
                    </div>
                </label>
                <label class="weui_cell weui_check_label" for="x13">

                    <div class="weui_cell_bd weui_cell_primary">
                        <p>工作日、周末、节假日均可</p>
                    </div>
                    <div class="weui_cell_ft">
                        <input type="radio" name="deliverytime" class="weui_check" id="x13" checked="checked"  tp="015003" tpname="工作日、周末、节假日均可">
                        <span class="weui_icon_checked"></span>
                    </div>
                </label>
            </div>
        </div>
    </div>
</div>

<div id="coupon_popup" class='weui-popup-container'>
    <div class="weui-popup-modal" style="background-color: #FFF;">
        <div class="weui_cells_title">请选择优惠券<a class="fr cancel_coupon" href="javascript:;" style="color: #e70012;">完成</a></div>

        {if count($couponlist) eq 0}
            <div style="margin: auto 0;line-height: 100px;width: 100%;text-align: center;">您没有优惠券</div>
        {/if}

        {foreach from=$couponlist item="item"}
            <div class="couponitem {if $totalmoney lt $item->lowerlimit}disabled{/if}" couponid="{$item->id}" amount="{$item->amount}" lowerlimit="{$item->lowerlimit}" totalmoney="{$totalmoney}">
                <img class="img_selected" src="/images/wechat/coupon_selected.png">
                <div class="leftdiv">
                    <div class="amount"><span style="font-size: 16px;">￥</span>{$item->amount|string_format:"%.2f"}</div>
                    <div class="limit">满{$item->lowerlimit}元可用</div>
                </div>
                <div class="rightdiv">
                    <p>优惠券</p>
                    <p>{$item->info}</p>
                    <p>{$item->begindate}至{$item->expiredate}</p>
                </div>
            </div>
        {/foreach}

        <div style="padding: 0 20px;margin-top: 50px;display: none;">
            <a href="javascript:;" class="weui_btn weui_btn_plain_primary close-popup" style="color:#e80212; border: #e80212 solid 1px;">完成</a>
        </div>
    </div>
</div>

</body>
</html>