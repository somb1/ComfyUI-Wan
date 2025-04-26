group "default" {
    targets = ["I2V-14B-720P"]
}

variable "DOCKERHUB_REPO_NAME" {
    default = "comfyui-wan"
}

variable "BASE_IMAGE" {
    default = "nvidia/cuda:12.4.1-runtime-ubuntu22.04"
}
variable "PYTHON_VERSION" {
    default = "3.12"
}
variable "TORCH_VERSION" {
    default = "2.6.0"
}
variable "CUDA_VERSION" {
    default = "cu124"
}

variable "EXTRA_TAG" {
    default = ""
}

target "I2V-14B-720P" {
    dockerfile = "Dockerfile"
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-i2V-14b-720p${EXTRA_TAG}"]
    context = "."
    args = {
        BASE_IMAGE         = BASE_IMAGE
        PYTHON_VERSION     = PYTHON_VERSION
        TORCH_VERSION      = TORCH_VERSION
        CUDA_VERSION       = CUDA_VERSION
        PREINSTALLED_MODEL_URL = "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors"
    }
}
