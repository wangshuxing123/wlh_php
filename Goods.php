<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Goods extends CI_Controller
{
    /**
     * 商品详情页
     * @param int $id 商品ID
     */
    public function detail($id = 0)
    {
        $this->smarty->assign('resource_url', $this->config->item('resource_url'));

        $user = $this->bag->get("user");
        if (empty($user))
        {
            $userid = 0;
        }
        else
        {
            $userid = intval($user->id);
        }

        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $query = $this->db->query('SELECT COUNT(id) AS total FROM tb_cart WHERE userid = ? AND status = \'014001\'', array($userid));
        $this->smarty->assign('cart_nums', $query->row()->total);

        $query = $this->db->query('SELECT a.id, a.name, a.goodsno, a.productid, b.goodsspecid1 AS defaultcolorid,b.goodsspecid2 AS defaultsizeid, c.imgurl AS defaultimgurl, c.name AS defaultcolorname, d.name AS defaultsizename, a.cover, a.content, b.sellprice, b.marketprice, a.seotitle, a.seokeywords, a.seodescription FROM tb_goods AS a LEFT JOIN tb_products AS b ON a.productid = b.id LEFT JOIN tb_goods_spec AS c ON b.goodsspecid1 = c.id LEFT JOIN tb_goods_spec AS d ON b.goodsspecid2 = d.id WHERE a.id = ? ', array($id));
        $goods = $query->row();

        $color_id = intval($this->input->get('colorid'));
        if ($color_id != 0)
        {
            $goods->defaultcolorid = $color_id; //改变默认颜色
        }
        else
        {
            $color_id = $goods->defaultcolorid;
        }

        // 获取默认颜色的图片集合
        $query = $this->db->query('SELECT name, dcd AS imgs FROM tb_goods_spec WHERE id = ?', array($color_id));
        $imgs = json_decode($query->row()->imgs);
        $goods->defaultcolorname = $query->row()->name; //改变默认颜色名称
        $defaultimgs = array();
        foreach ($imgs as $img)
        {
            array_push($defaultimgs,$img);
        }
        $this->smarty->assign('defaultimgs', $defaultimgs);
        $query->free_result();

        // 获取商品的颜色LIST
        $query = $this->db->query('SELECT a.id, a.name, a.imgurl, a.dcd AS imgs FROM tb_goods_spec AS a LEFT JOIN tb_spec AS b ON a.specid = b.id WHERE b.tp = \'005001\' AND a.goodsid = ?', array($id));
        $this->smarty->assign('colors', $query->result());
        $query->free_result();

        // 获取商品的尺码LIST
        $query = $this->db->query('SELECT a.id, a.name, c.sellprice FROM tb_goods_spec AS a LEFT JOIN tb_spec AS b ON a.specid = b.id LEFT JOIN tb_products AS c ON a.id=c.goodsspecid2 WHERE b.tp = \'005002\' AND a.goodsid = ? AND c.goodsspecid1=?', array($id, $goods->defaultcolorid));
        // 获取默认颜色的 有存货 尺码IDs
        $stockquery = $this->db->query('SELECT a.goodsspecid2,(b.stocknum-b.occupynum) AS stocknum FROM tb_products AS a LEFT JOIN tb_warehouse_store AS b ON a.id=b.productid AND b.warehouseid=1 WHERE a.goodsspecid1 = ? AND b.stocknum > 0', array($goods->defaultcolorid));

        foreach($query->result() as $row)
        {
            $row->havestock = '0';
            $row->stocknum = 0;
            foreach($stockquery->result() as $stock)
            {
                if($row->id === $stock->goodsspecid2)
                {
                    $row->havestock = '1';
                    $row->stocknum = $stock->stocknum;
                }
                if ($goods->defaultsizeid == $stock->goodsspecid2)
                {
                    $goods->default_size_stock = $stock->stocknum;
                }
            }
        }
        $this->smarty->assign('sizes', $query->result());
        $this->smarty->assign('goods', $goods);
        $query->free_result();
        $stockquery->free_result();

        // 获取评论数
        $query = $this->db->query('SELECT COUNT(id) AS total FROM tb_review WHERE goodsid = ? AND status = \'013002\'', array($id));
        $this->smarty->assign('commentnums', $query->row()->total);
        $query->free_result();

        $from_openid = $this->input->get('openid'); //分享来源用户的openid
        $openid = $this->input->cookie('aye_openid');
        $this->smarty->assign('openid', $openid);
        if(!empty($from_openid) && $openid != $from_openid)
        { // 记录访问来源日志
            $query = $this->db->query('SELECT id FROM tb_user WHERE openid=? LIMIT 1', array($from_openid));
            if($query->num_rows() > 0) {
                $from_userid = $query->row()->id;
                $this->db->query('DELETE FROM tb_user_view_log WHERE openid = ? AND from_userid=?', array($openid, $from_userid));
                $this->db->query('INSERT INTO tb_user_view_log (id, openid, from_userid) VALUES (?, ?, ?)', array(trxid(), $openid, $from_userid));
            }
        }

        $this->smarty->view('goods/detail.tpl');
    }

    /**
     * 商品详情--图文详情和具体参数
     */
    public function detail_info($id=0)
    {
        $this->smarty->assign('resource_url', $this->config->item('resource_url'));

        $tab = $this->input->get('tab');
        $this->smarty->assign('tab', $tab);

        $this->smarty->assign('goodsid', $id);

        $query = $this->db->query('SELECT id, content FROM tb_goods WHERE id = ? ', array($id));
        $goods = $query->row();
        $this->smarty->assign('goods', $goods);
        $query->free_result();

        $query = $this->db->query('SELECT attrname,attrvalue FROM tb_goods_attr WHERE goodsid = ?', array($id));
        $this->smarty->assign('attrs', $query->result());

        $query = $this->db->query('SELECT a.id, b.avatar, b.name, a.isanonymous, a.starnums, a.content, a.picurls, a.cts FROM tb_review AS a LEFT JOIN tb_user AS b ON a.userid=b.id WHERE a.goodsid = ? AND a.status = \'013002\' ORDER BY a.id DESC LIMIT 5', array($id));
        $this->smarty->assign('commentlist', $query->result());
        $query->free_result();

        $this->smarty->view('goods/detail_info.tpl');
    }

    /**
     * 获取更多评论
     */
    public function get_more_comments()
    {
        $goodsid = $this->input->post('goodsid');
        $commentid = $this->input->post('commentid');

        $query = $this->db->query('SELECT a.id, b.avatar, b.name, a.isanonymous, a.starnums, a.content, a.picurls, a.cts FROM tb_review AS a LEFT JOIN tb_user AS b ON a.userid=b.id WHERE a.goodsid = ? AND a.status = \'013002\' AND a.id < ? ORDER BY a.id DESC LIMIT 5 ', array($goodsid, $commentid));
        if($query->num_rows() > 0)
        {
            render_success_json($query->result());
        }
        else
        {
            render_failed_json();
        }
    }

    /**
     * 切换商品 颜色
     */
    public function change_color()
    {
        $goodsid = intval($this->input->post('goodsid'));
        $colorspecid = intval($this->input->post('colorspecid'));

        // 获取当前颜色的图片集合
        $query = $this->db->query('SELECT dcd AS imgs FROM tb_goods_spec WHERE id = ?', array($colorspecid));
        $imgs = json_decode($query->row()->imgs);
        $retimgs = array();
        foreach ($imgs as $img)
        {
            array_push($retimgs,$img);
        }
        $result_data['imgs'] = $retimgs;

        // 获取当前颜色有货的尺码
        $query = $this->db->query('SELECT a.id,b.sellprice,(d.stocknum-d.occupynum) AS stocknum FROM tb_goods_spec AS a LEFT JOIN tb_products AS b ON a.id = b.goodsspecid2 LEFT JOIN tb_spec AS c ON a.specid = c.id LEFT JOIN tb_warehouse_store AS d ON b.id=d.productid AND d.warehouseid=1 WHERE c.tp = \'005002\' AND b.goodsspecid1 = ? AND d.stocknum>0', array($colorspecid));
        $result_data['sizes'] = $query->result();

        render_success_json($result_data);
    }


    /**
     * 立即购买
     */
    public function buy_now()
    {
        $user = $this->bag->get("user");
        if (empty($user))
        {
            $data = new stdClass();
            $data->redirect = true;
            echo json_encode($data);die;
        }
        $userid =  intval($user->id);

        $goodsid = intval($this->input->post('goodsid'));
        $buynum = intval($this->input->post('buynum'));
        $specid1 = intval($this->input->post('specid1'));
        $specname1 = $this->input->post('specname1');
        $specid2 = intval($this->input->post('specid2'));
        $specname2 = $this->input->post('specname2');
        $specpic = $this->input->post('specpic');

        $product = $this->db->query('SELECT a.id, a.sellprice, (b.stocknum-b.occupynum) AS stocknum FROM tb_products AS a LEFT JOIN tb_warehouse_store AS b ON a.id=b.productid AND b.warehouseid=1 WHERE a.goodsid=? AND a.goodsspecid1=? AND a.goodsspecid2=?', array($goodsid, $specid1, $specid2));
        if ($product->num_rows() == 0)
        {
            render_failed_json('商品已失效，请刷新页面！');
            return;
        }
        else
        {
            $productid = $product->row()->id;
            $stocknum = intval($product->row()->stocknum);
            if ($stocknum < $buynum)
            {
                render_failed_json('库存不足'.$buynum.'件！');
                return;
            }
        }

        $query = $this->db->query('SELECT a.id AS productid, a.goodsid, b.name AS goodsname, a.sellprice, a.weight FROM  tb_products AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id WHERE a.id=?',array($productid));
        foreach($query->result() as $row)
        {
            $row->specid1 = $specid1;
            $row->specname1 = $specname1;
            $row->specid2 = $specid2;
            $row->specname2 = $specname2;
            $row->specpic = $specpic;
            $row->buynum = $buynum;
            $row->totalmoney = $buynum * $row->sellprice;
            $row->totalweight = $buynum * $row->weight;
        }

        $this->redis->setex('order_confirm_goods_'.$userid, 60*60*24, json_encode($query->result()));
        //结算只保留一份数据 如果是直接下单购买 清空购物车结算的缓存
        $this->redis->setex('order_confirm_cartids_'.$userid, 60*60*24, '');
        render_success_json();
    }

    /**
     * 将商品加入购物车
     */
    public function add_goods_to_basket()
    {
        $user = $this->bag->get("user");
        if (empty($user))
        {
            $data = new stdClass();
            $data->redirect = true;
            echo json_encode($data);die;
        }
        $userid =  intval($user->id);

        $goodsid = intval($this->input->post('goodsid'));
        $buynum = intval($this->input->post('buynum'));
        $specid1 = intval($this->input->post('specid1'));
        $specname1 = $this->input->post('specname1');
        $specid2 = intval($this->input->post('specid2'));
        $specname2 = $this->input->post('specname2');
        $specpic = $this->input->post('specpic');


        $product = $this->db->query('SELECT a.id, a.sellprice, (b.stocknum-b.occupynum) AS stocknum FROM tb_products AS a LEFT JOIN tb_warehouse_store AS b ON a.id=b.productid AND b.warehouseid=1 WHERE a.goodsid=? AND a.goodsspecid1=? AND a.goodsspecid2=?', array($goodsid, $specid1, $specid2));
        if ($product->num_rows() == 0)
        {
            render_failed_json('商品已失效，请刷新页面！');
            return;
        }
        else
        {
            $productid = $product->row()->id;
            $sellprice = $product->row()->sellprice;
            $stocknum = intval($product->row()->stocknum);
            if ($stocknum < $buynum)
            {
                render_failed_json('库存不足'.$buynum.'件！');
                return;
            }
        }

        $this->db->trans_start();
        $query = $this->db->query('SELECT id FROM tb_cart WHERE userid=? AND goodsid=? AND specid1=? AND specid2=? AND status=\'014001\'', array($userid, $goodsid, $specid1, $specid2));
        if ($query->num_rows() > 0)
        {
            $this->db->query('UPDATE tb_cart SET buynum = buynum + ? WHERE id = ?', array($buynum, $query->row()->id));
        }
        else
        {
            $cartid = trxid();
            $this->db->query('INSERT INTO tb_cart (id, userid, goodsid, productid, specid1, specname1, specid2, specname2, specpic, joinprice, buynum) VALUES (?,?,?,?,?,?,?,?,?,?,?)', array($cartid, $userid, $goodsid, $productid, $specid1, $specname1, $specid2, $specname2, $specpic, $sellprice, $buynum));
        }
        $this->db->trans_complete();

        if ($this->db->trans_status())
        {
            render_success_json();
        }
        else
        {
            render_failed_json();
        }
    }


}