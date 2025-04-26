| Port | Type (HTTP/TCP) | Function     |
|------|-----------------|--------------|
| 22   | TCP             | SSH          |
| 3000 | HTTP            | ComfyUI      |
| 8888 | HTTP            | JupyterLab  |

---

| Wan 2.1 Container Image | Description | VRAM Requirement (Approx.) |
| :--- | :--- | :--- |
| `sombi/comfyui-wan:i2v-14b-720p-torch2.6.0-cu124-dev` | 720p Image-to-Video | 32GB+ |
| `sombi/comfyui-wan:i2v-14b-480p-torch2.6.0-cu124-dev`| 480p Image-to-Video | 24GB+ |
| `sombi/comfyui-wan:flf2v-14b-torch2.6.0-cu124-dev` | 720p First-Last-Frame-to-Video | 32GB+ |

#### **How to Use Container Image**

You can replace the container image in the **Edit Pod** or **Edit Template** section with the desired image.

---

| Environment Variable      | Description                                                                 | Default      |
|----------------------------|-----------------------------------------------------------------------------|--------------|
| `JUPYTERLAB_PASSWORD`       | Password for JupyterLab. If unset, no password is required.                 | (Not Set)    |
| `TIME_ZONE`                | System timezone. Defaults to `Etc/UTC` if unset.                            | `Etc/UTC`    |
| `COMFYUI_EXTRA_ARGS`        | Passes extra startup options to ComfyUI, such as `--fast`. | (Not Set)    |
| `INSTALL_SAGEATTENTION`     | Installs SageAttention at startup if not already installed. (May take about 5+ minutes.) (`True` or `False`) | `True` |

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

#### **Custom Nodes**

- `ComfyUI-WanVideoWrapper` - [Link](https://github.com/kijai/ComfyUI-WanVideoWrapper)
- `ComfyUI-VideoHelperSuite` - [Link](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- `ComfyUI-GGUF` - [Link](https://github.com/city96/ComfyUI-GGUF)
- `ComfyUI-Crystools` - [Link](https://github.com/crystian/ComfyUI-Crystools)  

---

### Run Container on Local

usage

```bash
# Usage
docker run -d -p 3000:3000 -p 8888:8888 --gpus all -e JUPYTERLAB_PASSWORD="" -e TIME_ZONE="Etc/UTC" -e COMFYUI_EXTRA_ARGS="" -e INSTALL_SAGEATTENTION="True" <Container Image>

# Example
docker run -d -p 3000:3000 -p 8888:8888 --gpus all -e JUPYTERLAB_PASSWORD="" -e TIME_ZONE="Etc/UTC" -e COMFYUI_EXTRA_ARGS="" -e INSTALL_SAGEATTENTION="True" sombi/comfyui-wan:i2v-14b-480p-torch2.6.0-cu124-dev
```

example

```bash

```

### Building Container

buildx bake

```bash
# Usage
docker buildx bake <target> 

# Example
docker buildx bake flf2v-14b 

# Build all targets
docker buildx bake all 

# Build and Push
docker buildx bake <target> --push 
```
