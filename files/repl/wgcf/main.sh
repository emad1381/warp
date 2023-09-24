#!/bin/sh

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}

rm -f wgcf-account.toml wgcf-profile.conf
echo | ./wgcf register
chmod +x wgcf-account.toml

clear
yellow "请选择需要使用的 WARP 账户类型"
echo ""
echo -e " ${GREEN}1.${PLAIN} WARP 免费账户 ${YELLOW}(默认)${PLAIN}"
echo -e " ${GREEN}2.${PLAIN} WARP+"
echo -e " ${GREEN}3.${PLAIN} WARP Teams"
echo ""
read -p "请输入选项 [1-3]: " account_type
if [[ $account_type == 2 ]]; then
  yellow "获取 CloudFlare WARP 账号密钥信息方法: "
  green "电脑: 下载并安装 CloudFlare WARP → 设置 → 偏好设置 → 账户 →复制密钥到脚本中"
  green "手机: 下载并安装 1.1.1.1 APP → 菜单 → 账户 → 复制密钥到脚本中"
  echo ""
  yellow "重要：请确保手机或电脑的 1.1.1.1 APP 的账户状态为WARP+！"
  echo ""
  read -rp "输入 WARP 账户许可证密钥 (26个字符): " warpkey
  until [[ $warpkey =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; do
    red "WARP 账户许可证密钥格式输入错误，请重新输入！"
    read -rp "输入 WARP 账户许可证密钥 (26个字符): " warpkey
  done
  sed -i "s/license_key.*/license_key = \"$warpkey\"/g" wgcf-account.toml
  read -rp "请输入自定义设备名，如未输入则使用默认随机设备名: " devicename
  green "注册 WARP+ 账户中, 如下方显示: 400 Bad Request, 则使用 WARP 免费版账户"
  if [[ -n $devicename ]]; then
    ./wgcf update --name $(echo $devicename | sed s/[[:space:]]/_/g)
  else
    ./wgcf update
  fi
  ./wgcf generate
elif [[ $account_type == 3 ]]; then
  ./wgcf generate
  chmod +x wgcf-profile.conf
  yellow "获取 WARP Teams 账户 xml 配置文件方法：https://blog.misaka.rest/2023/02/11/wgcfteam-config/"
  yellow "请将提取到的 xml 配置文件上传至：https://gist.github.com"
  read -rp "请粘贴 WARP Teams 账户配置文件链接：" teamconfigurl
  if [[ -n $teamconfigurl ]]; then
    teams_config=$(curl -sSL "$teamconfigurl" | sed "s/\"/\&quot;/g")
    private_key=$(expr "$teams_config" : '.*private_key&quot;>\([^<]*\).*')
    private_v6=$(expr "$teams_config" : '.*v6&quot;:&quot;\([^[&]*\).*')
    sed -i "s#PrivateKey.*#PrivateKey = $private_key#g" wgcf-profile.conf;
    sed -i "s#Address.*128#Address = $private_v6#g" wgcf-profile.conf;
  else
    red "未提供WARP Teams 账户配置文件链接，脚本退出！"
    exit 1
  fi
else
  ./wgcf generate
fi

clear
green "WGCF 的 WireGuard 配置文件已生成成功！"
yellow "下面是配置文件内容："
red "$(cat wgcf-profile.conf)"
echo ""
yellow "下面是配置文件分享二维码："
qrencode -t ansiutf8 < wgcf-profile.conf
echo ""
yellow "请在本地使用此方法：https://blog.misaka.rest/2023/03/12/cf-warp-yxip/ 优选可用的 Endpoint IP"