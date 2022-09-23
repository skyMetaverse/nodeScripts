#!/bin/bash

red='\e[91m'
green='\e[92m'
none='\e[0m'
_red() { echo -e  -e ${red}$*${none}; }
_green() { echo -e  -e ${green}$*${none}; }

# Root
[[ $(id -u) != 0 ]] && echo -e  -e "\n 哎呀……请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}\n" && exit 1

while true
do

# Logo
curl -s https://raw.githubusercontent.com/skyMetaverse/logo/main/logo.sh | bash

source ~/.profile

PS3='选择一个操作 '
options=(
"安装meson节点" 
"配置并启动meson节点" 
"检查节点运行状态"
"停止节点"
"卸载节点"
"重启节点"
"检查日志"
"退出")
select opt in "${options[@]}"
               do
                   case $opt in
"安装meson节点")
echo -e  "${green}准备开始安装${none}"

wget 'https://staticassets.meson.network/public/meson_cdn/v3.1.18/meson_cdn-linux-amd64.tar.gz' \
	&& tar -zxf meson_cdn-linux-amd64.tar.gz \
	&& rm -f meson_cdn-linux-amd64.tar.gz \
	&& cd ./meson_cdn-linux-amd64 \
	&& sudo ./service install meson_cdn
break
;;

"配置并启动meson节点")
echo -e  "${green}准备开始配置${none}"

echo -e  "${green}输入Token:${none}"
echo -e  "${green}Token地址可以在此查看：https://dashboard.meson.network/user_node${none}"            
read token

echo -e  "${green}输入端口号(默认443)${none}	"
read port
if [ ! ${port} ];then
	token=443
fi

echo -e  "${green}输入缓存大小(默认最小20GB,不需要输入单位):${none}	"
read cacheSize
if [ ! ${cacheSize} ];then
	token=20
fi

pushd ~/meson_cdn-linux-amd64
sudo ./meson_cdn config set --token=${token} --https_port=${port} --cache.size=${cacheSize}

echo -e  "${green}启动meson节点${none}	"
sudo ./service start meson_cdn
break
;;

"检查节点运行状态")
pushd ~/meson_cdn-linux-amd64
echo -e  "${red}节点运行状态：`sudo ./service status meson_cdn`${none}"
break
;;

"停止节点")
pushd ~/meson_cdn-linux-amd64
echo -e  "${red}正在停止节点：`sudo ./service stop meson_cdn`${none}"
break
;;

"卸载节点")
pushd ~/meson_cdn-linux-amd64
echo -e  "${red}正在卸载节点：`sudo ./service remove meson_cdn`${none}"
rm -rf ~/meson_cdn-linux-amd64
break
;;

"重启节点")
pushd ~/meson_cdn-linux-amd64
echo -e  "${red}正在重启节点：`sudo ./service restart meson_cdn `${none}"
break
;;

"检查日志")
echo -e  "${green}运行日志${none}"
pushd ~/meson_cdn-linux-amd64
sudo ./meson_cdn log
break
;;

"退出")
exit
;;

*) echo "invalid option $REPLY";;
esac
done
done
