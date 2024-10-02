
tmux_session := mTLS

.PHONY: tmux
tmux: kill-tmux setup
	tmux new-session -d -s $(tmux_session) \; send-keys 'make run-server' C-m \; split-window -h \; send-keys 'make run-client' C-m \; attach

kill-tmux:
	@-tmux kill-session -t $(tmux_session)

run-server:
	go run ./server/main.go

run-client:
	sleep 1 # wait for server to start
	go run ./client/main.go

setup: clean
	openssl req -newkey rsa:2048 \
				-new \
				-nodes -x509 \
				-out cert.pem \
				-keyout key.pem \
				-addext "subjectAltName = DNS:localhost" \
				-subj "/C=UK/ST=Bristol/L=Bristol View/O=HPE Organization/OU=Storage Unit/CN=localhost"

clean:
	rm -f cert.pem key.pem
