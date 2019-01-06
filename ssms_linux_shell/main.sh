
#!/bin/bash
# @author qcmoke
# 学生管理系统
# @version 1.0

##需求
#程序功能：要求实现4个功能，每个功能作为一个函数
# 1.向文件中插入记录
# 2.显示文件中的每条记录的每个字段值
# 3.从文件中修改指定学号的记录
# 4.对学生成绩进行统计（包括每个学生总成绩；每个学科前3名和总成绩前5名统计）

#设置全局变量
##学生信息和学院信息
#学院相关变量
school_num=""
school_name=""

#学生相关变量
stu_num=""
stu_name=""
stu_des=""

#成绩相关变量
course=""
score=""
score_des=""

##数据文件存放路径
source_dir="./source"
schools_db="./source/schools.db"
students_db="./source/students.db"
scores_db="./source/scores.db"


#创建数据文件✔
mkdir_sourcedir(){
	if [ ! -d $source_dir ];then
		mkdir -p $source_dir
	fi
	
	if [ ! -f  $schools_db ];then
		touch $schools_db
	fi

	if [ ! -f $students_db ];then
		touch $students_db
	fi

	if [ ! -f $scores_db ];then
		touch $scores_db
	fi
}


# 主函数✔
Welcome() 
{
	# reset
	mkdir_sourcedir  #数据文件不存在则创建
	echo -e "\t\t\t--------------------------"
	echo -e "\t\t\t  欢迎进入学生管理系统"
	echo -e "\t\t\t--------------------------"
	Module
}

#模块选择✔
Module(){
	clear
	echo -e "\t\t\t**********************"
	echo -e "\t\t\t请输入对应数字选择信息模块"
	echo -e "\t\t\t 1. 学院信息管理"
	echo -e "\t\t\t 2. 学生信息管理"
	echo -e "\t\t\t 3. 成绩信息管理"
	read  choice
	case $choice in
	1)
		Menu1
		;;
	2)
		Menu2
		;;
	3)
		Menu3
		;;
	*)
		Module
		;;
	esac
}




###############
#学院信息模块功能实现
###############

#学院信息模块菜单✔
Menu1(){
	clear
	echo -e "\t\t\t**********************"
	echo -e "\t\t\t请输入对应数字选择功能"
	echo -e "\t\t\t 1. 添加学院"
	echo -e "\t\t\t 2. 删除学院"
	echo -e "\t\t\t 3. 学院列表"
	echo -e "\t\t\t 4. 查找学院"
	echo -e "\t\t\t 5. 修改学院"
	echo -e "\t\t\t 6. 返回上级"
	echo -e "\t\t\t 7. 退出系统"
	echo -e "\t\t\t**********************"
	echo "请选择："
	
	read choice

	case $choice in
		1)
			echo -e "\t\t\t添加学院"
			add_school
			;;
		2)
			echo -e "\t\t\t删除学院"
			del_school
			;;
		3)
			echo -e "\t\t\t学院列表"
			display_schools
			;;
		4)
			echo -e "\t\t\t查找学院"
			find_school
			;;
		5)
			echo -e "\t\t\t修改学院"
			update_school
			;;
		6)
			echo -e "\t\t\t返回上级"
			Module
			;;
		7) 
			exit 0
			;;
		*)
			Menu1
		;;
	esac
	echo "--------------------------"
	echo "按任意键继续……"
	read c	
	Menu1
}

#1.添加学院信息✔
add_school(){
	read -p "school_num:" school_num
	#防止输入空格
	while [ "$school_num" = '' ];do
		read -p "输入的学院编号不能为空，请重新输入学院编号:" school_num
	done
	while grep -w "$school_num" "$schools_db" > /dev/null ;do 
		echo "已经存在该编号的学院了，请改用其他编号！"
		read -p "school_num:" school_num
	done
	read -p "school_name:" school_name
	#防止输入空格
	while [ "$school_name" = '' ];do
		read -p "输入的学院名称不能为空，请重新输入学院名称:" school_name
	done
	echo -e "$school_num,\t$school_name,\r" >> $schools_db
}

#2.删除学院✔
del_school(){
	read -p "请输入学院的编号" school_num
	while  ! grep -w "$school_num" "$schools_db" > /dev/null ; do
		echo "不存在该编号的学校，请输入编号存在的学校编号: "
		read -p "school_num:" school_num
	done
	echo "该学院的信息为："
	grep "^$school_num" $schools_db
	read -p "确定删除吗?[yes|no]" choice
	case "$choice" in
	yes)
 		sed -i -e "/^$school_num/d" $schools_db
		if [ "$?" -eq 0 ];then
			echo "删除成功"
		else
			echo "不存在该条记录或者删除失败"
		fi
		;;
	no)	
		:
		;;
	*)
		echo "请输入[yes|no]"
		del_school
		;;
	esac
}

#3.展示全部学院信息✔
display_schools(){
	echo -e "编号\t学院\t"
	cat $schools_db
}

#4.查找学院✔
find_school(){
	echo "--------------------------"
	echo "输入要查询的学院编号"
	read school_num
	echo "--------------------------"
	echo -e "编号\t学院\t"
	grep  -w $school_num $schools_db #-w只显示全字符合的列
	echo "--------------------------"
	echo "查询成功"
}

#5.修改学院信息✔
update_school(){
	echo "--------------------------"
	read -p "输入学院编号:" school_num
	#防止输入空格
	while [ "$school_num" = '' ];do
		read -p "输入有误，请重新。输入学院编号:" school_num
	done
	while  ! grep -w "$school_num" "$schools_db" > /dev/null ; do
		echo "不存在该编号的学校，请输入编号存在的学校编号: "
		read -p "school_num:" school_num
			#防止输入空格
		while [ "$school_num" = '' ];do
			read -p "输入有误，请重新。输入学院编号:" school_num
		done
	done
	echo "--------------------------"
	echo -e "编号\t学院\t"
	grep  -w $school_num $schools_db
	echo "--------------------------"
	read -p "要修改的字段信息" str1
	#防止输入空格
	while [ "$str1" = '' ];do
		read -p "输入有误，请重新。要修改的字段信息:" str1
	done
	while ! grep -w "$school_num,.*," "$schools_db"|grep -w "$str1"> /dev/null;do
		echo "不存在该字段，请重新输入:"
		read  str1
		#防止输入空格
		while [ "$str1" = '' ];do
			read -p "输入有误，请重新。要修改的字段信息:" str1
		done
	done
	read -p "修改后的字段信息" str2
	#防止输入空格
	while [ "$str2" = '' ];do
		read -p "输入有误，请重新。修改后的字段信息:" str2
	done
	read -p "确定删除吗?[yes|no]" choice
	case "$choice" in
		yes)
			sed -i "/${school_num#,}/ s/$str1/$str2/" $schools_db
			if [ "$?" -eq 0 ];then
				echo "修改成功"
				echo "--------------------------"
				echo "修改后的学院信息"
				echo -e "编号\t学院\t"
				cat $schools_db
				if [ "$str1" = "$school_num" ];then  #如果修改的是学院编号还要修改学生表里的学院编号
					sed -i "/${school_num#,}/ s/$str1/$str2/" $students_db
				fi
			else
				echo "修改失败"
			fi
			;;
		no)	
			:
			;;
		*)
			echo "请输入[yes|no]"
			del_student
			;;
	esac
}



###################
#学生信息模块功能实现
###################

#学生信息模块菜单✔
Menu2() {
	clear
	echo -e "\t\t\t**********************"
	echo -e "\t\t\t请输入对应数字选择功能"
	echo -e "\t\t\t 1. 添加学生"
	echo -e "\t\t\t 2. 删除学生"
	echo -e "\t\t\t 3. 学生列表"
	echo -e "\t\t\t 4. 查找学生"
	echo -e "\t\t\t 5. 修改学生"
	echo -e "\t\t\t 6. 返回上级"
	echo -e "\t\t\t 7. 退出系统"
	echo -e "\t\t\t**********************"
	echo "请选择："
	read choice

	case $choice in
		1)
			echo -e "\t\t\t添加学生信息"			
			add_student
			;;
		2)
			echo -e "\t\t\t删除学生信息"
			del_student
			;;
		3) 
			echo -e "\t\t\t展示学生信息"
			display_students
			;;
		4)
			echo -e "\t\t\t搜索学生信息"
			search_student_num
			;;
		5)
			echo -e "\t\t\t修改学生信息"
			modify_student
			;;
		6)
			echo -e "\t\t\t返回上一个页面"
			Module
			;;
		7) 
			exit 0
			;;
		*)
			Menu2
		;;
	esac
	echo "--------------------------"
	echo "按任意键继续……"
	read c
	Menu2
} 

#1.添加学生信息✔
add_student(){
	read -p "stu_num:" stu_num
	while grep -w "$stu_num" "$students_db" > /dev/null ;do 
		echo "已经存在该学号的学生了，请改用其他学号！"
		read -p "stu_num:" stu_num
	done	
	read -p "stu_name:" stu_name
	read -p "school_num:" school_num
	#将结果丢失，不显示在屏幕中
	while  ! grep -w "$school_num" "$schools_db" > /dev/null ; do
		echo "不存在该编号的学校，请输入编号存在的学校编号: "
		read -p "school_num:" school_num
	done
	read -p "stu_des:" stu_des
	echo -e "$stu_num,\t$stu_name,\t$school_num,\t$stu_des,\r" >> $students_db
	echo "成功添加学生信息,添加的信息为: "
	grep  -w $stu_num $students_db

}

#2.删除学生✔
del_student(){
	read -p "请输入要删除的学生的学号" num
	echo "该学生的信息为："
	grep "^$num" $students_db
	read -p "确定删除吗?[yes|no]" choice
	case "$choice" in
	yes)
 		sed -i -e "/^$num/d" $students_db
		if [ "$?" -eq 0 ];then
			echo "删除成功"
		else
			echo "不存在该条记录或者删除失败"
		fi
		;;
	no)	
		:
		;;
	*)
		echo "请输入[yes|no]"
		del_student
		;;
	esac
}

#3.显示所有学生信息 ✔
display_students() {
	echo "--------------------------"
	echo -e "学号\t姓名\t学院\t说明"
	sed -n '1,$p' $students_db
	echo "--------------------------"
	echo -e "\r"
} 

#4.查询学生信息 ✔
search_student_num() {
	echo "--------------------------"
	echo "输入要查询的学号"
	read num
	echo "--------------------------"
	echo -e "学号\t姓名\t学院\t说明"
	grep  -w $num $students_db
	# grep  -w "${num#*,}" $students_db
	echo "--------------------------"
	echo "查询成功"
}

#5.修改学生信息 ✔ 
modify_student() {
	echo "--------------------------"
	echo "输入学生所在的学院:"
	read school_num
	#防止输入空格
	while [ "$school_num" = '' ];do
		read -p "输入有误，请重新。输入学生所在的学院:" school_num
	done
	while ! grep -w "$school_num" "$schools_db" > /dev/null;do
		echo "不存在该编号的学院，请重新输入:"
		read  school_num
		#防止输入空格
		while [ "$school_num" = '' ];do
			read -p "输入有误，请重新。输入学生所在的学院:" school_num
		done
	done
	echo "输入要查询的学号:"
	read num
	#防止输入空格
	while [ "$num" = '' ];do
		read -p "输入有误，请重新。输入要查询的学号:" num
	done
	while ! grep -w "$num,.*,.*,.*," "$students_db" > /dev/null;do
		echo "不存在该编号的学生，请重新输入:"
		read  num
		#防止输入空格
		while [ "$num" = '' ];do
			read -p "输入有误，请重新。输入要查询的学号:" num
		done
	done
	echo "--------------------------"
	echo -e "学号\t姓名\t学院\t说明"
	grep "${num#,}" $students_db
	echo "--------------------------"
	echo "要修改的字段信息"
	read str1
	#防止输入空格
	while [ "$str1" = '' ];do
		read -p "输入有误，请重新。要修改的字段信息:" str1
	done
	while ! grep -w "$num,.*,.*,.*," "$students_db"|grep -w "$str1"> /dev/null;do
		echo "不存在该字段，请重新输入:"
		read  str1
		#防止输入空格
		while [ "$str1" = '' ];do
			read -p "输入有误，请重新。要修改的字段信息:" str1
		done
	done
	echo "修改后的字段信息"
	read str2
	#防止输入空格
	while [ "$str2" = '' ];do
		read -p "输入有误，请重新。修改后的字段信息:" str2
	done
	if [ "$str1" = "$school_num" ];then
		while ! grep -w "$str2" "$schools_db" > /dev/null;do
			echo "不存在该编号的学院，请重新输入:"
			read  str2
			#防止输入空格
			while [ "$str2" = '' ];do
				read -p "输入有误，请重新。修改后的字段信息:" str2
			done
		done
	fi

	read -p "确定删除吗?[yes|no]" choice
	case "$choice" in
		yes)
			#如果修改的是学生编号还要修改成绩表里的学生编号
			if [ "$str1" = "$num" ];then   
				sed -i "/${num#,}/ s/$str1/$str2/" $scores_db
			fi
			#如果修改的是学生姓名还要修改成绩表里的学生姓名
			studentName=$(grep "^$num," "$students_db"|sed -n "1p"|cut -d "," -f 2|cut -f 2) #获取学生的姓名,最后一个cut作用是去除字符串前的制表符
			if [ "$str1" = "$studentName" ];then
				sed -i "/^$num,/ s/$studentName/$str2/" "$scores_db" #根据学号来修改成绩表姓名的信息
			fi
			#修改学生表
			sed -i "/${num#,}/ s/$str1/$str2/" $students_db
			if [ "$?" -eq 0 ];then
				echo "------------修改成功--------------"
				echo "修改后的学生信息"
				echo -e "学号\t姓名\t学院\t说明"
				grep "${num#,}" $students_db | grep "$str2"
			else
				echo "修改失败"
			fi
			;;
		no)	
			:
			;;
		*)
			echo "请输入[yes|no]"
			modify_student
			;;
	esac

#后续处理的其他思路:成绩表可以不用学生姓名，有学生编号就可以了,但可能要大改代码
}




###################
#成绩信息模块功能实现
###################

#成绩信息模块菜单✔
Menu3() {
	clear
	echo -e "\t\t\t**********************"
	echo -e "\t\t\t请输入对应数字选择功能"
	echo -e "\t\t\t 1. 添加成绩"
	echo -e "\t\t\t 2. 删除成绩"
	echo -e "\t\t\t 3. 成绩列表"
	echo -e "\t\t\t 4. 查找成绩"
	echo -e "\t\t\t 5. 修改成绩"
	echo -e "\t\t\t 6. 成绩统计"
	echo -e "\t\t\t 7. 返回上级"
	echo -e "\t\t\t 8. 退出系统"
	echo -e "\t\t\t**********************"
	echo "请选择："
	read choice

	case $choice in
		1)
			echo -e "\t\t\t添加成绩"			
			add_score
			;;
		2)
			echo -e "\t\t\t删除成绩"
			del_score
			;;
		3) 
			echo -e "\t\t\t展示成绩信息"
			display_scores
			;;
		4)
			echo -e "\t\t\t搜索成绩信息"
			search_score_num
			;;
		5)
			echo -e "\t\t\t修改成绩信息"
			modify_score
			;;
		6)
			echo -e "\t\t\t成绩统计"
			score_count
			;;
		7)
			echo -e "\t\t\t返回上一个页面"
			Module
			;;
		8) 
			exit 0
			;;
		*)
			Menu3
		;;
	esac
	echo "--------------------------"
	echo "按任意键继续……"
	read c	
	Menu3
}

#成绩统计模块✔
score_count(){
	clear
	echo -e "\t\t\t**********************"
	echo -e "\t\t\t请输入对应数字选择功能"
	echo -e "\t\t\t 1. 每学科的前3名"
	echo -e "\t\t\t 2. 个人总成绩前5名"
	echo -e "\t\t\t 3. 返回上一级"
	echo -e "\t\t\t 4. 退出系统"
	echo -e "\t\t\t**********************"
	echo "请选择："
	read choice

	case $choice in
		1)
			echo -e "\t\t\t每学科的前3名"			
			such_course_sort_score
			;;
		2)
			echo -e "\t\t\t个人总成绩前5名"
			sort_score_sum_five
			;;
		3)
			Menu3
			;;
		4) 
			exit 0
			;;
		*)
			score_count
		;;
	esac
	echo "--------------------------"
	echo "按任意键继续……"
	read c	
	score_count
}

#1.添加成绩✔
input_score_info(){ #成绩信息输入
	read -p "stu_num:" stu_num
	while ! grep -w "$stu_num" "$students_db" > /dev/null ;do 
		echo "此学号没有录入在系统中，请重新输入正确的学号！"
		read -p "stu_num:" stu_num
	done
	read -p "stu_name:" stu_name
	while ! grep -w "$stu_name" "$students_db" > /dev/null ;do 
		echo "名字和学号不对应，请重新输入"
		read -p "stu_name:" stu_name
	done
	read -p "course:" course
	read -p "score:" score
	read -p "score_des:" score_des	
	while grep -w $stu_num $scores_db|grep -w $course > /dev/null ;do  #学号和科目确定成绩的唯一性
		echo "该学生的此科目成绩已经录入，请再次输入: "
		input_score_info
	done
}
add_score(){ #添加成绩
	input_score_info	
	echo -e "$stu_num,\t$stu_name,\t$course,\t$score,\t$score_des,\r" >> $scores_db
	echo "成功添加学生成绩信息,添加的信息为: "
	echo -e "学号\t姓名\t科目\t成绩\t说明"
	grep  -w $stu_num $scores_db|grep  -w $course #学号和科目确定成绩的唯一性
}

#2.删除成绩✔
del_score(){
read -p "请输入学生的学号" num
read -p "请输入该学生要删除的科目" score
echo "该条成绩信息为："
grep "^$num," $scores_db|grep "$score,"
read -p "确定删除吗?[yes|no]" choice
case "$choice" in
	yes)
 		sed -i -e "/^$num,.*$score,/d" $scores_db
		if [ "$?" -eq 0 ];then
			echo "删除成功"
		else
			echo "不存在该条记录或者删除失败"
		fi
		;;
	no)	
		:
		;;
	*)
		echo "请输入[yes|no]"
		del_score
		;;
	esac
}

#3.成绩列表✔
display_scores(){
echo ""
echo -e "学号\t姓名\t科目\t     成绩 说明"
cat $scores_db|column -t
}

#4.查找成绩✔
search_score_num(){
read -p "输入要查看的学生的学号" num
read -p "输入要查看的科目" score
echo -e "学号\t姓名\t科目\t成绩\t说明"
grep "^$num," $scores_db|grep "$score,"
}

#5.修改成绩✔
modify_score() {
	echo "--------------------------"
	read -p "输入学号(不能有空格):" num
	while ! grep  "^$num," "$scores_db" > /dev/null;do
		echo "不存在该编号的学生，请重新输入:"
		read  num
	done
	#防止输入空格
	while [ "$num" = '' ];do   #num=$(printf "$num"|sed s/[[:space:]]//g)
		echo "输入有误，请重新:"
		read -p "输入学号(不能有空格):" num
	done
	
	read -p "输入科目:" course
	#防止输入空格
	while [ "$course" = '' ];do
		echo "输入有误，请重新:"
		read -p "输入科目:" course
	done
	while ! grep  "^$num,.*$course," "$scores_db" > /dev/null;do
		echo "成绩表里不存在该编号的学生，请重新输入:"
		read  course
		#防止输入空格
		while [ "$course" = '' ];do
			echo "输入有误，请重新:"
			read -p "输入科目:" course
		done
	done
	echo "--------------------------"
	echo -e "学号\t姓名\t科目\t成绩\t说明"
	grep  "^$num," "$scores_db"|grep  "$course," #学号和科目确定成绩的唯一性
	echo "--------------------------"
	read -p "要修改的字段信息:" str1
	#防止输入空格
	while [ "$str1" = '' ];do
		echo "输入有误，请重新:"
		read -p "要修改的字段信息:" str1
	done
	while [ "$str1" = "$num" ];do
		echo "请输入其他字段(成绩表里不能瞎改学号,如果非要改，请修改学生表:)"
		read  str1
		#防止输入空格
		while [ "$str1" = '' ];do
			echo "输入有误，请重新:"
			read -p "要修改的字段信息:" str1
		done
	done
	scores_db_studentName=$(grep "^$num," "$scores_db"|sed -n "1p"|cut -d "," -f 2|cut -f 2) #从成绩表里获取学生姓名
	while [ "$str1" = "$scores_db_studentName" ];do
		echo "请输入其他字段(成绩表里不能瞎改姓名,如果非要改，请修改学生表:)"
		read  str1
		#防止输入空格
		while [ "$str1" = '' ];do
			echo "输入有误，请重新:"
			read -p "要修改的字段信息:" str1
		done
	done
	while ! grep  "^$num,.*$course," "$scores_db"|grep "$str1,"> /dev/null;do
		echo "不存在该字段，请重新输入:"
		read  str1
		#防止输入空格
		while [ "$str1" = '' ];do
			echo "输入有误，请重新:"
			read -p "要修改的字段信息:" str1
		done
	done


	read -p "修改后的字段信息:" str2
	#防止输入空格
	while [ "$str2" = '' ];do
		echo "输入有误，请重新:"
		read -p "修改后的字段信息:" str2
	done
	
	read -p "确定删除吗?[yes|no]" choice
	case "$choice" in
		yes)
			sed -i "/^$num,.*$course,/ s/$str1/$str2/" $scores_db
			if [ "$?" -eq 0 ];then
				echo "------------修改成功--------------"
				echo "修改了的信息"
				echo -e "学号\t姓名\t科目\t成绩\t说明"
				grep  "^$num,.*$course," "$scores_db" #学号和科目确定成绩的唯一性
				echo "--------------------------"
			else
				echo "修改失败"
			fi
			;;
		no)	
			:
			;;
		*)
			echo "请输入[yes|no]"
			modify_score
			;;
	esac
}

#6.个人总成绩前5名排序✔
sort_score_sum_five(){
	echo "-----------总成绩前1到5名---------------"
	printf "学号\t\t总成绩\t排名\t\n";
	awk -F"," '{ary[$1]+=$4} END{for(key in ary) print  key ",\t" ary[key]",\t"}'  $scores_db|sort -r -n -t',' -k 2| awk -F"," '{print $1 ",\t" $2",\t" NR ",\t"}'|sed -n '1,5p'
	echo "--------------------------"
}

#7.每个学科的前3名✔
such_course_sort_score(){
awk 'BEGIN{FS=","}{ary[$3]=$3} END{for(key in ary) print ary[key]}' $scores_db > temp
size=$(cat temp|wc -l)
top=1
while [ "$top" -le "$size" ];do
var=$(sed -n "$top p" temp)
grep "$var," $scores_db |sort -r -n -t "," -k 4 |sed -n '1,3p'|awk 'BEGIN{FS="," ; printf "科目\t学号\t姓名\t排名\t\n"}{printf $3 "\t" $1 "\t" $2 "\t" NR "\t\n"}'|column -t
echo ""
top=$(($top+1))
done
rm -rf temp
# 命令: Column
## 可以将文本结果转换为整齐的表格，上下对齐
## 使用的参数：
## -t ：表格，默认以空格间隔
## -s：需要配合-t使用，指定分隔符
}



#程序入口✔
Welcome
exit 0
