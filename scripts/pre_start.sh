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
                model="wan2.1_t2v_14B_fp8_e4m3fn.safetensors"
                ;;
            "I2V-14B-720P")
                model="wan2.1_i2v_720p_14B_fp8_e4m3fn.safetensors"
                ;;
            "I2V-14B-480P")
                model="wan2.1_i2v_480p_14B_fp8_e4m3fn.safetensors"
                ;;
            "FLF2V-14B")
                model="wan2.1_flf2v_720p_14B_fp8_e4m3fn.safetensors"
                ;;
        esac
        huggingface-cli download Comfy-Org/Wan_2.1_ComfyUI_repackaged split_files/diffusion_models/$model --local-dir /workspace/comfyui-models/diffusion_models
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
    fi
fi

echo "**** syncing ComfyUI to workspace, please wait ****"
rsync -au --remove-source-files /ComfyUI/ /workspace/ComfyUI/ && rm -rf /ComfyUI
for dir in /comfyui-models/*/; do
    name=$(basename "$dir")
    ln -sf "$dir" "/workspace/ComfyUI/models/$name"
done
