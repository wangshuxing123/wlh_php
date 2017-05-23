<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

//用户控制器
class User extends Home_Controller{

	public function __construct(){
		parent::__construct();
		$this->load->library('form_validation');
		$this->load->model('user_model');
	}
    #显示会员中心
    public function profile()
    {
        $user = $this->session->userdata('user');
        $user_id = strval($user['user_id']);

        $query = $this->db->query('SELECT user_name, sex, img FROM ci_user WHERE user_id= ?', array($user_id));
        $data['user']=$query->row_array();
        $this->load->view('vip.html',$data);
    }
	#显示注册页面
	public function register(){
		$this->load->view('register.html');	
	}

	#显示登录页面
	public function login(){
		$this->load->view('login.html');
	}

	public function do_register(){
		#设置验证规则
		$this->form_validation->set_rules('username','用户名','required', array('required' => '用户名为必填！'));
		$this->form_validation->set_rules('password','密码','required|min_length[6]|max_length[16]|md5' );
		$this->form_validation->set_rules('repassword','重复密码','required|matches[password]');
        $this->form_validation->set_message('min_length', '{field} 最少 {param}个字符.');

		if ($this->form_validation->run() == false) {
			# 未通过
            $data['success']=-1;
            $data['msg']=validation_errors();
            echo json_encode($data);
		} else {
			# 通过,注册
			$user['user_name'] = $this->input->post('username',true);
            $user['password'] = $this->input->post('password',true);
            $user['reg_time'] = time();
			if ($this->user_model->add_user($user)) {
				# 注册成功
                $data['success']=1;
                $data['msg']="注册成功";
			} else {
				# 注册失败
                $data['success']=-1;
                $data['msg']="注册失败";
			}
			echo json_encode($data);
		}
    }
	#登录动作
	public function signin(){
		#验证 省略
		$username = $this->input->post('username');
		$password = $this->input->post('password');

		if ($user = $this->user_model->get_user($username,$password)) {
			#成功，将用户信息保存至session
			$this->session->set_userdata('user',$user);
            $data['success']=1;
            $data['msg']='/';
		} else {
			# error
            $data['success']=-1;
            $data['msg']='登陆失败！';
		}
        echo json_encode($data);
		
	}

	#注销动作
	public function logout(){
		$this->session->unset_userdata('user');
		redirect('user/login');
	}
}
