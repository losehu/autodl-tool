#!/bin/bash
# 用途：根据实例占用系统盘大小排序

# 获取当前用户名
USER_NAME=$(whoami)
echo $USER_NAME

# 根据用户名决定 overlay2 路径
if [ "$USER_NAME" = "amax" ]; then
    overlay2_path="/data0/docker/overlay2"
else
    overlay2_path="/var/lib/docker/overlay2"
fi

# 切换为 root 用户执行
sudo su <<EOF
echo "计算中。。。"
du -sh $overlay2_path/* | sort -rh > /home/$USER_NAME/output.txt
echo "匹配实例ID中"
EOF

# 输入txt文件路径
txt_file="/home/$USER_NAME/output.txt"

# 读取txt文件中的每一行
while IFS= read -r line; do
    # 提取容量和路径
    size=$(echo $line | awk '{print $1}')
    dir=$(echo $line | awk '{print $2}' | sed 's/\/$//')  # 去掉路径末尾的斜杠

    # 输出容量和路径
    echo "容量: $size 路径: $dir"

    # 检查是否提供了 target_dir 参数
    if [ -z "$dir" ]; then
        echo "请提供要查找的目录作为参数"
        exit 1
    fi

    # 从第一个参数获取 target_dir
    target_dir="$dir"

    # 获取所有容器的 ID
    containers=$(sudo docker ps -a -q)

    # 遍历每个容器
    for container_id in $containers; do
        # 获取该容器的 UpperDir
        upper_dir=$(sudo docker inspect --format '{{.GraphDriver.Data.UpperDir}}' $container_id)

        # 判断 UpperDir 是否包含指定的目录
        if echo "$upper_dir" | grep -q "$target_dir"; then
            # 获取容器名称
            container_name=$(sudo docker inspect --format '{{.Name}}' $container_id)

            # 去掉容器名称的前缀斜杠（/）
            container_name=${container_name#/}

            # 输出容器名称或 ID
            echo "容器名称: $container_name，容器ID: $container_id"
        fi
    done
done < "$txt_file"