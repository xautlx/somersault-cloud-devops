基于 https://help.aliyun.com/document_detail/431629.html 样例代码实现获取本地IPV6地址动态调用DDNS，代码比较粗糙仅实现基本功能即可。

maven构建输出target的jar文件复制到 ansible-ddns/files 目录下，基于ansible分发部署到目标主机实现DDNS定时同步处理。

