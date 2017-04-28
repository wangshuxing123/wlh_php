<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//购物车控制器
class Cart extends Home_Controller{

	public function __construct(){
		parent::__construct();
        $this->load->driver('cache', array('adapter' => 'file'));
	}

	#显示购物车页面
	public function show(){
//      $this -> output -> enable_profiler(TRUE);
		#获取购物车数据
		$data['carts'] = $this->cart->contents();
		$this->load->view('flow.html',$data);
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
			redirect('cart/show');
		} else {
			# error
			echo 'error';
		}
		
	}
    //确定购物车所选商品-->cache,此处与立即购买会共用一个key，相互覆盖
    public function confirm(){
        #获取表单数据
        $cartids ='1,2,3,4';// $this->input->post('cartids');
        $cartarr=explode(',',$cartids);
        var_dump($cartarr);
        foreach ($cartarr as $v){
           $good= $this->cart->get_item($v);

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
