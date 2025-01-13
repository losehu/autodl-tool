USER_NAME=$(whoami)
sudo su <<EOF
echo "$USER_NAME"

docker_output=\$(docker ps -a --format '{{.Status}} {{.Names}}')
echo "\$docker_output" | while IFS= read -r line; do
    # 提取状态和容器名
    DOCKER_STATUS=\$(echo "\$line" | awk '{for(i=1;i<=NF-1;i++) printf \$i " ";}')
    DOCKER_NAME=\$(echo "\$line" | awk '{print \$NF}')
    DOCKER_PATH=\$(docker inspect "\$DOCKER_NAME" | grep -o '"Source": "[^"]*-storage"' | awk -F': ' '{print \$2}' | tr -d '"' | head -n 1)
    if [ -d "\$DOCKER_PATH" ]; then
        DOCKER_SIZE=\$(du -sh "\$DOCKER_PATH" | awk '{print \$1}')
    else
        DOCKER_SIZE="N/A"
    fi


)

    # 格式化输出，每列间隔30字符
    printf "%-30s %-30s %-30s\n" "\$(echo "\$DOCKER_NAME" | sed 's/^autodl-container-//')" "\$DOCKER_STATUS" "\$DOCKER_SIZE"
done
EOF
)

    # 格式化输出，每列间隔30字符
    printf "%-30s %-30s %-30s\n" "\$(echo "\$DOCKER_NAME" | sed 's/^autodl-container-//')" "\$DOCKER_STATUS" "\$DOCKER_SIZE"
done
EOF
