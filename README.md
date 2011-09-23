A thingie for making SSL keys, certs, and a self-signed CA that signs
them.

Add the ca.crt to your browser, and the server that's started with the
server.key and server.crt will be trusted.

Keep the server.key private to the server.  Keep the ca.key private to
yourself.  The ca.crt should be everywhere, and the server.crt should be
presented by the server to the client.

Update the cnf files with the appropriate configs for your use, and then
run "make".
