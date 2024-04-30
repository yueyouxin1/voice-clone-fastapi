# 使用CUDA 12为基础镜像
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# 为了防止在docker build 的时候出现时区选择的交互问题
ARG DEBIAN_FRONTEND=noninteractive

# 更新软件包列表并安装必要的包和依赖项
RUN apt-get update && apt-get install -y --no-install-recommends cmake python3-dev python3-distutils python3-pip tzdata ffmpeg libsox-dev parallel aria2 git git-lfs && \
    git lfs install && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python  # 建立软连接
# 如果需要，可以设置为国内的PyPI镜像源来加速下载
# RUN pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple

# 因为PyTorch通常是与CUDA版本一起编译的，我们确保下载正确版本的torch和torchvision
# 以及numpy等基础依赖
RUN pip install torch torchvision torchaudio einops
# 类似地，安装与CUDA版本兼容的TensorFlow版本
RUN pip install tensorflow==2.14

RUN git clone https://oauth2:qBUX-hGsMALsfH1yFyUV@www.modelscope.cn/yueyouxin/voiceClone.git
RUN pip install --no-cache-dir -r /voiceClone/requirements.txt

# 在容器中设置工作目录
WORKDIR /voiceClone

EXPOSE 9871 9872 9873 9874 9880

CMD ["python", "GPT_SoVITS/api.py"]
