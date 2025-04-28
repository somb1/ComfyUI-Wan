> This template downloads a model at startup based on `PREINSTALLED_MODEL`.
> **Set it to the model you want before deployment.**  
> Leave it empty or remove it to skip downloading.

### Exposed Ports

| Port | Type (HTTP/TCP) | Purpose       |
|------|-----------------|---------------|
| 22   | TCP              | SSH Access    |
| 3000 | HTTP             | ComfyUI       |
| 8888 | HTTP             | JupyterLab    |

---

### Environment Variables

| Variable                  | Description                                                                  | Default       |
|----------------------------|------------------------------------------------------------------------------|---------------|
| `JUPYTERLAB_PASSWORD`      | Password for JupyterLab. If unset, no password will be required.              | (Not Set)     |
| `TIME_ZONE`                | System timezone. Defaults to `Etc/UTC` if unset.                             | `Etc/UTC`     |
| `COMFYUI_EXTRA_ARGS`       | Extra startup options for ComfyUI, e.g., `--fast`.                           | (Not Set)     |
| `INSTALL_SAGEATTENTION`    | Install SageAttention at startup (`True` or `False`). May take over 5 minutes. | `True`        |
| `PREINSTALLED_MODEL`       | Specifies which model to download at startup.                                | `I2V-14B-480P` |

> **Note:** Installing SageAttention works correctly on GPUs from the Ampere architecture or newer.

---

### Available Models for `PREINSTALLED_MODEL`

| Value                | Description                         | Recommended VRAM |
|----------------------|-------------------------------------|------------------|
| `T2V-14B`             | 480p/720p Text-to-Video             | ?                |
| `T2V-1_3B`            | 480p Text-to-Video                  | ?                |
| `I2V-14B-720P`        | 720p Image-to-Video                 | 32GB+            |
| `I2V-14B-480P`        | 480p Image-to-Video                 | 24GB+            |
| `FLF2V-14B`           | 720p First-Last-Frame-to-Video      | 32GB+            |

### How to Set Environment Variables

1. On the **Edit Pod** or **Edit Template** screen, click **"Add Environment Variable."**
2. For **Key**, enter the name of the variable (e.g., `COMFYUI_EXTRA_ARGS`).
3. For **Value**, enter the desired setting or option.

> For time zones, refer to [this list of time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) (e.g., `America/New_York`).

---

### Log Files

| Application | Log Location                                   |
|-------------|------------------------------------------------|
| ComfyUI     | `/workspace/ComfyUI/user/comfyui_3000.log`     |
| JupyterLab  | `/workspace/logs/jupyterlab.log`               |

> If you encounter any issues or have suggestions, feel free to leave feedback at **[GitHub Issues](https://github.com/somb1/ComfyUI-Wan/issues)**.

---

## Pre-Installed Components

### Base System

- **OS:** Ubuntu 22.04
- **Framework:** ComfyUI + ComfyUI Manager + JupyterLab
- **Python:** 3.12
- **Libraries:**
  - PyTorch 2.6.0
  - CUDA 12.4
  - [huggingface_hub](https://huggingface.co/docs/huggingface_hub/index), [hf_transfer](https://huggingface.co/docs/huggingface_hub/index)
  - [nvtop](https://github.com/Syllo/nvtop)

### Models

#### VAE

- `wan_2.1_vae.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1_VAE_bf16.safetensors)

#### Text Encoder

- `umt5_xxl_fp16.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/umt5-xxl-enc-bf16.safetensors)

#### CLIP Vision

- `clip_vision_h.safetensors` - [Link](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/clip_vision/clip_vision_h.safetensors)

### Diffusion Models (Based on PREINSTALLED_MODEL)

- **T2V-14B** → `Wan2_1-T2V-14B_fp8_e4m3fn.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors)
- **T2V-1_3B** → `Wan2_1-T2V-1_3B_bf16.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-T2V-1_3B_fp8_e4m3fn.safetensors)
- **I2V-14B-720P** → `Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors)
- **I2V-14B-480P** → `Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors)
- **FLF2V-14B** → `Wan2_1-FLF2V-14B-720P_fp8_e4m3fn.safetensors` - [Link](https://huggingface.co/Kijai/WanVideo_comfy/blob/main/Wan2_1-FLF2V-14B-720P_fp8_e4m3fn.safetensors)

### Pre-Installed Custom Nodes

- `ComfyUI-WanVideoWrapper` - [Link](https://github.com/kijai/ComfyUI-WanVideoWrapper)
- `ComfyUI-VideoHelperSuite` - [Link](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- `ComfyUI-GGUF` - [Link](https://github.com/city96/ComfyUI-GGUF)
- `ComfyUI-Crystools` - [Link](https://github.com/crystian/ComfyUI-Crystools)
- `ComfyUI-KJNodes` - [Link](https://github.com/kijai/ComfyUI-KJNodes)  

---

## Running the Container Locally

```bash
docker run -d -p 3000:3000 -p 8888:8888 --gpus all \
  -e JUPYTERLAB_PASSWORD="" \
  -e TIME_ZONE="Etc/UTC" \
  -e COMFYUI_EXTRA_ARGS="" \
  -e INSTALL_SAGEATTENTION="True" \
  -e PREINSTALLED_MODEL="I2V-14B-480P" \
  --name comfyui-wan2.1 \
  sombi/comfyui-wan:base-torch2.6.0-cu124
```

## Building the Container

```bash
docker buildx bake
```
