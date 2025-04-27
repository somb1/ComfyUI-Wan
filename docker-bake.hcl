variable "DOCKERHUB_REPO_NAME" {
    default = "sombi/comfyui-wan"
}

variable "BASE_IMAGE" {
    default = "nvidia/cuda:12.4.1-devel-ubuntu22.04"
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

function "tag" {
    params = [tag]
    result = ["${DOCKERHUB_REPO_NAME}:${tag}-torch${TORCH_VERSION}-${CUDA_VERSION}${EXTRA_TAG}"]
}

group "all" {
    targets = ["base"]
    default = "base"
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
    cache-to   = ["type=gha,compression=zstd"]
    cache-from = ["type=gha"]
}

target "base" {
    inherits = ["_common"]
    tags = tag("base")
}
