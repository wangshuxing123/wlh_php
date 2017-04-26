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
<title>收货地址</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">

</style>

<script type="text/javascript">
    $(function(){
        $('.del').on('click', function(){
            var addressid = $(this).attr('addressid');
            var parentobj = $(this).closest('.address');
            $.confirm("您确定要删除该地址吗?", "确认删除?", function() {
                $.post("/profile/del_address",{ addressid:addressid},function(jd){
                    {redirecturl url='home/signin'}
                    if (jd.success) {
                        parentobj.hide('normal', function() {
                            parentobj.remove();
                            $.toast('已删除');
                        });
                    } else {
                        $.toast('删除失败');
                    }
                },"json");
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
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>收货地址
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;">
        {foreach from=$addresslist item="item"}
        <div class="weui_panel weui_panel_access address" addressid="{$item->id}" style="margin-top: 10px;">
            <div class="weui_panel_bd">
                <div class="weui_media_box weui_media_text">
                    <h4 class="weui_media_title" style="font-size:16px;color: #666;line-height: 30px;">{$item->acceptname}<span class="fr">{$item->mobile}</span></h4>
                    <p class="weui_media_desc" style="font-size: 16px;color: #666;line-height: 30px;">{if $item->isdefault eq '1'}<span style="color: #e70012;">【默认地址】</span>{/if}{$item->fulladdr}</p>
                </div>
            </div>
            <div class="weui_cell_ft" style="margin-left:15px;padding-right: 15px;padding-bottom:10px;border-top: #e5e5e5 solid 1px;">
                <a href="javascript:;" class="weui_btn weui_btn_mini weui_btn_default del"  addressid="{$item->id}" style="background-color:#fff;border: #a1a1a1 solid 1px;color: #a1a1a1;">删除</a>
                <a href="/profile/edit_address/{$item->id}" class="weui_btn weui_btn_mini weui_btn_primary" style="background-color:#fff;border: #e60111 solid 1px;color: #e60111;">编辑</a>
            </div>
        </div>
        {/foreach}
    </div>

    <div class="weui_tabbar" style="background-color:#fff;">
        <a href="/profile/edit_address/0" class="weui_btn weui_btn_primary" style="background-color: #e60012;width: 100%;margin: 8px 20px;">添加收货地址</a>
    </div>
</div>
</body>
</html>