# 使用 JDK8 镜像作为构建者
FROM openjdk:8-jdk-alpine AS builder

# 工作目录
WORKDIR /nacos-build

# 设置构建时环境变量，这里仅作为一个例子
ARG BUILDTIME_ENV_EXAMPLE
ENV BUILDTIME_ENV_EXAMPLE=${BUILDTIME_ENV_EXAMPLE}

# 将 Nacos 源代码或可执行文件复制到工作目录
COPY nacos-server-版本号.tar.gz /nacos-build

# 进行构建（如果需要的话，例如解压缩或其他任务）
RUN tar -xzvf nacos-server-1.4.1.tar.gz


# 使用轻量级的 Alpine 镜像作为运行时镜像
FROM openjdk:8-jre-alpine

# 持久化配置文件和日志文件
VOLUME /nacos/data
VOLUME /nacos/logs

# 设置工作目录
WORKDIR /nacos

# 将从构建者镜像中复制文件
COPY --from=builder /nacos-build/nacos-server-版本号 /nacos

# 设置环境变量
ENV MODE="standalone"

# 设置启动命令
CMD ["/bin/sh", "-c", "cd /nacos/bin && sh startup.sh -m $MODE"]

# 暴露服务端口
EXPOSE 8848
