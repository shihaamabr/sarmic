# BML-TG-NOTIFICATION

## Receive telegram notification when you receive money to your BML Account

### Requriements
`curl` `jq`
- Install with whatever package manager you use.
	
### Setup
```
curl https://raw.githubusercontent.com/shihaamabr/sarmic/master/bml-tg-notify/bml-tg-notify.sh > bml-tg-notify.sh
curl https://raw.githubusercontent.com/shihaamabr/sarmic/master/bml-tg-notify/env.sample > .env

```
edit the contents of .env to your config\
`echo XX > delay` where XX is the time in seconds you want to delay script run.

```
chmod +x bml-tg-notify.sh
./bml-tg-notify.sh
```

### Bugs
- You tell me :)
