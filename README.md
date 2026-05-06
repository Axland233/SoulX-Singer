# SoulX-Singer Windows 一键部署版

本仓库基于原版 **SoulX-Singer** 推理项目做了 Windows 环境适配，目标是让 Windows 用户尽量做到下载后开箱即用。

如果你想了解模型原理、论文、Demo、数据集、官方说明、许可证和引用方式，请优先查看原项目页面：

https://soul-ailab.github.io/soulx-singer/

本仓库主要关注 Windows 下的可运行性、部署便利性和小显存稳定性。

## 本版改动

相比原版，本仓库做了以下额外适配：

- 针对 Windows 环境做了额外适配，降低手动配置 Python、依赖和模型目录的成本。
- 添加 `Runit.bat` 一键部署脚本，可自动准备运行环境并启动 WebUI。
- 默认使用镜像源安装 Python 依赖，并通过 Hugging Face 镜像下载模型，提升国内网络环境下的可用性。
- 保留原项目核心代码和模型加载方式，方便需要进一步研究的用户对照上游文档继续使用。

## 快速开始

### 运行 SVS WebUI

双击：

```bat
Runwebui.bat
```

脚本会自动完成：

- 准备便携 Python 3.10.11 到 `runtime/python310`
- 配置 PyPI 镜像和 Hugging Face 镜像
- 安装 `requirements.txt`
- 下载 SoulX-Singer 预训练模型到 `pretrained_models/SoulX-Singer`
- 启动 SVS WebUI
- 自动打开浏览器访问 `http://localhost:7860`

### 运行 SVC WebUI

双击：

```bat
Runwebuisvc.bat
```

脚本会自动完成同样的部署流程，并启动 SVC WebUI：

```text
http://localhost:7861
```

## 目录说明

首次运行后，脚本会生成或使用以下目录：

```text
runtime/
  python310/                 便携 Python 环境
  python-3.10.11-amd64.exe   Python 安装包缓存
  .requirements-installed    依赖安装完成标记

pretrained_models/
  SoulX-Singer/              SoulX-Singer / SVC 模型文件

outputs/                     WebUI 输出结果
```

如果你需要重新安装依赖，可以删除：

```text
runtime/.requirements-installed
```

然后重新运行对应的 `.bat` 脚本。

## 手动运行

如果你不想使用一键部署脚本，也可以手动配置环境：

```bat
conda create -n soulxsinger python=3.10 -y
conda activate soulxsinger
pip install -r requirements.txt
```

下载模型：

```bat
hf download Soul-AILab/SoulX-Singer --local-dir pretrained_models/SoulX-Singer
```

启动 SVS：

```bat
python webui.py
```

启动 SVC：

```bat
python webui_svc.py
```

## 显存说明

原版的模型加载策略更偏向速度，会在启动或预热阶段把多个模型放进显存。本版针对 Windows 用户和小显存显卡做了调整：

- 按需轮换加载模型，降低峰值显存占用。
- 推理阶段尽量释放不再使用的模型和缓存。
- 更适合显存较小、容易 OOM 的机器。

代价是：部分步骤会因为模型重复加载而变慢。这个版本的取舍是优先保证能稳定跑起来。

## 常见问题

### 第一次启动很慢

正常。首次运行需要下载 Python、安装依赖、下载模型，耗时取决于网络和磁盘速度。后续启动会复用 `runtime` 和 `pretrained_models` 中的内容。

### 模型下载失败

脚本默认使用 Hugging Face 镜像：

```text
https://hf-mirror.com
```

如果镜像不可用，可以稍后重试，或手动将模型文件放入：

```text
pretrained_models/SoulX-Singer
```

SVS 至少需要：

```text
model.pt
config.yaml
```

SVC 至少需要：

```text
model-svc.pt
config.yaml
```

### 端口被占用

SVS 默认端口为 `7860`，SVC 默认端口为 `7861`。如果浏览器没有自动打开，可以手动访问对应地址。

## 原项目信息

SoulX-Singer 是由 Soul AILab 发布的高质量零样本歌声合成项目。模型能力、论文、在线 Demo、示例音频、技术报告、许可证、引用方式等信息请查看官方项目页：

https://soul-ailab.github.io/soulx-singer/

本仓库仅在原项目基础上做 Windows 运行体验和显存占用方面的额外适配。

## 许可证

请遵循原项目许可证。详细信息见本仓库的 [LICENSE](LICENSE)，以及原项目页面：

https://soul-ailab.github.io/soulx-singer/

