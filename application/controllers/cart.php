<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//购物车控制器
class Cart extends Home_Controller{

	public function __construct(){
		parent::__construct();
        $this->load->driver('cache', array('adapter' => 'file'));
        $this->load->library('cart');
	}

	#显示购物车页面
	public function show(){
//      $this -> output -> enable_profiler(TRUE);
		#获取购物车数据
		$data['carts'] = $this->cart->contents();
		echo json_encode($data);
        //$this->load->view('flow.html',$data);
	}
    //添加购物车
	public function add(){
		#获取表单数据
		$data['id'] = $this->input->post('goods_id');
		$data['name'] = $this->input->post('goods_name');
		// $data['name'] = 'aaa';
		$data['qty'] = $this->input->post('goods_nums');
		$data['price'] = $this->input->post('shop_price');

		#在插入之前，需要判断即将要加入的商品是否已经存在于购物车中
		$carts = $this->cart->contents();
		foreach ($carts as $v) {
			if ($v['id'] == $data['id']){
				$data['qty'] += $v['qty'];
			}
		}

		if ($this->cart->insert($data)) {
			# ok
            $data['success']=1;
            $data['msg']=site_url('cart/show');
		} else {
			# error
            $data['success']=-1;
            $data['msg']='添加购物车失败！';
		}
        echo json_encode($data);
	}
    //确定购物车所选商品-->cache,此处与立即购买会共用一个key，相互覆盖
    public function confirm(){
        #获取表单数据 cartid 用购物车中的rowid
        $cartids ='1,2';// $this->input->post('cartids');
        $cartarr=explode(',',$cartids);
//        var_dump($cartarr);
        $user = $this->session->userdata('user');
        if (empty($user)){
            $this->load->view('login.html');
        }
        else {
            $arr = array();
            $total = 0;
            foreach ($cartarr as $id) {
                //$good= $this->cart->get_item('c81e728d9d4c2f636f067f89cc14862c');
                $carts = $this->cart->contents();
                foreach ($carts as $v) {
                    if ($v['id'] == $id) {
                        $good['id'] = $v['id'];
                        $good['name'] = $v['name'];
                        $good['price'] = $v['price'];
                        $good['qty'] = $v['qty'];
                        $good['subtotal'] = $v['subtotal'];
                        array_push($arr, $good);
                        $total += $v['subtotal'];
                    }
                }
            }
            $data['goods'] = $arr;
            $data['totalAmount'] = $total;
            $this->cache->save("order_confirm_goods_" . $user['user_id'], $data);
            var_dump(json_encode($this->cache->get("order_confirm_goods_" . $user['user_id'])));
            $this->load->view('order.html',$data);
        }
    }

	#删除购物车信息
	public function delete($rowid){
		$data['rowid'] = $rowid;
		$data['qty'] = 0;
		$this->cart->update($data);
		redirect('cart/show');
	}
}
