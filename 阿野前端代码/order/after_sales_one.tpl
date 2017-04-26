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
<title>申请售后</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
    .nums{
        display: inline-block;
        padding:5px 0;
        vertical-align: middle;
        a{
            display: inline-block;
            width: 30px;
            height: 30px;
            border:#d0d0d0 solid 1px;
            vertical-align: middle;
            &.minus{
                 background:url(/images/www/minus.png) no-repeat 9px 14px;
             }
            &.add{
                 background:url(/images/www/add.png) no-repeat 9px 9px;
             }
            &:hover{
                 border:#f65857 solid 1px;
                &.minus{
                     background:url(/images/www/minus_hover.png) no-repeat 9px 14px #f65857;
                 }
                &.add{
                     background:url(/images/www/add_hover.png) no-repeat 9px 9px #f65857;
                 }
            }
        }
        .num{
            display: inline-block;
            width: 60px;
            height: 30px;
            /*margin: 0 1px;*/
            border:#d0d0d0 solid 1px;
            text-align: center;
            vertical-align: middle;
            font-size: 16px;
            line-height: 30px;
        }
        .store{
            display: inline-block;
            font-size: 12px;
            line-height: 30px;
            margin-left: 10px;
            color: #999;
            vertical-align:middle;
            .storenum{
                padding: 0 2px;
                color: #e60012;
            }
        }
    }
</style>

<script type="text/javascript">
    $(function(){

        /**
         * 数量减少
         */
        $('.minus').on('click', function () {
            var num = parseInt($('.num').val());
            if(num > 1){
                $('.num').val(num-1);
            }
        }) ;

        /**
         * 数量增加
         */
        $('.add').on('click', function () {
            var num = parseInt($('.num').val());
            var buynums = parseInt($('#buynums').val());
            if(num < buynums){
                $('.num').val(num + 1);
            }else{
                $('.store').css('color', 'red');
            }
        }) ;

        var save_flag = false;
        // 提交
        $('#confirm').on('click', function(){
            if(save_flag){
                return;
            }
            save_flag = true;
            $.post('/order/apply_after_sales', $('#applyform').serialize(), function(jd){
                if(jd.success){
                    save_flag = false;
                    $.toast('提交成功！');
                    location.href = '/order/after_sales_list/{$orderid}';
                }else{
                    save_flag = false;
                    $.toast('保存失败！');
                }
            }, 'json');
        });

    });
</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>申请售后
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">
        <form id="applyform">
    <input id="orderid" name="orderid" type="hidden" value="{$orderid}">
    <input id="orderno" name="orderno" type="hidden" value="{$goods->orderno}">
    <input id="goodsid" name="goodsid" type="hidden" value="{$goods->goodsid}">
    <input id="productid" name="productid" type="hidden" value="{$goods->productid}">
    <input id="buynums" type="hidden" value="{$goods->goodsnums}">

    <div class="weui_panel weui_panel_access">
        <div class="weui_panel_bd">
            <a href="javascript:void(0);" class="weui_media_box weui_media_appmsg" style="cursor: default;">
                <div class="weui_media_hd">
                    <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->imgurl size = '80x80'}" alt="">
                </div>
                <div class="weui_media_bd">
                    <p class="weui_media_desc" style="color: #333;line-height: 20px;">{$goods->goodsname}</p>
                    <p class="weui_media_desc" style="color: #666;line-height: 20px;">{$goods->spec} &nbsp;&nbsp;数量：{$goods->goodsnums}</p>
                </div>
            </a>
        </div>

    </div>

    <div class="weui_cells_title">请选择售后类型</div>
    <div class="weui_cells weui_cells_radio">
        <label class="weui_cell weui_check_label" for="x11">
            <div class="weui_cell_bd weui_cell_primary">
                <p>我要退货</p>
            </div>
            <div class="weui_cell_ft">
                <input type="radio" class="weui_check" name="tp" id="x11" checked="checked" value="026001">
                <span class="weui_icon_checked"></span>
            </div>
        </label>
        <label class="weui_cell weui_check_label" for="x12">
            <div class="weui_cell_bd weui_cell_primary">
                <p>我要换货</p>
            </div>
            <div class="weui_cell_ft">
                <input type="radio" name="tp" class="weui_check" id="x12" value="026002">
                <span class="weui_icon_checked"></span>
            </div>
        </label>
    </div>

    <div class="weui_cells">
        <div class="weui_cell">
            <div class="weui_cell_bd weui_cell_primary">
                <div style="display: inline-block;vertical-align: middle;">数量：</div>
                <div class="nums">
                    <a class="minus" href="javascript:void(0);"></a><input type="text" class="num" name="nums" value="1" maxlength="3" onkeyup="parseInt(value) == 0 || value == '' ? value = 1 : parseInt(value)>parseInt({$goods->goodsnums}) ? value = {$goods->goodsnums} : value = value.replace(/[^\d]/g,'')"/><a class="add" href="javascript:void(0);"></a>
                    <span class="store">您最多可提交数量为<label class="storenum">{$goods->goodsnums}</label></span>
                </div>
            </div>
        </div>
    </div>

    <div class="weui_cells_title">问题描述</div>
    <div class="weui_cells weui_cells_form">
        <div class="weui_cell">
            <div class="weui_cell_bd weui_cell_primary">
                <textarea class="weui_textarea" name="reason" placeholder="请在此描述详细问题" rows="3" style="font-size: 14px;"></textarea>
            </div>
        </div>
    </div>

    <div class="weui_btn_area">
        <a class="weui_btn weui_btn_primary" href="javascript:" id="confirm" style="background-color:#e60012; ">提交申请</a>
    </div>
</form>
    </div>
    {$page = 'order'}
    {include file="footer.tpl"}
    </div>
</body>
</html>