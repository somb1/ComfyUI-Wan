variable "DOCKERHUB_REPO_NAME" {
    default = "sombi/comfyui-wan"
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
    default = "-dev"
}

group "default" {
    targets = ["base", "t2v-14b", "i2V-14b-720p", "i2V-14b-480p"]
}

target "_common" {
    dockerfile = "Dockerfile"
    context = "."
    args = {
        BASE_IMAGE         = BASE_IMAGE
        PYTHON_VERSION     = PYTHON_VERSION
        TORCH_VERSION      = TORCH_VERSION
        CUDA_VERSION       = CUDA_VERSION
    }
    cache-from = ["type=gha"]
    cache-to   = ["type=gha,compression=zstd"]
}

target "base" {
    inherits = ["_common"]
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-base${EXTRA_TAG}"]
}

target "t2v-14b" {
    inherits = ["_common"]
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-t2v-14b${EXTRA_TAG}"]
    args = {
        PREINSTALLED_MODEL = "T2V-14B"
    }
}

target "i2V-14b-720p" {
    inherits = ["_common"]
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-i2V-14b-720p${EXTRA_TAG}"]
    args = {
        PREINSTALLED_MODEL = "I2V-14B-720P"
    }
}

target "i2V-14b-480p" {
    inherits = ["_common"]
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-i2V-14b-480p${EXTRA_TAG}"]
    args = {
        PREINSTALLED_MODEL = "I2V-14B-480P"
    }
}

target "flf2v-14b" {
    inherits = ["_common"]
    tags = ["${DOCKERHUB_REPO_NAME}:torch${TORCH_VERSION}-${CUDA_VERSION}-flf2v-14b${EXTRA_TAG}"]
    args = {
        PREINSTALLED_MODEL = "FLF2V-14B"
    }
}
