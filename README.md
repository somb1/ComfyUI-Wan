| Container Image | Description |
| :--- | :--- |
| **sombi/comfyui-wan:i2v-14b-720p-torch2.6.0-cu124-dev** | Wan2.1 Image-to-Video, 720p  |
| **sombi/comfyui-wan:i2v-14b-480p-torch2.6.0-cu124-dev** | Wan2.1 Image-to-Video, 480p |
| **sombi/comfyui-wan:flf2v-14b-torch2.6.0-cu124-dev** | Wan2.1 First-Last-Frame-to-Video, 720p |

# Building Containers

buildx bake

```bash
docker buildx bake <target> # Usage

docker buildx bake all # Build all targets
docker buildx bake flf2v-14b # Example

docker buildx bake <target> --push # Build and Push
```
