
all: ca.crl server.key server.crt

clean:
	attic=.attic/$(shell date -u +'%Y-%M-%d-%H-%m-%S'); \
	mkdir -p $$attic;\
	mv server.key $$attic;\
	mv server.crt $$attic;\
	mv server.csr $$attic;\
	mv ca.key $$attic;\
	mv ca.crt $$attic;\
	mv ca.srl $$attic;\
	mv ca.csr $$attic

# nothing to revoke, yet
ca.crl:
	touch ca.crl

ca.key: ca.cnf
	openssl req -new -x509 -days 3650 -config ca.cnf -keyout ca.key -out ca.crt

ca.csr: ca.cnf ca.key
	openssl req -new -config ca.cnf -key ca.key -out ca.csr -passin "pass:password"

ca.crt: ca.cnf ca.csr
	openssl x509 -req \
		-days 3650 \
		-in ca.csr \
		-signkey ca.key \
		-out ca.crt \
		-passin "pass:password"

server.key:
	openssl genrsa -out server.key

server.csr: server.cnf server.key
	openssl req -new -config server.cnf -key server.key -out server.csr


server.crt: server.csr ca.crt ca.key
	openssl x509 -req \
		-days 3650 \
		-in server.csr \
		-passin "pass:password" \
		-CA ca.crt \
		-CAkey ca.key \
		-CAcreateserial \
		-out server.crt

test: server.crt ca.crt
	@openssl verify \
		-CAfile ca.crt \
		-policy_check \
		-x509_strict \
		-check_ss_sig \
		server.crt &&\
	openssl verify \
		-CAfile ca.crt \
		-issuer_checks \
		-policy_check \
		-x509_strict \
		-check_ss_sig \
		ca.crt &&\
	node server.js

.PHONY: all test
