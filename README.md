> This template downloads a model at startup based on the PREINSTALLED_MODEL variable. **Before deployment, modify the template and set the value to the model you want to download.**
> If you don't want any model to be downloaded at startup, leave the value empty or delete the environment variable.

| Port | Type (HTTP/TCP) | Function     |
|------|-----------------|--------------|
| 22   | TCP             | SSH          |
| 3000 | HTTP            | ComfyUI      |
| 8888 | HTTP            | JupyterLab  |

---

| Environment Variable      | Description                                                                 | Default      |
|----------------------------|-----------------------------------------------------------------------------|--------------|
| `JUPYTERLAB_PASSWORD`       | Password for JupyterLab. If unset, no password is required.                 | (Not Set)    |
| `TIME_ZONE`                | System timezone. Defaults to `Etc/UTC` if unset.                            | `Etc/UTC`    |
| `COMFYUI_EXTRA_ARGS`        | Passes extra startup options to ComfyUI, such as `--fast`.                  | (Not Set)    |
| `INSTALL_SAGEATTENTION`     | Installs SageAttention at startup if not already installed. (May take about 5+ minutes.) (`True` or `False`) | `True` |
| `DOWNLOAD_MODEL_AT_STARTUP`        | Specifies the model to download at startup.     | `I2V-14B-480P` |

#### Possible Values for `DOWNLOAD_MODEL_AT_STARTUP`

| DOWNLOAD_MODEL_AT_STARTUP         | Description                                | Recommended VRAM |
|----------------------------|--------------------------------------------|------------------|
| `T2V-14B`                  | 480p, 720p Text-to-Video                  | ?                |
| `I2V-14B-720P`             | 720p Image-to-Video                       | 32GB+            |
| `I2V-14B-480P`             | 480p Image-to-Video                       | 24GB+            |
| `FLF2V-14B`                | 720p First-Last-Frame-to-Video            | 32GB+            |

#### **How to Use Environment Variables**

- In the "Edit Pod" or "Edit Template" screen, click **"Add Environment Variable."**
- For the **Key**, enter the name of the environment variable (e.g., `COMFYUI_EXTRA_ARGS`).
- For the **Value**, enter the appropriate setting or option.

> Refer to the [list of available time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) (e.g., `America/New_York`)

---

| Application | Log file                         |
|-------------|----------------------------------|
| ComfyUI     | /workspace/ComfyUI/user/comfyui_3000.log    |
| JupyterLab  | /workspace/logs/jupyterlab.log      |

If you have any suggestions or issues, please leave feedback at **<https://github.com/somb1/ComfyUI-Wan/issues>**

---

### **Pre-Installed Components**

#### **Base System**

- **OS**: Ubuntu 22.04
- **Framework**: ComfyUI + ComfyUI Manager + JupyterLab
- **Python**: 3.12
- **Libraries**:
  - PyTorch 2.6.0
  - CUDA 12.4
  - huggingface_hub, hf_transfer - [Link](https://huggingface.co/docs/huggingface_hub/index)
  - nvtop - [Link](https://github.com/Syllo/nvtop)

#### **Models**

##### Common Files

- wan_2.1_vae.safetensors
- umt5_xxl_fp16.safetensors
- clip_vision_h.safetensors

##### Based on DOWNLOAD_MODEL_AT_STARTUP

- T2V-14B -> wan2.1_t2v_14B_fp8_e4m3fn.safetensors
- I2V-14B-720P -> wan2.1_i2v_720p_14B_fp8_e4m3fn.safetensors
- I2V-14B-480P -> wan2.1_i2v_480p_14B_fp8_e4m3fn.safetensors
- FLF2V-14B -> wan2.1_flf2v_720p_14B_fp8_e4m3fn.safetensors

#### **Custom Nodes**

- `ComfyUI-WanVideoWrapper` - [Link](https://github.com/kijai/ComfyUI-WanVideoWrapper)
- `ComfyUI-VideoHelperSuite` - [Link](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- `ComfyUI-GGUF` - [Link](https://github.com/city96/ComfyUI-GGUF)
- `ComfyUI-Crystools` - [Link](https://github.com/crystian/ComfyUI-Crystools)  

---

### Running the Container Locally

```bash
docker run -d -p 3000:3000 -p 8888:8888 --gpus all -e JUPYTERLAB_PASSWORD="" -e TIME_ZONE="Etc/UTC" -e COMFYUI_EXTRA_ARGS="" -e INSTALL_SAGEATTENTION="True" -e PREINSTALLED_MODEL="I2V-14B-480P" --name comfyui-wan2.1-pytorch2.6.0_cu124 sombi/comfyui-wan:base-torch2.6.0-cu124

```

### Building the Container

```bash
docker buildx bake
```
