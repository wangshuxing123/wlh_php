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
<title>售后进度查询</title>

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
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>售后进度查询
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">
        <form id="applyform">
    <input id="orderid" name="orderid" type="hidden" value="{$orderid}">
    <input id="orderno" name="orderno" type="hidden" value="{$goods->orderno}">
    <input id="productid" name="productid" type="hidden" value="{$goods->productid}">


    <div class="weui_panel weui_panel_access">
        <div class="weui_panel_hd">售后状态：<span style="color: #e60111;">{$returninfo->statusname}</span></div>
    </div>

    <div class="weui_panel weui_panel_access">
        <div class="weui_panel_bd">
            <a href="javascript:void(0);" class="weui_media_box weui_media_appmsg" style="cursor: default;">
                <div class="weui_media_hd">
                    <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->imgurl size = '80x80'}" alt="">
                </div>
                <div class="weui_media_bd">
                    <p class="weui_media_desc" style="color: #333;line-height: 20px;">{$goods->goodsname}</p>
                    <p class="weui_media_desc" style="color: #666;line-height: 20px;">{$goods->spec}，售后数量：{$returninfo->nums}</p>
                </div>
            </a>
        </div>
    </div>

    <div class="weui_panel weui_panel_access">
        <div class="weui_panel_hd">售后信息</div>
        <div class="weui_panel_bd">
            <div class="weui_media_box weui_media_text">
                <p class="weui_media_desc">售后类型：{if $returninfo->tp eq '026001'}退货{else}换货{/if}</p>
            </div>
            {if $returninfo->tp eq '026001'}
                {if $returninfo->rstatus eq '025001' || $returninfo->rstatus eq '025002'}
                    <div class="weui_media_box weui_media_text">
                        <p class="weui_media_desc">退款金额：将在仓库收到商品后显示</p>
                    </div>
                {elseif $returninfo->rstatus eq '025004'}
                    <div class="weui_media_box weui_media_text">
                        <p class="weui_media_desc" style="line-height: 24px;">现金退款：<span style="color: #e60111;">￥{$returninfo->ramount}</span></p>
                        <p class="weui_media_desc" style="line-height: 24px;">佣金返还：<span style="color: #e60111;">￥{$returninfo->rcommission}</span></p>
                    </div>
                {/if}
            {/if}
            <div class="weui_media_box weui_media_text">
                <p class="weui_media_desc">返回方式：客户邮寄</p>
            </div>
            {if $returninfo->rstatus eq '025001'}
                <div class="weui_media_box weui_media_text">
                    <p class="weui_media_desc">邮寄信息：将在售后申请通过后显示</p>
                </div>
            {else}
                <div class="weui_media_box weui_media_text">
                    <p class="weui_media_desc" style="line-height: 24px;">邮寄信息：北京阿野信息技术有限公司  400-007-8949</p>
                    <p class="weui_media_desc" style="line-height: 24px;">邮寄地址：北京市大兴区天河北路9号百利威二分公司9-6号库</p>
                </div>
            {/if}
        </div>
    </div>
</form>
    </div>

    {$page = 'order'}
    {include file="footer.tpl"}
</div>
</body>
</html>