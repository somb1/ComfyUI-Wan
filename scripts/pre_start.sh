#!/bin/bash

export PYTHONUNBUFFERED=1

echo "**** Setting the timezone based on the TIME_ZONE environment variable. If not set, it defaults to Etc/UTC. ****"
export TZ=${TIME_ZONE:-"Etc/UTC"}
echo "**** Timezone set to $TZ ****"
echo "$TZ" | sudo tee /etc/timezone > /dev/null
sudo ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

echo "**** syncing venv to workspace, please wait. This could take a while on first startup! ****"
rsync -au --remove-source-files /venv/ /workspace/venv/ && rm -rf /venv
# Updating '/venv' to '/workspace/venv' in all text files under '/workspace/venv/bin'
find "/workspace/venv/bin" -type f | while read -r file; do
    if file "$file" | grep -q "text"; then
        # VIRTUAL_ENV='/venv' → VIRTUAL_ENV='/workspace/venv'
        sed -i "s|VIRTUAL_ENV='/venv'|VIRTUAL_ENV='/workspace/venv'|g" "$file"
        
        # VIRTUAL_ENV '/venv' → VIRTUAL_ENV '/workspace/venv'
        sed -i "s|VIRTUAL_ENV '/venv'|VIRTUAL_ENV '/workspace/venv'|g" "$file"
        
        # #!/venv/bin/python → #!/workspace/venv/bin/python
        sed -i "s|#!/venv/bin/python|#!/workspace/venv/bin/python|g" "$file"

        # Uncomment to see which files are updated
        #echo "Updated: $file"
    fi
done

case "$DOWNLOAD_MODEL_AT_STARTUP" in
    "")
        echo "DOWNLOAD_MODEL_AT_STARTUP environment variable is not set. Skipping model download."
        ;;
    "T2V-14B"|"I2V-14B-720P"|"I2V-14B-480P"|"FLF2V-14B")
        echo "**** Starting model download. This may take some time... ****"
        case "$DOWNLOAD_MODEL_AT_STARTUP" in
            "T2V-14B")
                model_url="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-T2V-14B_fp8_e4m3fn.safetensors"
                ;;
            "I2V-14B-720P")
                model_url="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors"
                ;;
            "I2V-14B-480P")
                model_url="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors"
                ;;
            "FLF2V-14B")
                model_url="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-FLF2V-14B-720P_fp8_e4m3fn.safetensors"
                ;;
        esac

        model_dir="/workspace/ComfyUI/models/diffusion_models"
        model_filename=$(basename "$model_url")
        model_path="$model_dir/$model_filename"

        if [ ! -f "$model_path" ]; then
            echo "Downloading $model_filename..."
            wget -q "$model_url" -P "$model_dir"
        else
            echo "Model $model_filename already exists. Skipping download."
        fi
        ;;
esac

if [ "${INSTALL_SAGEATTENTION,,}" = "true" ]; then
    if pip show sageattention > /dev/null 2>&1; then
        echo "**** SageAttention is already installed. Skipping installation. ****"
    else
        echo "**** SageAttention is not installed. Installing, please wait.... (This may take a long time, approximately 5+ minutes.) ****"
        git clone https://github.com/thu-ml/SageAttention.git /SageAttention > /dev/null 2>&1
        cd /SageAttention
        python setup.py install > /dev/null 2>&1
        echo "**** SageAttention installation completed. ****"
    fi
fi

echo "**** syncing ComfyUI to workspace, please wait ****"
rsync -au --remove-source-files /ComfyUI/ /workspace/ComfyUI/ && rm -rf /ComfyUI
ln -sf /preinstalled_models/vae/* /workspace/ComfyUI/models/vae/
ln -sf /preinstalled_models/text_encoders/* /workspace/ComfyUI/models/text_encoders/
ln -sf /preinstalled_models/clip_vision/* /workspace/ComfyUI/models/clip_vision/
ln -sf /preinstalled_models/diffusion_models/* /workspace/ComfyUI/models/diffusion_models/
