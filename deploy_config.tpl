# Configuration file for deploy_freenas.py

{{- $url := (splitN (env.Getenv "URL") "://" 2) }}

[deploy]
# Choose one of the following authentication methods, "api_key" or "password" (comment out the other one).
# Auth via API keys is highly recommended, but is only available from TrueNAS (Core) 12.0 up.
# You can generate a new API key in the web interface under "Settings" (upper right) > "API Keys".
{{- if ne (env.Getenv "API_KEY") "" }}
api_key = {{ env.Getenv "API_KEY" }}
{{- else if ne (env.Getenv "PASSWORD") "" }}
# If you are on FreeNAS 11 or lower, set this to your FreeNAS root password
password = {{ env.Getenv "PASSWORD" }}
{{- else }}
{{- fail "PASSWORD or API_KEY required" }}
{{- end }}

# Everything below here is optional

# cert_fqdn specifies the FQDN used for your certificate.  Default is your system hostname
# cert_fqdn = foo.bar.baz

# connect_host specifies the hostname the script should attempt to connect to, to deploy the cert.
# Default is localhost (assuming the script is running on your FreeNAS box)
connect_host = {{ index $url 1 }}

# verify sets whether the script will attempt to verify the server's certificate with a HTTPS
# connection.  Set to true if you're using a HTTPS connection to a remote host.  If connect_host
# is set to localhost (or is unset), set to false.  Default is false.
verify = {{ env.Getenv "TLS_VERIFY" "false" }}

# privkey_path is the path to the certificate private key on your system.  Default
# assumes you're using acme.sh:
# /root/.acme.sh/cert_fqdn/cert_fqdn.key
privkey_path = {{ env.Getenv "CERT_PRIVATE_KEY" "/cert/tls.key" }}

# fullchain_path is the path to the full chain (leaf cert + intermediate certs)
# on your system.  Default assumes you're using acme.sh:
# /root/.acme.sh/cert_fqdn/fullchain.cer
fullchain_path = {{ env.Getenv "CERT_FULLCHAIN" "/cert/tls.crt" }}

# protocol sets the connection protocol, http or https.  Include '://' at the end.
# Default is http
protocol = {{ index $url 0 }}://

# port sets the port to use to connect.  Default is 80.  If protocol is https,
# this MUST be set to your https port.
# port = 443

# set ftp_enabled to true if you have the FTP service enabled on your FreeNAS. Default is false.
ftp_enabled = {{ env.Getenv "FTP_ENABLED" "false" }}

# set webdav_enabled to true if you have the WEBDAV service enabled on your FreeNAS. Default is false.
webdav_enabled = {{ env.Getenv "WEBDAV_ENABLED" "false" }}

# Certificates will be given a name with a timestamp, by default it will be
# letsencrypt-yyyy-mm-dd-hhmmss.  You can change the first part if you like.
cert_base_name = {{ env.Getenv "CERT_BASE_NAME" "letsencrypt" }}
