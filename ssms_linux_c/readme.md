## 安装mysql和开发库
1. `sudo apt-get install mysql-server`

2. `sudo apt install libmysqlclient-dev`

   > libmysqlclient-dev是安装mysql的C/C++库，提供了C/C++访问mysql的API函数，需要用到的头文件会出现在/usr/include/mysql/里

3. 运行方式:  `gcc -I/usr/include/mysql main.c -L/usr/lib/mysql -lmysqlclient -o app`

