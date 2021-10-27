# Cloudflare DDNS 

## Requirements
`bash curl jq screen`

## run 1 time 
`bash cfddns.sh`

## Run in screen 
`bash run-cfddns.sh`

## Run at boot
- Add to crontab `crontab -e`
`@reboot /bin/bash /root/ddns/run-ddns.sh`
