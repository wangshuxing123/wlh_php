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
<title>我的收益</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
    .dyrdiv{
        margin-top:15px;padding: 0 20px;text-align:center;
    .dyr{
        border: #e5e6e5 solid 1px;padding-top: 10px;background-color: #fff;
    .num{
        font-size: 14px;color: #999;
    }
    .shouyi{
        color: #333;font-size: 16px;
    }
    .title{
        color: #666;font-size: 14px;
    }
    .level{
        display:block;width: 100%;height: 40px;margin-top:10px;color: #fff;line-height: 40px;
    }
    }
    }

    table, caption, tbody, tfoot, thead, tr, th, td{
        margin: 0;
        padding: 0;
        border: 0;
        outline: 0;
        font-size: 100%;
        vertical-align: baseline;
        background: transparent;
    }

    .withdraw{
        width: 90%;
        padding: 0;
        border-top:#ccc solid 1px;
        border-left:#ccc solid 1px;
    th,td{
        font-weight: normal;
        border-right:#ccc solid 1px;
        border-bottom:#ccc solid 1px;
    }
    }
</style>

<script type="text/javascript">

    $(function(){
        $(document).on("click", ".withdrawbtn", function() {
            var commission = parseFloat($(this).attr('commission'));
            $.alert(commission);
            if(commission < 50){
                $.alert('可提现金额需高于50元方可申请提现！');
                return;
            }

            $.prompt("最小提现金额为50元", "请输入提现金额", function(text) {
                var amount = parseFloat(text);
                if(!amount || amount < 0){
                    $.alert('提现金额输入不合法！');
                }else if(amount < 50){
                    $.alert('单次最小提现金额为50元！');
                }else if(amount > 200){
                    $.alert('单次最大提现金额为200元！');
                }else{
                    $.post('/profile/apply_withdraw', { amount:amount}, function(jd){
                        if(jd.success){
                            $.alert('已成功提交申请！');
                            var mydate = new Date();
                            var month = mydate.getMonth()+1;
                            month = (100+month).substr(1);
                            var mytime = mydate.getFullYear() + '-' + month + '-' + mydate.getDate() + ' ' + mydate.getHours() + ':' + mydate.getMinutes() + ':' + mydate.getSeconds();
                            $('.withdraw tr').eq(0).after('<tr><td>' + amount.toFixed(2) + '</td><td>' + mytime + '</td><td>审核中</td></tr>');
                        }else{
                            $.alert(jd.msg);
                        }
                    }, 'json')
                }
            }, function() {
                //取消操作
            });
        });

        /**
         *显示提现列表
         */
        $('#show_withdraw').on('click', function(){
            $('#withdrawdiv').show();
            $(this).hide();
        });
    });



</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>我的收益
    </div>
    <div class="weui_tab_bd" style="padding-bottom: 150px;padding-top: 0;">
        <div class="weui_panel weui_panel_access">
            <div class="weui_panel_bd" style="background-color: #e70012;padding: 10px 0;">
                <div class="weui_media_box weui_media_appmsg">
                    <div class="weui_media_hd">
                        <img class="weui_media_appmsg_thumb" src="{$user->avatar}" alt="" style="border-radius: 50%;border: #ee4d58 solid 2px;">
                    </div>
                    <div class="weui_media_bd" style="margin-left: 5px;color: #fff;">
                        <div style="font-size: 18px;padding-bottom:5px;border-bottom: #f16671 solid 1px;">
                            <img src="/images/wechat/user_name.png" style="width: 13px;vertical-align: middle;margin-right: 5px;">
                            <span style="vertical-align: middle;">{$user->name}</span>
                        </div>
                        <div style="margin-top: 5px;font-size: 14px;">
                            <img src="/images/wechat/user_level.png" style="width: 13px;vertical-align: middle;margin-right: 5px;">
                            <span style="vertical-align: middle;">会员:{$curruser->levelname}</span>

                            <img src="/images/wechat/user_jifen.png" style="width: 13px;vertical-align: middle;margin-left:5px;margin-right: 5px;">
                            <span style="vertical-align: middle;">积分:{$user->points}积分</span>

                        </div>
                    </div>
                    </a>
                </div>
            </div>

            <div class="weui-row weui-no-gutter" style="border-top: #e5e6e5 solid 1px;border-bottom: #e5e6e5 solid 1px;text-align: center;">
                <div class="weui-col-25" style="border-right: #e5e6e5 solid 1px;padding: 10px 0;">
                    <span style="font-size: 20px;">{$totalcommission}</span><br>
                    <span style="color: #999;font-size: 14px;">我的总收益</span>
                </div>
                <div class="weui-col-25" style="border-right: #e5e6e5 solid 1px;padding: 10px 0;">
                    <span style="font-size: 20px;">{$totaldk}</span><br>
                    <span style="color: #999;font-size: 14px;">已抵扣收益</span>
                </div>
                <div class="weui-col-25" style="border-right: #e5e6e5 solid 1px;padding: 10px 0;">
                    <span style="font-size: 20px;">{$totalwithdraw}</span><br>
                    <span style="color: #999;font-size: 14px;">已提收益</span>
                </div>
                <div class="weui-col-25" style="padding: 10px 0;">
                    <span style="font-size: 20px;color:#e7011f; ">{$user->commission}</span><br>
                    <span style="color: #999;font-size: 14px;">待提收益</span>
                </div>
            </div>
        </div>

        <div class="weui-row dyrdiv">
            <a href="/profile/partner?rel=1" class="weui-col-100 dyr" >
                <span class="shouyi" style="color:#f6ae33;">{$dy_commission1}</span><br>
                <span class="num">{$dy_nums1}人</span><br>
                <span class="title">贡献收益(元)</span><br>
                <span class="level" style="background-color: #929392;">下级代言人</span>
            </a>

            {*<a href="/profile/partner?rel=2" class="weui-col-50 dyr" >*}
                {*<span class="shouyi" style="color:#f6ae33;">{$dy_commission2}</span><br>*}
                {*<span class="num">{$dy_nums2}人</span><br>*}
                {*<span class="title">贡献收益(元)</span><br>*}
                {*<span class="level" style="background-color: #929392;">二级代言人</span>*}
            {*</a>*}
        </div>

        <a href="javascript:;" class="weui_btn weui_btn_primary withdrawbtn" commission="{$user->commission}" style="background-color: #e70111;margin: 30px 20px 0 20px;">提现</a>

        <div style="width: 100%;text-align: center;margin: 15px 0;">
            <a id="show_withdraw" href="javascript:;" style="color: #666;">显示提现列表</a>
        </div>

        <div id="withdrawdiv" style="width: 100%;padding: 0 20px;margin-top: 30px;text-align: center;display: none;">
            <table class="withdraw">
                <tr>
                    <th>提现金额</th>
                    <th>提现时间</th>
                    <th>状态</th>
                </tr>
                {foreach from = $withdrawList item="item"}
                    <tr>
                        <td>{$item->amount}</td>
                        <td>{$item->cts}</td>
                        <td>{$item->status}</td>
                    </tr>
                {/foreach}
            </table>
        </div>

    </div>

    {$page = 'profile'}
    {include file="footer.tpl"}
</div>


</body>
</html>