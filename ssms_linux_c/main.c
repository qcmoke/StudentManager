#include <stdio.h>
#include <stdlib.h>
#include <mysql.h>
#include <malloc.h>
#include <string.h>

//不支持bool类型，故定义以下宏
#define bool int
#define true 1
#define false 0

//数据库初始化全局变量
//localhost是本机地址，root是用户名，123456是我数据库密码，ssms是数据库名，3306是端口号
char *host = "localhost";
char *username = "root";
char *password = "123456";
char *database = "ssms";
int port = 3306;

MYSQL *conn_ptr;
MYSQL_RES *res_ptr;
MYSQL_ROW sqlrow;
char *sql; //sql语句

/*数据库封装函数*/
MYSQL *getConnect();
void init();
void dbClose();
bool exec(char *sql);
void show_head(MYSQL_RES *rs);
void show_row(MYSQL_RES *rs);
void showtable(MYSQL_RES *rs);
MYSQL *getConnBySql(char *sql);
MYSQL_RES *getResult(char *sql);
int getRScount(char *sql);

/*系统菜单函数*/
void welcome();
void menu1();
void menu2();
void menu3();

/*学院信息模块函数*/
bool add_school();
bool del_school();
bool update_school();
MYSQL_RES *find_school();
void display_schools();

/*学生信息模块函*/
bool add_student();
bool del_student();
bool update_student();
void find_student();
void display_student();

/* 成绩管理模块函数 */
void add_score();
void del_score();
void display_score();
void find_score();
void update_score();
void sortScoresByStu();
void sortScoresByCourse();

int main(int argc, char const *argv[])
{
    init();
    welcome();

    dbClose(); //关闭数据库
    return 0;
}

//连接数据库
MYSQL *getConnect()
{
    int n;
    conn_ptr = mysql_init(NULL); //初始化数据库
    //连接数据库
    if (!mysql_real_connect(conn_ptr, host, username, password, database, port, NULL, 0))
    {
        fprintf(stderr, "Error connecting to datebase:%s", mysql_error(conn_ptr));
    }
    /* else
    {
        puts("Success connect...");
    }
 */
    //设置字符
    if (mysql_set_character_set(conn_ptr, "utf8"))
    {
        fprintf(stderr, "错误，%s\n", mysql_error(conn_ptr));
    }
    return conn_ptr;
}

//初始化数据库相关变量
void init()
{
    getConnect();
    sql = (char *)malloc(sizeof(char));
}
//关闭数据库
void dbClose()
{

    if (res_ptr != NULL)
    {
        mysql_free_result(res_ptr);
    }
    if (conn_ptr != NULL)
    {
        mysql_close(conn_ptr); //关闭数据库连接
    }
    if (sql != NULL)
    {
        free(sql);
    }
}

/*增删改操作*/
bool exec(char *sql)
{
    MYSQL *conn = getConnect();
    int res = mysql_query(conn, sql);
    mysql_close(conn);
    if (res != 0)
    {
        return false;
    }
    return true;
}

// 显示表头
void show_head(MYSQL_RES *rs)
{
    MYSQL_FIELD *field_ptr;
    while ((field_ptr = mysql_fetch_field(rs)) != NULL)
    {
        printf("%-30s", field_ptr->name);
    }
    putchar('\n');
}

//显示表数据
void show_row(MYSQL_RES *rs)
{
    unsigned int i, n;
    MYSQL_ROW sqlrow;
    n = mysql_num_fields(rs);
    while ((sqlrow = mysql_fetch_row(rs)))
    {
        for (i = 0; i < n; i++)
        {
            printf("%-30s", sqlrow[i]);
        }
        putchar('\n');
    }
}

//显示结果集的表头和表数据
void showtable(MYSQL_RES *rs)
{
    show_head(rs);
    show_row(rs);
}

//通过sql设置连接句柄获取指定sql的连接
MYSQL *getConnBySql(char *sql)
{
    int flag = mysql_query(conn_ptr, sql);
    if (flag != 0)
    {
        return NULL;
    }
    return conn_ptr;
}

//获取指定sql的结果集
MYSQL_RES *getResult(char *sql)
{
    MYSQL *conn = getConnect();
    res_ptr = NULL;
    mysql_query(conn, sql);
    res_ptr = mysql_store_result(conn); //mysql_use_result(conn_ptr);
    mysql_close(conn);
    return res_ptr;
}

int getRScount(char *sql)
{
    MYSQL *conn = getConnect();
    mysql_query(conn, sql);
    res_ptr = mysql_store_result(conn);
    int num = mysql_num_rows(res_ptr);
    mysql_close(conn);
    return num;
}

void welcome()
{
    system("clear");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    printf("\t\t\t        欢迎访问学生管理系统          \t\t\t\n");
    printf("\t\t\t        请选择功能管理，输入序号       \t\t\t\n");
    printf("\t\t\t        1. 学院信息管理              \t\t\t\n");
    printf("\t\t\t        2. 学生信息管理              \t\t\t\n");
    printf("\t\t\t        3. 成绩信息管理              \t\t\t\n");
    printf("\t\t\t        4. 退出系统                  \t\t\t\n");
    printf("\t\t\t-----------------------------------\t\t\t\n");

    int choice;
    printf("input:");
    scanf("%d", &choice);
    switch (choice)
    {
    case 1:
        menu1();
        break;

    case 2:
        menu2();
        break;

    case 3:
        menu3();
        break;

    case 4:
        exit(0);
        break;

    default:
        welcome();
    }
}

// 学院信息模块菜单✔
void menu1()
{
    system("clear");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    printf("\t\t\t        学院信息模块菜单              \t\t\t\n");
    printf("\t\t\t        请选择功能，输入序号       \t\t\t\n");
    printf("\t\t\t        1. 添加学院                 \t\t\t\n");
    printf("\t\t\t        2. 删除学院                 \t\t\t\n");
    printf("\t\t\t        3. 学院列表                 \t\t\t\n");
    printf("\t\t\t        4. 查找学院                 \t\t\t\n");
    printf("\t\t\t        5. 修改学院                 \t\t\t\n");
    printf("\t\t\t        6. 返回上级                 \t\t\t\n");
    printf("\t\t\t        7. 退出系统                 \t\t\t\n");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    int choice;
    printf("input:");
    scanf("%d", &choice);
    switch (choice)
    {
    case 1:
        add_school();
        getchar(); //停留在当前页面
        break;

    case 2:
        del_school();
        getchar(); //停留在当前页面
        break;

    case 3:
        display_schools();
        getchar(); //停留在当前页面
        break;
    case 4:
        find_school();
        getchar(); //停留在当前页面
        break;
    case 5:
        update_school();
        getchar(); //停留在当前页面
        break;
    case 6:
        welcome();
        break;

    case 7:
        exit(0);
        break;

    default:
        menu1();
    }
    printf("按任意键继续...");
    getchar();
    menu1();
}

void menu2()
{
    system("clear");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    printf("\t\t\t        学生信息模块菜单              \t\t\t\n");
    printf("\t\t\t        请选择功能，输入序号       \t\t\t\n");
    printf("\t\t\t        1. 添加学生                 \t\t\t\n");
    printf("\t\t\t        2. 删除学生                 \t\t\t\n");
    printf("\t\t\t        3. 学生列表                 \t\t\t\n");
    printf("\t\t\t        4. 查找学生                 \t\t\t\n");
    printf("\t\t\t        5. 修改学生                 \t\t\t\n");
    printf("\t\t\t        6. 返回上级                 \t\t\t\n");
    printf("\t\t\t        7. 退出系统                 \t\t\t\n");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    int choice;
    printf("input:");
    scanf("%d", &choice);
    switch (choice)
    {
    case 1:
        add_student();
        getchar(); //停留在当前页面
        break;

    case 2:
        del_student();
        getchar(); //停留在当前页面
        break;

    case 3:
        display_student();
        getchar(); //停留在当前页面
        break;
    case 4:
        find_student();
        getchar(); //停留在当前页面
        break;
    case 5:
        update_student();
        getchar(); //停留在当前页面
        break;
    case 6:
        welcome();
        break;

    case 7:
        exit(0);
        break;

    default:
        menu2();
    }
    printf("按任意键继续...");
    getchar();
    menu2();
}

void menu3()
{
    system("clear");
    printf("\t\t\t----------------------------------\t\t\t\n");
    printf("\t\t\t        成绩信息模块菜单             \t\t\t\n");
    printf("\t\t\t        请选择功能，输入序号          \t\t\t\n");
    printf("\t\t\t        1. 添加成绩                 \t\t\t\n");
    printf("\t\t\t        2. 删除成绩                 \t\t\t\n");
    printf("\t\t\t        3. 成绩列表                 \t\t\t\n");
    printf("\t\t\t        4. 查找成绩                 \t\t\t\n");
    printf("\t\t\t        5. 修改成绩                 \t\t\t\n");
    printf("\t\t\t        6. 个人总成绩排名            \t\t\t\n");
    printf("\t\t\t        7. 科目成绩排名              \t\t\t\n");
    printf("\t\t\t        8. 返回上级                 \t\t\t\n");
    printf("\t\t\t        9. 退出系统                 \t\t\t\n");
    printf("\t\t\t-----------------------------------\t\t\t\n");
    int choice;
    printf("input:");
    scanf("%d", &choice);
    switch (choice)
    {
    case 1:
        add_score();
        getchar(); //停留在当前页面
        break;

    case 2:
        del_score();
        getchar(); //停留在当前页面
        break;

    case 3:
        display_score();
        getchar(); //停留在当前页面
        break;
    case 4:
        find_score();
        getchar(); //停留在当前页面
        break;
    case 5:
        update_score();
        getchar(); //停留在当前页面
        break;
    case 6:
        sortScoresByStu();
        getchar(); //停留在当前页面
        break;
    case 7:
        sortScoresByCourse();
        getchar(); //停留在当前页面
        break;
    case 8:
        welcome();
        break;

    case 9:
        exit(0);
        break;

    default:
        menu3();
    }
    printf("按任意键继续...");
    getchar();
    menu3();
}

//添加学院
bool add_school()
{
    char *school_num;
    school_num = (char *)malloc(sizeof(char));
    printf("请输入学院编号：");
    scanf("%s", school_num); //如果输入空字符串或者直接回车，scanf函数会自动继续让用户输入

    char *school_name;
    school_name = (char *)malloc(sizeof(char));
    printf("请输入学院名称：");
    scanf("%s", school_name);
    sprintf(sql, "insert into schools(school_num,school_name)value('%s','%s')", school_num, school_name);

    if (school_num != NULL)
    {
        free(school_num);
    }
    if (school_name != NULL)
    {
        free(school_name);
    }

    if (exec(sql) == false)
    {
        puts("插入error!");
        return false;
    }
    puts("插入 success!");
    return true;
}

//删除学院
bool del_school()
{
    char *school_num;
    school_num = (char *)malloc(sizeof(char));
    printf("当前系统学院列表如下：\n");
    display_schools(conn_ptr);
    printf("请输入学校编号：");
    scanf("%s", school_num);
    sprintf(sql, "delete from schools where school_num = '%s' ", school_num);
    if (school_num != NULL)
    {
        free(school_num);
    }

    if (exec(sql))
    {
        puts("删除 success!");
        return true;
    }
    else
    {
        puts("删除  error!");
        return false;
    }
}

//修改学院
bool update_school()
{
    char *school_num;
    school_num = (char *)malloc(sizeof(char));

    printf("学院列表如下:\n");
    display_schools(conn_ptr);
    printf("请输入要修改的学院编号:");
    scanf("%s", school_num);
    sprintf(sql, "select * from schools where school_num='%s'", school_num);
    printf("你要操作的学院信息如下:\n");
    showtable(getResult(sql));

    char *str1;
    str1 = (char *)malloc(sizeof(char));
    printf("请输入学院名称：");
    scanf("%s", str1);
    sprintf(sql, "update schools set school_name = '%s' where school_num='%s'", str1, school_num);
    printf("sql:%s\n", sql);
    bool flag = exec(sql);
    if (str1 != NULL)
    {
        free(str1);
    }
    if (school_num != NULL)
    {
        free(school_num);
    }

    if (flag == false)
    {
        printf("修改失败\n");
        return false;
    }
    else
    {
        printf("修改成功\n");
        return true;
    }
}

//查找学院
MYSQL_RES *find_school()
{
    printf("请输入要查询的学院编号:");
    char *school_num;
    school_num = (char *)malloc(sizeof(char));
    scanf("%s", school_num);
    sprintf(sql, "select * from schools where school_num='%s'", school_num);
    printf("你要查找的学院信息为:\n");
    MYSQL_RES *rs = getResult(sql);
    showtable(rs);
    if (school_num != NULL)
    {
        free(school_num);
    }

    if (rs == NULL)
    {
        return NULL;
    }
    return rs;
}

//学院列表
void display_schools()
{
    //获得结果集
    MYSQL_RES *res_ptr = getResult("select * from schools");
    //显示结果集的表头和表数据
    showtable(res_ptr);
}

/*学生信息模块函*/
bool add_student()
{
    char *student_num;
    char *student_name;
    char *school_num;
    char *stu_des;
    student_num = (char *)malloc(sizeof(char));
    student_name = (char *)malloc(sizeof(char));
    school_num = (char *)malloc(sizeof(char));
    stu_des = (char *)malloc(sizeof(char));

    printf("当前学院列表信息如下：");
    display_schools();
    printf("请输入学院的编号：");
    scanf("%s", school_num);
    sprintf(sql, "select * from schools where school_num = '%s'", school_num);
    while (getRScount(sql) == 0)
    {
        printf("不存在该编号对应的学院，请重新输入学院的编号：");
        scanf("%s", school_num);
        sprintf(sql, "select * from schools where school_num='%s'", school_num);
    }
    printf("请输入学生编号：");
    scanf("%s", student_num);

    sprintf(sql, "select * from students where stu_num = '%s'", student_num);
    while (getRScount(sql) > 0)
    {
        printf("该编号对应的学生已经存在，请重新输入学生的编号：");
        scanf("%s", student_num);
        sprintf(sql, "select * from students where stu_num='%s'", student_num);
    }
    printf("请输入学生名字：");
    scanf("%s", student_name);
    printf("请输入学生说明：");
    scanf("%s", stu_des);
    sprintf(sql, "insert into students(stu_num,stu_name,school_num,stu_des)value('%s','%s','%s','%s')", student_num, student_name, school_num, stu_des);
    if (exec(sql) == false)
    {
        printf("添加失败\n");
    }
    else
    {
        printf("添加成功\n");
    }
    if (student_num != NULL)
    {
        free(student_num);
    }
    if (student_name != NULL)
    {
        free(student_name);
    }
    if (school_num != NULL)
    {
        free(school_num);
    }
    if (stu_des != NULL)
    {
        free(stu_des);
    }
    return true;
}
bool del_student()
{
    char *stu_num = (char *)malloc(sizeof(char));
    display_student();
    printf("请选择要删除的学生的编号:");
    scanf("%s", stu_num);
    sprintf(sql, "delete from students where stu_num = '%s' ", stu_num);
    if (stu_num != NULL)
    {
        free(stu_num);
    }

    if (exec(sql))
    {
        puts("删除成功!");
        return true;
    }
    else
    {
        puts("删除失败!");
        return false;
    }
}
bool update_student()
{

    char *stu_num = (char *)malloc(sizeof(char));
    char *str1 = (char *)malloc(sizeof(char));
    char *str2 = (char *)malloc(sizeof(char));
    printf("学院列表如下:\n");
    display_student();
    printf("请输入要修改的学生编号:");
    scanf("%s", stu_num);
    sprintf(sql, "select * from students where stu_num='%s'", stu_num);
    printf("你要操作的学院信息如下:\n");
    showtable(getResult(sql));

    printf("请输入除了学号以外的字段：");
    scanf("%s", str1);
    sprintf(sql, "select %s from students", str1);
    //printf("sql:%s\n", sql);
    while (exec(sql) == false)
    {
        printf("您输入的字段不符,请重新输入除了学号以外的字段：");
        scanf("%s", str1);
        sprintf(sql, "select %s from students", str1);
    }

    printf("请输入该字段的值：");
    scanf("%s", str2);
    sprintf(sql, "update students set %s = '%s' where stu_num = '%s'", str1, str2, stu_num);
    printf("sql:%s\n", sql);
    bool flag = exec(sql);
    if (stu_num != NULL)
    {
        free(stu_num);
    }
    if (str1 != NULL)
    {
        free(str1);
    }
    if (str2 != NULL)
    {
        free(str2);
    }
    if (flag == false)
    {
        printf("修改失败\n");
        return false;
    }
    else
    {
        printf("修改成功\n");
        return true;
    }
}
void find_student()
{
    printf("请输入要查询的学生编号:");
    char *stu_num;
    stu_num = (char *)malloc(sizeof(char));
    scanf("%s", stu_num);
    sprintf(sql, "select * from students where stu_num='%s'", stu_num);
    printf("你要查找的学生信息为:\n");
    MYSQL_RES *rs = getResult(sql);
    showtable(rs);
    if (stu_num != NULL)
    {
        free(stu_num);
    }
}
void display_student()
{
    //获得结果集
    MYSQL_RES *rs = getResult("select * from students");
    //显示结果集的表头和表数据

    printf("当前学生的列表如下:\n");
    showtable(rs);
}

/* 成绩管理模块函数 */
void add_score()
{
    char *stu_num = (char *)malloc(sizeof(char));
    char *course = (char *)malloc(sizeof(char));
    float score;
    char *score_des = (char *)malloc(sizeof(char));
    printf("当前学生列表信息如下：");
    display_student();
    printf("请输入学生的编号：");
    scanf("%s", stu_num);
    sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
    while (getRScount(sql) == 0)
    {
        printf("不存在该编号对应的学生，请重新输入编号：");
        scanf("%s", stu_num);
        sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
    }
    printf("请输入科目名称：");
    scanf("%s", course);
    sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    while (getRScount(sql) > 0)
    {
        printf("该学生该科目成绩已经存在，请重新输入：");
        printf("当前学生列表信息如下：");
        display_student();
        printf("请输入学生的编号：");
        scanf("%s", stu_num);
        sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
        while (getRScount(sql) == 0)
        {
            printf("不存在该编号对应的学生，请重新输入编号：");
            scanf("%s", stu_num);
            sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
        }
        printf("请输入科目名称：");
        scanf("%s", course);
        sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    }
    printf("请输入该学生该科目的成绩：");
    scanf("%f", &score);
    printf("请输入成绩说明：");
    scanf("%s", score_des);
    sprintf(sql, "insert into scores(stu_num,course,score,score_des)value('%s','%s','%f','%s')", stu_num, course, score, score_des);
    if (exec(sql) == false)
    {
        printf("添加失败\n");
    }
    else
    {
        printf("添加成功\n");
    }
    if (stu_num != NULL)
    {
        free(stu_num);
    }
    if (course != NULL)
    {
        free(course);
    }
    if (score_des != NULL)
    {
        free(score_des);
    }
}
void del_score()
{
    char *stu_num = (char *)malloc(sizeof(char));
    char *course = (char *)malloc(sizeof(char));
    display_score();
    printf("请输入学生的编号：");
    scanf("%s", stu_num);
    sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
    while (getRScount(sql) == 0)
    {
        printf("不存在该编号对应的学生，请重新输入编号：");
        scanf("%s", stu_num);
        sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
    }
    printf("请输入科目名称：");
    scanf("%s", course);
    sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    while (getRScount(sql) == 0)
    {
        printf("该学生该科目成绩不存在，请重新输入：");
        printf("当前学生列表信息如下：");
        display_score();
        printf("请输入学生的编号：");
        scanf("%s", stu_num);
        sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
        while (getRScount(sql) == 0)
        {
            printf("不存在该编号对应的学生，请重新输入编号：");
            scanf("%s", stu_num);
            sprintf(sql, "select * from students where stu_num = '%s'", stu_num);
        }
        printf("请输入科目名称：");
        scanf("%s", course);
        sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    }

    sprintf(sql, "delete from scores where stu_num = '%s' and course='%s'", stu_num, course);
    if (exec(sql))
    {
        puts("删除成功!");
    }
    else
    {
        puts("删除失败!");
    }
    if (stu_num != NULL)
    {
        free(stu_num);
    }
    if (course != NULL)
    {
        free(course);
    }
}
void display_score()
{
    //获得结果集
    MYSQL_RES *rs = getResult("select * from scores");
    //显示结果集的表头和表数据
    printf("当前成绩的列表如下:\n");
    showtable(rs);
}
void find_score()
{
    char *stu_num = (char *)malloc(sizeof(char));
    char *course = (char *)malloc(sizeof(char));
    display_score();
    printf("请输入要查询的学生编号:");
    scanf("%s", stu_num);
    printf("请输入要查询的科目名称:");
    scanf("%s", course);
    sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    printf("你要查找的学生信息为:\n");
    MYSQL_RES *rs = getResult(sql);
    showtable(rs);
    if (stu_num != NULL)
    {
        free(stu_num);
    }
    if (course != NULL)
    {
        free(course);
    }
}
void update_score()
{
    char *stu_num = (char *)malloc(sizeof(char));
    char *course = (char *)malloc(sizeof(char));
    char *str1 = (char *)malloc(sizeof(char));
    char *str2 = (char *)malloc(sizeof(char));
    printf("成绩列表如下:\n");
    display_score();
    printf("请输入要修改的学生编号:");
    scanf("%s", stu_num);
    printf("请输入要修改的科目名称:");
    scanf("%s", course);
    sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    while (getRScount(sql) == 0)
    {
        printf("您修改的相关成绩不存在，请重新输入信息...\n");
        printf("请输入要修改的学生编号:");
        scanf("%s", stu_num);
        printf("请输入要修改的科目名称:");
        scanf("%s", course);
        sprintf(sql, "select * from scores where stu_num = '%s' and course='%s'", stu_num, course);
    }

    printf("你要操作的科目成绩信息如下:\n");
    showtable(getResult(sql));

    printf("请输入除了学号和科目以外的字段：");
    scanf("%s", str1);
    sprintf(sql, "select %s from scores", str1);
    //printf("sql:%s\n", sql);
    while (exec(sql) == false)
    {
        printf("您输入的字段不符,请重新输入除了学号以外的字段：");
        scanf("%s", str1);
        sprintf(sql, "select %s from scores", str1);
    }

    printf("请输入该字段的值：");
    scanf("%s", str2);
    sprintf(sql, "update scores set %s = '%s' where stu_num = '%s' and course='%s' ", str1, str2, stu_num, course);
    printf("sql:%s\n", sql);
    bool flag = exec(sql);
    if (flag == false)
    {
        printf("修改失败\n");
    }
    else
    {
        printf("修改成功\n");
    }
    if (stu_num != NULL)
    {
        free(stu_num);
    }
    if (str1 != NULL)
    {
        free(str1);
    }
    if (str2 != NULL)
    {
        free(str2);
    }
    if (course != NULL)
    {
        free(course);
    }
}

void sortScoresByStu()
{
    sql="select temp.stu_num,s.stu_name,temp.sum,@rownum:=@rownum+1 rank from (SELECT stu_num,SUM(score) sum FROM scores,(SELECT @rownum:=0) r GROUP BY stu_num)as temp JOIN students s ON s.stu_num=temp.stu_num ORDER BY temp.sum DESC LIMIT 0,3";
    //获得结果集
    MYSQL_RES *rs = getResult(sql);
    //显示结果集的表头和表数据
    printf("当前前5名成绩按学生总分排名列表如下:\n");
    showtable(rs);
    /*
        select temp.stu_num,s.stu_name,temp.sum,@rownum:=@rownum+1 rank 
        from 
        (
            SELECT stu_num,SUM(score) sum 
            FROM scores,(SELECT @rownum:=0) r 
            GROUP BY stu_num
        )as temp
        JOIN students s ON s.stu_num=temp.stu_num 
        ORDER BY temp.sum DESC 
        LIMIT 0,3
    */
}

void sortScoresByCourse()
{    
    sql="SELECT a.course,a.stu_num,s.stu_name,a.score,a.score_des, count(*) as rank FROM scores a JOIN scores b ON a.course = b.course AND a.score <= b.score JOIN students s ON s.stu_num=a.stu_num  GROUP BY a.course,a.stu_num ORDER BY a.course asc,a.score desc";
    MYSQL_RES *rs = getResult(sql);
    printf("每科目成绩排名列表如下:\n");
    showtable(rs);
    /*
        SELECT a.course,a.stu_num,s.stu_name,a.score,a.score_des, count(*) as rank 
        FROM scores a
        JOIN scores b ON a.course = b.course AND a.score <= b.score
        JOIN students s ON s.stu_num=a.stu_num 
        GROUP BY a.course,a.stu_num
        ORDER BY a.course asc,a.score desc
    */
}