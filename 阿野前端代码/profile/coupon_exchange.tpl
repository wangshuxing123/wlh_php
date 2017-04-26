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
<title>优惠券兑换</title>

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
        var save_flag = false;
        // 兑换优惠券
        $('#exchange').on('click', function(){
            if (save_flag){
               return;
            }
            var coupon_code = $.trim($('#coupon_code').val());
            if(coupon_code == ''){
                $.alert('请输入优惠码！');
                return;
            }
            save_flag = true;
            $.post('/profile/exchange', { coupon_code:coupon_code}, function(jd){
                save_flag = false;
                if(jd.success){
                   $('#exchange_result').html(jd.data).show();
               }
            }, 'json');

        });
    });

</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>优惠券兑换
    </div>

    <div class="weui_cells weui_cells_form">

        <div class="weui_cells_title"></div>
        <div class="weui_cells weui_cells_form">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <textarea id="coupon_code" class="weui_textarea" placeholder="请输入优惠码，多个用英文逗号隔开，例如AYE0001,AYE0002" rows="3"></textarea>
                </div>
            </div>
        </div>
    </div>
    <div class="weui_btn_area">
        <a id="exchange" class="weui_btn weui_btn_primary" href="javascript:" style="background-color: #e7011f;">立即兑换</a>
    </div>

    <div id="exchange_result" style="margin:20px 15px;text-align: center;line-height: 36px;font-size: 14px;color: #666;display: none; ">

    </div>


    {$page = 'profile'}
    {include file="footer.tpl"}
</div>


</body>
</html>