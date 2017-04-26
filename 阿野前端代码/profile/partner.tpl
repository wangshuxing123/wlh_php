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
<title>我的代言小伙伴</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">
    .weui-row {
        background-color: #fff;
    }
    [class*="weui-col-"] {
        border: 1px solid #eee;
        height: 45px;
        line-height: 45px;
        text-align: center;
        &.selected{
            border-bottom: #e60111 solid 4px;
         }
    }

    .dyr{
        padding-left:15px;margin-top: 15px;background-color: #fff;
        .item{
            padding:6px 0; border-bottom: #eee solid 1px;font-size:16px;line-height: 50px;
            .avatar{
                border-radius: 50%;height: 50px;vertical-align: middle;
            }
            .name{
                color: #999;vertical-align: middle;margin-left: 20px;font-weight: bold;
            }
            .profit{
                vertical-align: middle;float: right;margin-right: 15px;color: #e60111;font-weight: bold;
            }
        }
    }
</style>

<script type="text/javascript">
    $(function(){
        // tab页切换
        $('.leveltab').on('click', function(){
           $('.leveltab').removeClass('selected');
           $(this).addClass('selected');

            $('.dyr[rel='+ $(this).attr('rel') +']').show().siblings('.dyr').hide();
        });
    });
</script>

</head>

<body ontouchstart>

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>我的代言小伙伴
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">

        <div class="weui-row weui-no-gutter" style="display: none;">
            <div class="weui-col-50 leveltab {if $rel eq '1'}selected{/if}" rel="1">一级代言人</div>
            <div class="weui-col-50 leveltab {if $rel eq '2'}selected{/if}" rel="2">二级代言人</div>
        </div>

        <div id="dyr1" class="dyr" rel="1" style="{if $rel eq '2'}display: none;{/if}">
            <div class="item">
                我的下级代言人（{$dy_nums1}人）
            </div>
            {foreach from=$dyr_list1 item="item"}
                <div class="item">
                    <img src="{$item->avatar}" alt="" class="avatar">
                    <span class="name">{$item->name}</span>
                    <span class="profit">￥{$item->totalcommission}</span>
                </div>
            {/foreach}
        </div>


        <div id="dyr2" class="dyr" rel="2" style="{if $rel eq '1'}display: none;{/if}">
            <div class="item">
                我的二级代言人（{$dy_nums2}人）
            </div>

            {foreach from=$dyr_list2 item="item"}
                <div class="item">
                    <img src="{$item->avatar}" alt="" class="avatar">
                    <span class="name">{$item->name}</span>
                    <span class="profit">￥{$item->totalcommission}</span>
                </div>
            {/foreach}
        </div>
    </div>
    {$page = 'profile'}
    {include file="footer.tpl"}
</div>


</body>
</html>