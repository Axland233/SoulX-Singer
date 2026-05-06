# SoulX-Singer Windows 一键部署版

本仓库基于 [SoulX-Singer](https://soul-ailab.github.io/soulx-singer/) 整理，主要面向 Windows 用户做了额外适配，并加入了一键部署/启动脚本，方便尽量开箱即用。

SoulX-Singer 是由 Soul-AILab 发布的高质量零样本歌声合成与歌声转换项目。关于模型能力、论文、Demo、技术细节、数据说明和完整使用方式，请优先参考原项目主页：

https://soul-ailab.github.io/soulx-singer/

## 本仓库做了什么

- 针对 Windows 环境做了额外适配，降低手动配置 Python、依赖和模型目录的成本。
- 添加 `Runit.bat` 一键部署脚本，可自动准备运行环境并启动 WebUI。
- 默认使用镜像源安装 Python 依赖，并通过 Hugging Face 镜像下载模型，提升国内网络环境下的可用性。
- 保留原项目核心代码和模型加载方式，方便需要进一步研究的用户对照上游文档继续使用。

## 快速开始

### 1. 获取项目

下载或克隆本仓库后，进入项目目录。

### 2. 运行一键脚本

双击运行：

```bat
Runit.bat
```

脚本会自动执行以下步骤：

1. 准备便携版 Python 3.10.11 到 `runtime/python310`。
2. 配置 PyPI 镜像和 Hugging Face 镜像。
3. 安装 `requirements.txt` 中的依赖。
4. 下载 SoulX-Singer 预训练模型到 `pretrained_models/SoulX-Singer`。
5. 启动 WebUI，并自动打开浏览器。

默认访问地址：

```text
http://localhost:7861
```

首次运行需要下载 Python、依赖和模型文件，耗时取决于网络环境。后续再次运行会复用已安装的环境和模型。

## 目录说明

```text
Runit.bat                    Windows 一键部署/启动脚本
runtime/                     脚本自动创建的便携运行环境
pretrained_models/           预训练模型目录
webui.py                     SVS WebUI 入口
webui_svc.py                 SVC WebUI 入口
requirements.txt             Python 依赖列表
preprocess/                  原项目预处理相关代码
example/                     原项目示例脚本
```

## 手动运行

如果你已经自行配置好 Python 环境，也可以参考原项目方式手动安装依赖、下载模型并运行：

```bat
pip install -r requirements.txt
python webui_svc.py --port 7861
```

更完整的 SVS、SVC、预处理、MIDI 编辑与示例推理流程，请查看原项目文档：

https://soul-ailab.github.io/soulx-singer/

## 注意事项

- 本仓库重点是 Windows 环境适配和一键部署体验，不替代原项目的完整技术文档。
- 模型文件较大，首次部署请确保磁盘空间和网络连接充足。
- 如果下载失败，可以重新运行 `Runit.bat`，脚本会继续检查缺失内容。
- 生成或转换歌声时，请尊重版权、隐私和声音授权，不要用于冒充他人或制作误导性内容。

## 上游项目

- 项目主页：https://soul-ailab.github.io/soulx-singer/
- Hugging Face 模型：https://huggingface.co/Soul-AILab/SoulX-Singer
- 在线 Demo：https://huggingface.co/spaces/Soul-AILab/SoulX-Singer

## License

本仓库沿用原项目许可证。更多信息请查看 [LICENSE](LICENSE) 以及原项目说明。
