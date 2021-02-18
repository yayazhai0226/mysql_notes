-- TCP/IP不是一个协议，而是一个协议族的统称.
begin
TCP/IP模型分为4层：
1、应用层：（例如:TELNET、FTP、SMTP协议等）
向用户提供一组常用的应用程序，比如电子邮件、文件传输访问、远程登录等
2、传输层:（例如：TCP、UDP协议等）
提供应用程序间的通信。其功能包括：一、格式化信息流；二、提供可靠传输。为实现后者，传输层协议规定接收端必须发回确认，并且假如分组丢失，必须重新发送。
3、网络层 ：IP
	负责相邻计算机之间的通信。其功能包括三方面。
4、网络接口层：
这是TCP/IP软件的最低层，负责接收IP数据报并通过网络发送之，或者从网络上接收物理帧，抽出IP数据报，交给IP层。
end ;

-- TCP/IP
begin
TCP/IP 意味着 TCP 和 IP 在一起协同工作。
TCP 负责应用软件（比如你的浏览器）和网络软件之间的通信。
IP 负责计算机之间的通信。
TCP 负责将数据分割并装入 IP 包，然后在它们到达的时候重新组合它们。
IP 负责将包发送至接受者。

传输层协议负责解决数据传输问题，包括数据通行的可靠性问题。传输层依赖更底层的网络层来完成实际的数据传输，在TCP/IP网络协议中，负责可靠通信的传输层协议为TCP协议。
而网络层一般用网络驱动来实现，普通的程序员不会涉及；在TCP/IP协议中，网络层的协议为IP协议。
end ;

-- HTTP协议
begin
HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。
HTTP是一个基于TCP/IP通信协议来传递数据（HTML 文件, 图片文件, 查询结果等）
HTTP协议工作于客户端-服务端架构为上。浏览器作为HTTP客户端通过URL向HTTP服务端即WEB服务器发送所有请求。Web服务器根据接收到的请求后，向客户端发送响应信息。
end ;





