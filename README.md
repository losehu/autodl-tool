# autodl-tool
autodl维护脚本,用来检索哪些实例占用大量系统盘，以及长时间未使用实例不释放

# 说明
## find_data.sh 
* 用途：输出实例占用的数据盘容量大小、使用情况(上次使用时间、现在使用时间)、autodl实例ID
* 使用方法：将overlay2_path换成你本机docker目录

## find_sys.sh 
* 用途：输出实例占用的系统盘容量大小并按照大到小排序


