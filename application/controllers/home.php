<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

//前台首页控制器
class Home extends Home_Controller{

	public function __construct(){
		parent::__construct();
		$this->load->model('category_model');
		$this->load->model('goods_model');
	}
	public function index(){
//		$this -> output -> enable_profiler(TRUE);
		$user = $this->session->userdata('user');
		
//		if (empty($user)){
//			$this->load->view('login.html');
//			}
//		else{
			$data['cates'] = $this->category_model->front_cate();
			$data['best_goods'] = $this->goods_model->best_goods();
			$this->load->view('list.html',$data);
//	}
	}
}
