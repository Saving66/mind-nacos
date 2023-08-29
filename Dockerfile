# 使用 JDK8 镜像作为构建者
FROM openjdk:8-jdk-alpine AS builder

# 工作目录
WORKDIR /nacos-build

# 将 Nacos 源代码或可执行文件复制到工作目录
COPY nacos-server-1.4.1.tar.gz /nacos-build

# 创建目标目录并解压缩到该目录
RUN mkdir -p /nacos-build/nacos-server-1.4.1
RUN tar -xzvf nacos-server-1.4.1.tar.gz -C /nacos-build/nacos-server-1.4.1 --strip-components=1

# 使用轻量级的 Alpine 镜像作为运行时镜像
FROM openjdk:8-jre-alpine

# 持久化配置文件和日志文件
RUN mkdir -p /nacos-build/data
RUN mkdir -p /nacos-build/logs
VOLUME /nacos/data
VOLUME /nacos/logs

# 设置工作目录
WORKDIR /nacos

# 将从构建者镜像中复制文件
COPY --from=builder /nacos-build/nacos-server-1.4.1 /nacos

# 设置环境变量
ENV MODE="standalone"

# 设置启动命令
CMD ["/bin/sh", "-c", "cd /nacos/bin && sh startup.sh -m $MODE"]

# 暴露服务端口
EXPOSE 8848
